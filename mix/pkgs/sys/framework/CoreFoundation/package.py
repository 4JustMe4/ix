{% extends '//util/env.py' %}

{% block env %}
export LDFLAGS="-framework CoreFoundation $LDFLAGS"
{% endblock %}
