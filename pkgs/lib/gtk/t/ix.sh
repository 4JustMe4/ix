{% extends '//die/c/meson.sh' %}

{% block lib_deps %}
lib/c
lib/glib
lib/cairo
lib/pango
lib/epoxy
lib/wayland
lib/graphene
lib/freetype
lib/xkb/common
lib/fontconfig
lib/gdk/pixbuf
{% endblock %}

{% block bld_libs %}
lib/kernel
{% endblock %}

{% block bld_tool %}
bld/gettext
bld/wayland
bld/glib
{% endblock %}

{% block run_data %}
{{gtk_icons or 'aux/adwaita/icons'}}
{% endblock %}
