{% extends '//die/go/pure.sh' %}

{% block go_url %}
https://github.com/go-task/task/archive/refs/tags/v3.14.0.tar.gz
{% endblock %}

{% block go_sha %}
sha:05c192acd1d139a7faa5f526c307fcbce0c2fdf2de3d2e243d8b65a333d089e0
{% endblock %}

{% block unpack %}
{{super()}}
cd cmd/task
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp task ${out}/bin/
{% endblock %}
