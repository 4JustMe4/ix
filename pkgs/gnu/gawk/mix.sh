{% extends '//mix/template/autohell.sh' %}

{% block fetch %}
# url https://mirror.tochlab.net/pub/gnu/gawk/gawk-5.1.0.tar.xz
# md5 8470c34eeecc41c1aa0c5d89e630df50
{% endblock %}

{% block bld_deps %}
lib/intl/mix.sh
lib/iconv/mix.sh
lib/sigsegv/mix.sh
env/c/mix.sh
boot/final/env/tools/mix.sh
boot/final/env/bison/mix.sh
{% endblock %}

{% block cflags %}
export CPPFLAGS="-Derr=gawk_err -Dxmalloc=gawk_xmalloc -Dxrealloc=Dgawk_xrealloc -Dregcomp=gawk_regcomp -Dregfree=gawk_regfree ${CPPFLAGS}"
{% endblock %}

{% block coflags %}
--libexecdir=${out}/bin/awk_exec
--disable-extensions
{% endblock %}

{% block test %}
export PATH="${out}/bin:${PATH}"
cd test
make basic
{% endblock %}
