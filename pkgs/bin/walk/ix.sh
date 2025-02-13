{% extends '//die/go/build.sh' %}

{% block go_url %}
https://github.com/antonmedv/walk/archive/refs/tags/v1.7.0.tar.gz
{% endblock %}

{% block go_sha %}
965f4dfe8127f506d7902cc901bfe572691442c902e816173e12a9309a11c8af
{% endblock %}

{% block go_refine %}
sed -e 's|go 1.17|go 1.21|' -i go.mod
go mod tidy -compat=1.21
{% endblock %}

{% block install %}
mkdir ${out}/bin
cp walk ${out}/bin/
{% endblock %}
