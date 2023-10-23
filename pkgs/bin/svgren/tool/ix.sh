{% extends '//bin/svgren/ix.sh' %}

{% block patch %}
{{super()}}
sed -e 's|svgren::rasterize.*|svgren::rasterize(*dom, svgren::parameters{ { {{render_w}}, {{render_h}} }, 96}));|' -i tests/render/main.cpp
{% endblock %}
