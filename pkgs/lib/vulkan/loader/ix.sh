{% extends 't/ix.sh' %}

{% block use_data %}
lib/vulkan/loader/data
{% endblock %}

{% block bld_tool %}
{{super()}}
bld/reloc
{% endblock %}

{% block configure %}
{{super()}}
relocate "${VULKAN_LOADER_DATA}"
{% endblock %}

{% block install %}
{{super()}}
mkdir -p ${out}/include
>${out}/include/keep
cd ${out}/lib
cp libvulkan.{{target.dl_suffix}} libvulkan.a
{% endblock %}
