{% extends '//die/go/pure.sh' %}

{% block go_url %}
https://github.com/wtfutil/wtf/archive/refs/tags/v0.41.0.tar.gz
{% endblock %}

{% block go_sha %}
sha:6bfa1141fec6be6f6b58249bb0595f9aa7cd3978f9205a8be0f12922990be8b1
{% endblock %}

{% block go_build_flags %}
-o wtfutil
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp wtfutil ${out}/bin/
{% endblock %}
