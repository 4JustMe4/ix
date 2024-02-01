{% extends '//die/c/make.sh' %}

{% block fetch %}
https://github.com/rhboot/efivar/archive/refs/tags/39.tar.gz
sha:c9edd15f2eeeea63232f3e669a48e992c7be9aff57ee22672ac31f5eca1609a6
{% endblock %}

{% block lib_deps %}
lib/c
{% endblock %}

{% block bld_libs %}
lib/popt
lib/kernel
{% endblock %}

{% block bld_tool %}
bin/mandoc
{% endblock %}

{% block patch %}
ln -s libefivar.so src/libefivar.a
ln -s libefisec.so src/libefisec.a
{% endblock %}

{% block cpp_defines %}
_GNU_SOURCE=1
{% endblock %}

{% block cpp_includes %}
${PWD}
{% endblock %}

{% block make_flags %}
AR=llvm-ar
NM=llvm-ar
LD_DASH_T=-T
LIBDIR=${out}/lib
RANLIB=llvm-ranlib
{% endblock %}

{% block build_flags %}
wrap_cc
{% endblock %}

{% block install %}
{{super()}}
cp ${out}/lib/libefivar.so ${out}/lib/libefivar.a
cp ${out}/lib/libefisec.so ${out}/lib/libefisec.a
cp ${out}/lib/libefiboot.so ${out}/lib/libefiboot.a
{% endblock %}

{% block env %}
export CPPFLAGS="-I${out}/include/efivar \${CPPFLAGS}"
{% endblock %}
