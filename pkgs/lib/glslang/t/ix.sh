{% extends '//die/c/cmake.sh' %}

{% block fetch %}
https://github.com/KhronosGroup/glslang/archive/refs/tags/sdk-1.3.224.1.tar.gz
sha:42688248855581cd6a338a483a9068a27a9a3502cfd0256afc98b836722504cc
#https://github.com/KhronosGroup/glslang/archive/refs/tags/sdk-1.3.236.0.tar.gz
#sha:fb6f323a36efcd98766bb72f598008f73c4c92bce69c79fc98ad2b3cdca0c263
#https://github.com/KhronosGroup/glslang/archive/refs/tags/11.13.0.tar.gz
#sha:592c98aeb03b3e81597ddaf83633c4e63068d14b18a766fd11033bad73127162
{% endblock %}

{% block bld_tool %}
bld/bison
bld/python
{% endblock %}

{% block lib_deps %}
lib/c
lib/vulkan/spirv/tools
lib/vulkan/spirv/headers
{% endblock %}

{% block patch %}
sed -e 's|.*add_link_options.*||' -e 's|.*set.*ENABLE_OPT.*||' -i CMakeLists.txt
{% endblock %}

{% block cmake_flags %}
ENABLE_OPT=ON
{% endblock %}
