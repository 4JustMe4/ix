{% extends '//die/hub.sh' %}

{% block lib_deps %}
{% if linux %}
lib/bsd/impl/overlay
{% endif %}
{% endblock %}
