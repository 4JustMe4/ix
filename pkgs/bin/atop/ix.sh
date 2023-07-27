{% extends '//die/c/make.sh' %}

{% block fetch %}
https://www.atoptool.nl/download/atop-2.9.0.tar.gz
sha:8d82f211b712a227000ef254c0a2b53bcb71235bf40d93316acce80b04bff926
{% endblock %}

{% block bld_libs %}
lib/c
lib/z
lib/kernel
lib/curses
{% endblock %}

{% block blt_tool %}
bin/getopt
{% endblock %}

{% block patch %}
sed -e 's|/bin/systemctl|qqq|g' -i Makefile
{% endblock %}

{% block cpp_missing %}
time.h
{% endblock %}

{% block make_flags %}
BINPATH=${out}/bin
SBINPATH=${out}/bin
SCRPATH=${out}/share/atop
LOGPATH=${out}/var/log/atop
MAN1PATH=${out}/share/man/man1
MAN5PATH=${out}/share/man/man5
MAN8PATH=${out}/share/man/man8
INIPATH=${out}/etc/init.d
DEFPATH=${out}/etc/default
SYSDPATH=${out}/share/systemd/system
CRNPATH=${out}/etc/cron.d
ROTPATH=${out}/etc/logrotate.d
PMPATH1=${out}/share/pm-utils/sleep.d
PMPATH2=${out}/share/pm-utils/sleep.d
PMPATHD=${out}/share/systemd/system-sleep
{% endblock %}
