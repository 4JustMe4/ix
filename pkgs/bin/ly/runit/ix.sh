{% extends '//die/hub.sh' %}

{% block run_deps %}
bin/runsrv
bin/fixtty
bin/ly/scripts
bin/ly/sys
bin/ly/runit/scripts
{% endblock %}
