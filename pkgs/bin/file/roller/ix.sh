{% extends '//die/hub.sh' %}

{% block run_deps %}
org/freedesktop/portal/desktop
bin/file/roller/unwrap(gtk_ver=3)
bin/xdg/er(wrap=file-roller)
{% endblock %}
