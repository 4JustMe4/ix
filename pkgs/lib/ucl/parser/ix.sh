{% extends '//die/c/autorehell.sh' %}

{% block fetch %}
https://github.com/vstakhov/libucl/archive/refs/tags/0.9.2.tar.gz
sha:f63ddee1d7f5217cac4f9cdf72b9c5e8fe43cfe5725db13f1414b0d8a369bbe0
{% endblock %}

{% block lib_deps %}
lib/c
{% endblock %}
