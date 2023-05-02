{% extends '//lib/musl/t/ix.sh' %}

{% block cpp_defines %}
__libc_realloc=realloc
__libc_free=free
__libc_malloc=malloc
__libc_calloc=calloc
{% endblock %}

{% block patch %}
{{super()}}
>src/legacy/valloc.c
>src/malloc/lite_malloc.c
{% endblock %}

{% block install %}
(
{{super()}}
)

rm -rf ${out}/lib/libc.a obj/src/malloc

# add missing open64
cp obj/src/fcntl/open.o obj/src/fcntl/open64.o
llvm-objcopy --redefine-sym=open=open64 obj/src/fcntl/open64.o

# add missing pread64
cp obj/src/unistd/pread.o obj/src/unistd/pread64.o
llvm-objcopy --redefine-sym=pread=pread64 obj/src/unistd/pread64.o

ar q ${out}/lib/libc.a $(find obj -type f -name '*.o' | sort)
ranlib ${out}/lib/libc.a
{% endblock %}

{% block env %}
{{super()}}
export CPPFLAGS="-D__STDC_ISO_10646__=201505L \${CPPFLAGS}"
{% endblock %}
