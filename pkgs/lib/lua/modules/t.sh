{% extends '//die/c/ix.sh' %}

{% block lib_deps %}
lib/c
lib/lua/modules/env
{% endblock %}

{% block bld_libs %}
lib/lua
{% endblock %}

{% block use_data %}
{% if lib %}
{{name}}(lua_ver={{lua_ver or error()}})
{% endif %}
{% endblock %}

{% block build %}
for x in *.c; do
    cc -c ${x}
done

ar qs lib{{uniq_id}}.a *.o
{% endblock %}

{% block install %}
mkdir -p ${out}/lib ${out}/share/lua
cp lib{{uniq_id}}.a ${out}/lib/
cp *.lua ${out}/share/lua/
nm lib{{uniq_id}}.a | grep luaopen_ > ${out}/share/lua/mod
{% endblock %}

{% block script_init_env %}
export LUA_PATH=
{{super()}}
{% endblock %}

{% block env %}
export LUA_PATH="${out}/share/lua:\${LUA_PATH}"
{% endblock %}

{% block postinstall %}
echo 'TODO(pg): move mod file from share'
{% endblock %}
