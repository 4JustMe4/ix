{% extends '//die/go/build.sh' %}

{% block go_url %}
https://github.com/yaegashi/muslstack/archive/d19cc5866abce3ca59dfc1666df7cc97097d0933.zip
{% endblock %}

{% block go_sha %}
e044e27f1948ce305b159cef01e754f5e50fa342f07582a515482c2127c9e5bd
{% endblock %}

{% block build %}
go build main.go
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp main ${out}/bin/muslstack
{% endblock %}

{% block go_version %}
v3
{% endblock %}
