{% extends '//die/c/make.sh'  %}

{% block fetch %}
https://github.com/lm-sensors/lm-sensors/archive/refs/tags/V3-6-0.tar.gz
sha:0591f9fa0339f0d15e75326d0365871c2d4e2ed8aa1ff759b3a55d3734b7d197
{% endblock %}

{% block bld_libs %}
lib/c
lib/kernel
{% endblock %}

{% block bld_tool %}
bld/flex
bld/bison
bld/shebangs
{% endblock %}

{% block build_flags %}
wrap_cc
{% endblock %}

{% block make_flags %}
CC=clang
SBINDIR=${out}/bin
ETCDIR=${out}/etc
{% endblock %}

{% block install %}
{{super()}}
fix_shebangs ${out}/bin/fancontrol ${out}/bin/pwmconfig
{% endblock %}
