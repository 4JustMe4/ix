{% extends '//die/go/build.sh' %}

{% block go_url %}
https://github.com/pg83/mdns2dns/archive/refs/tags/v1.tar.gz
{% endblock %}

{% block go_sha %}
3c1007d1f94deb6703914b23690b9ac5f6ee45e30306c7c6b392a3cefa46be28
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp mdns2dns ${out}/bin/
{% endblock %}

{% block go_version %}
v3
{% endblock %}
