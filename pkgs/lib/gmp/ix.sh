{% extends '//die/c/autorehell.sh' %}

{% block fetch %}
#https://gmplib.org/download/gmp/gmp-6.2.1.tar.lz
#md5:03a31d8cbaf29d136252f8f38875ed82
https://github.com/stal-ix/sources/raw/main/gmp-6.2.1.tar.xz
sha:fd4829912cddd12f84181c3451cc752be224643e87fac497b69edddadc49b4f2
{% endblock %}

{% block lib_deps %}
lib/c
{% endblock %}

{% block host_libs %}
lib/c
{% endblock %}

{% block bld_tool %}
bld/m4
bld/perl
bld/texinfo
{% endblock %}

{% block env %}
export COFLAGS="--with-gmp=${out} --with-libgmp-prefix=${out} \${COFLAGS}"
{% endblock %}
