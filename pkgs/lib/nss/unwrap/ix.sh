{% extends '//lib/nss/t/ix.sh' %}

{% block install %}
{{super()}}
mkdir ${out}/include
cp -R ../dist/public/* ${out}/include/
cd ${out}/lib
rm *.TOC *_static.a
for x in *.so; do
    mv ${x} $(echo ${x} | sed -e 's|3.so|.a|' | sed -e 's|.so|.a|')
done
{% endblock %}

{% block env %}
{{super()}}
export NSS_HEADERS=${out}/include/nss
{% endblock %}
