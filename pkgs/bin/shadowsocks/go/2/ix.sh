{% extends '//die/go/pure.sh' %}

{% block go_url %}
https://github.com/shadowsocks/go-shadowsocks2/archive/refs/tags/v0.1.5.tar.gz
{% endblock %}

{% block go_sha %}
sha:890788bd014257e657f84b7a64f046798139110c3dea7e0c2d747b1d8bb4d3a0
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp go-shadowsocks2 ${out}/bin/
{% endblock %}
