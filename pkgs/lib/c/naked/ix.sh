{% extends '//die/hub.sh' %}

{% block lib_deps %}
{% if linux %}
lib/{{libc or 'musl/noalloc'}}
{% endif %}
{% if darwin %}
lib/darwin/c
{% endif %}
{% if wasi %}
lib/wasi/c
{% endif %}
{% endblock %}
