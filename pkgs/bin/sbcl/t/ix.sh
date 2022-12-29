{% extends '//die/c/ix.sh' %}

{% block bld_libs %}
lib/z/dl
lib/kernel
{% endblock %}

{% block bld_tool %}
bld/make
bld/dlfcn
{% endblock %}

{% block setup %}
export CFLAGS="-fcommon ${CFLAGS}"
{% endblock %}

{% block patch %}
cat << EOF | sort | uniq | (while read l; do echo "sbcl ${l} ${l}"; done) | dl_stubs > symbols.c
{% block extern_symbols %}
{% include 'libc' %}
{% endblock %}
EOF

sed -e '5,$d' -i contrib/sb-posix/posix-tests.lisp
sed -e 's|test:|testxxx:|' -i contrib/asdf-module.mk
echo 'test:' >> contrib/asdf-module.mk
{% endblock %}

{% block build %}
clang -fno-builtin -c symbols.c -o ${tmp}/symbols.o

export LDLIBS="${tmp}/symbols.o"

{% block prebuild_xxx %}
ulimit -s 60000
{% endblock %}

sh make.sh sbcl \
    --prefix=${out} \
    --xc-host='{{self.boot_lisp().strip()}}' \
    --with-sb-ldb \
    --with-sb-thread \
    --with-sb-core-compression \
    --with-os-provides-dlopen
{% endblock %}

{% block install %}
sh install.sh
{% endblock %}

{% block postinstall %}
echo 'TODO(pg): move sbcl.core to proper place'
{% endblock %}
