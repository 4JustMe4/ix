{% extends '//lib/sd/bus/c++/t/ix.sh' %}

{% block bld_libs %}
{{super()}}
lib/expat
{% endblock %}

{% block cmake_flags %}
{{super()}}
BUILD_CODE_GEN=ON
{% endblock %}
