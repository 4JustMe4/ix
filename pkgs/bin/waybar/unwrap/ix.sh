{% extends '//die/c/meson.sh' %}

{% block fetch %}
https://github.com/Alexays/Waybar/archive/refs/tags/0.10.2.tar.gz
sha:7ecccfe5d326d66987a32e77e02b825019d191670ab8e87412df01dd0913f9c0
{% endblock %}

{% block bld_libs %}
lib/c
lib/nl
lib/c++
lib/fmt
lib/udev
lib/date
lib/evdev
lib/sndio
lib/input
lib/upower
lib/spdlog
lib/wayland
lib/sigc++/2
lib/gtk/3/mm
lib/json/cpp
lib/dbus/menu
lib/xkb/common
lib/app/indicator
lib/gtk/layer/shell
{% endblock %}

{% block bld_tool %}
bin/scdoc
bld/wayland
bld/glib
{% endblock %}

{% block meson_flags %}
tests=disabled
rfkill=enabled
dbusmenu-gtk=enabled
{% endblock %}

{% block build_flags %}
shut_up
{% endblock %}

{% block c_rename_symbol %}
list_init
list_insert
list_append
list_remove
list_empty
{% endblock %}
