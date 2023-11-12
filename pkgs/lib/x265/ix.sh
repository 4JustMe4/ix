{% extends '//die/c/cmake.sh' %}

{% block fetch %}
https://bitbucket.org/multicoreware/x265_git/downloads/x265_3.5.tar.gz
sha:e70a3335cacacbba0b3a20ec6fecd6783932288ebc8163ad74bcc9606477cae8
{% endblock %}

{% block unpack %}
{{super()}}
cd source
{% endblock %}

{% block cmake_flags %}
ENABLE_SHARED=OFF
{% if x86_64 %}
ENABLE_ASSEMBLY=ON
{% else %}
ENABLE_ASSEMBLY=OFF
{% endif %}
{% endblock %}

{% block lib_deps %}
lib/c
{% endblock %}

{% block bld_tool %}
bld/fakegit
{% endblock %}

{% block test %}
test -f ${out}/lib/pkgconfig/x265.pc
{% endblock %}
