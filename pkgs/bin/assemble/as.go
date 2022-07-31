package main

import (
	"encoding/json"
	"fmt"
	"io"
	"os"
	"os/exec"
	"strings"
	"sync"
	"syscall"
)

type Exception struct {
	what func() error
}

func (self *Exception) throw() {
	panic(self)
}

func (self *Exception) catch(cb func(*Exception)) {
	if self != nil {
		cb(self)
	}
}

func (self *Exception) fatal(code int, prefix string) {
	fmt.Fprintf(os.Stderr, "%s%s: %v%s\n", R, prefix, self.what(), RST)
	os.Exit(code)
}

func newException(e error) *Exception {
	return &Exception{
		what: func() error {
			return e
		},
	}
}

func fmtException(format string, args ...any) *Exception {
	return newException(fmt.Errorf(format, args...))
}

func try(cb func()) (err *Exception) {
	defer func() {
		if rec := recover(); rec != nil {
			if exc, ok := rec.(*Exception); ok {
				err = exc
			} else {
				// personality check failed
				panic(rec)
			}
		}
	}()

	cb()

	return nil
}

const (
	ESC = "\x1b"
	RST = ESC + "[0m"
	R   = ESC + "[91m"
	G   = ESC + "[92m"
	Y   = ESC + "[93m"
	B   = ESC + "[94m"
)

func color(color string, s string) string {
	return color + s + RST
}

type semaphore struct {
	ch chan struct{}
}

func newSemaphore(n int) *semaphore {
	return &semaphore{
		ch: make(chan struct{}, n),
	}
}

func (self *semaphore) acquire(n int) {
	for i := 0; i < n; i += 1 {
		self.ch <- struct{}{}
	}
}

func (self *semaphore) release(n int) {
	for i := 0; i < n; i += 1 {
		<-self.ch
	}
}

type Cmd struct {
	Args  []string          `json:"args"`
	Stdin string            `json:"stdin"`
	Env   map[string]string `json:"env"`
}

type Node struct {
	InDirs  []string `json:"in_dir"`
	OutDirs []string `json:"out_dir"`
	Cmds    []Cmd    `json:"cmd"`
	Pool    string   `json:"pool"`
	Net     *bool    `json:"net,omitempty"`
}

type Graph struct {
	Nodes   []Node         `json:"nodes"`
	Targets []string       `json:"targets"`
	Pools   map[string]int `json:"pools"`
}

func newGraph(r io.Reader) *Graph {
	graph := &Graph{}

	if err := json.NewDecoder(r).Decode(graph); err != nil {
		fmtException("can not parse input graph: %w", err).throw()
	}

	return graph
}

func (self *Graph) execute() {
	newExecutor(self).visitAll(self.Targets)
}

func toFiles(dirs []string) []string {
	res := []string{}

	for _, d := range dirs {
		res = append(res, d+"/touch")
	}

	return res
}

func outs(node *Node) []string {
	return toFiles(node.OutDirs)
}

func ins(node *Node) []string {
	return toFiles(node.InDirs)
}

func checkExists(path string) bool {
	_, err := os.Stat(path)

	return err == nil
}

func env(cmd *Cmd) []string {
	ret := []string{}

	for k, v := range cmd.Env {
		ret = append(ret, k+"="+v)
	}

	ret = append(ret, "make_thrs=14")

	return ret
}

func lookupPath(prog string, path string) string {
	if prog[:1] == "/" {
		return prog
	}

	for _, p := range strings.Split(path, ":") {
		pp := p + "/" + prog

		if checkExists(pp) {
			return pp
		}
	}

	fmtException("can not find %s in %s", prog, path).throw()
	panic(nil)
}

func complete(node *Node) bool {
	for _, o := range outs(node) {
		if !checkExists(o) {
			return false
		}

		fmt.Println(color(G, "READY "+o))
	}

	return true
}

func executeCmd(c *Cmd, net bool) error {
	args := []string{}

	if !net {
		// unshare network namespace
		args = append(args, "/bin/unshare", "-r", "-n")
	}

	// resolve full path to real binary
	args = append(args, lookupPath(c.Args[0], c.Env["PATH"]))

	// and add rest
	args = append(args, c.Args[1:]...)

	cmd := &exec.Cmd{
		Path:   args[0],
		Args:   args,
		Env:    env(c),
		Dir:    "/",
		Stdin:  strings.NewReader(c.Stdin),
		Stdout: os.Stderr,
		Stderr: os.Stderr,
	}

	return cmd.Run()
}

func cat[T any](a []T, b []T) []T {
	return append(append([]T{}, a...), b...)
}

func executeNode(node *Node) {
	net := node.Net != nil && *node.Net
	nouts := outs(node)

	for _, o := range nouts {
		fmt.Println(color(B, fmt.Sprintf("ENTER [net=%v] %s", net, o)))
	}

	for i := range node.Cmds {
		cmd := &node.Cmds[i]

		if err := executeCmd(cmd, net); err != nil {
			fmtException("%v failed with %w", cat(nouts, cmd.Args), err).throw()
		}
	}

	syscall.Sync()

	for _, o := range outs(node) {
		if file, err := os.Create(o); err == nil {
			file.Close()
		}

		fmt.Println(color(B, "LEAVE "+o))
	}

	syscall.Sync()
}

type future struct {
	f func()
	o sync.Once
}

func (self *future) callOnce() {
	self.o.Do(self.f)
}

type nodectx struct {
	node   *Node
	future *future
}

type executor struct {
	out map[string]*nodectx
	sem map[string]*semaphore
}

func (self *executor) execute(node *Node) {
	if complete(node) {
		return
	}

	self.visitAll(ins(node))
	sem, _ := self.sem[node.Pool]
	sem.acquire(1)
	defer sem.release(1)
	executeNode(node)
}

func newNodeFuture(ex *executor, node *Node) *future {
	return &future{f: func() {
		ex.execute(node)
	}}
}

func newExecutor(graph *Graph) *executor {
	res := &executor{
		out: map[string]*nodectx{},
		sem: map[string]*semaphore{},
	}

	// construct backrefs
	for i := range graph.Nodes {
		node := &graph.Nodes[i]

		cont := &nodectx{
			node:   node,
			future: newNodeFuture(res, node),
		}

		for _, out := range outs(node) {
			if _, ok := res.out[out]; ok {
				fmtException("multiple nodes generate output %s", out).throw()
			}

			res.out[out] = cont
		}
	}

	// construct scheduler
	for pool, count := range graph.Pools {
		res.sem[pool] = newSemaphore(count)
	}

	// validate
	for _, node := range graph.Nodes {
		for _, in := range ins(&node) {
			if _, ok := res.out[in]; !ok {
				fmtException("no node generate %s", in).throw()
			}
		}

		if _, ok := res.sem[node.Pool]; !ok {
			fmtException("bad pool %s", node.Pool).throw()
		}
	}

	return res
}

func (self *executor) visitAll(nodes []string) {
	wg := &sync.WaitGroup{}
	defer wg.Wait()

	for _, n := range nodes {
		o := self.out[n]

		wg.Add(1)

		go func() {
			defer wg.Done()

			try(func() {
				o.future.callOnce()
			}).catch(func(exc *Exception) {
				exc.fatal(2, "subcommand error")
			})
		}()
	}
}

func main() {
	try(func() {
		newGraph(os.Stdin).execute()
	}).catch(func(exc *Exception) {
		exc.fatal(1, "abort")
	})
}
