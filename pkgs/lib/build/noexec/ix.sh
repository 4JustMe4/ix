{% extends '//die/env.sh' %}

{% block env %}
export LDFLAGS="-Wl,-z,noexecstack ${LDFLAGS}"
{% endblock %}
