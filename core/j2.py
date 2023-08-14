import os
import base64
import jinja2


def b64(data):
    return base64.b64encode(data.encode()).decode()


def b64d(data):
    return base64.b64decode(data).decode()


def cut_include(l):
    l = l.strip()

    if l.startswith('{% include'):
        l = l[l.find("'") + 1:]
        l = l[:l.find("'")]

        return l


class Env(jinja2.Environment, jinja2.BaseLoader):
    def __init__(self, vfs):
        jinja2.Environment.__init__(self, loader=self, auto_reload=False, trim_blocks=True, lstrip_blocks=True)
        self.cache = {}
        self.vfs = vfs
        self.filters['b64'] = b64
        self.filters['b64e'] = b64
        self.filters['b64d'] = b64d


    def resolve_includes(self, data, name):
        def it():
            for l in data.split('\n'):
                if inc := cut_include(l):
                    yield self.source(self.join_path(inc, name))[0]
                else:
                    yield l

        return '\n'.join(it())

    def get_source(self, env, name):
        x, y = self.source(name)

        return x, y, lambda: True

    def source(self, name):
        while True:
            try:
                return self.cache[name]
            except KeyError:
                self.cache[name] = self.calc_source(name)

    def calc_source(self, name):
        if name.startswith('//'):
            return self.source(name[2:])

        if name.endswith('/base64'):
            d, n = self.source(name[:-7])

            return b64(d), n

        data = self.resolve_includes(self.vfs.serve(name), name)

        if '.raw' not in name:
            data = data.strip()

        return data, name

    def join_path(self, tmpl, parent):
        if tmpl.startswith('//'):
            return tmpl

        return os.path.join(os.path.dirname(parent), tmpl)
