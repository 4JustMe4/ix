{% extends '//bin/python/10/ix.sh' %}

{% block lib_deps %}
{% endblock %}

{% block bld_libs %}
lib/c
lib/z
lib/ffi
{% if darwin %}
lib/darwin/framework/SystemConfiguration
{% endif %}
{{super()}}
{% endblock %}

{% block bld_tool %}
bld/auto
{{super()}}
{% endblock %}

{% block extra_modules %}
_ctypes _ctypes/_ctypes.c _ctypes/callbacks.c _ctypes/callproc.c _ctypes/stgdict.c _ctypes/cfield.c _ctypes/malloc_closure.c
{% endblock %}

{% block setup_target_flags %}
{% endblock %}

{% block env %}
{% endblock %}
