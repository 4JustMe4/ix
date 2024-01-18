{% extends '//die/c/ix.sh' %}

{% block use_network %}true{% endblock %}

{% block std_box %}
bld/rust
bld/python
aux/ca/bundle
{{super()}}
{% endblock %}

{% block host_libs %}
lib/shim/fake(lib_name=gcc_s)
{% endblock %}

{% block setup %}
export CARGO_BUILD_JOBS=${make_thrs}
export CARGO_INSTALL_ROOT=${out}
export CARGO_HOME=${tmp}/obj
export SSL_CERT_FILE=${CA_BUNDLE}
{% endblock %}

{% block setup_tools %}
export TARGET_CC=$(which cc)

cat << EOF > cc
#!/usr/bin/env python3

import sys
import subprocess

target_cc="${TARGET_CC}"
host_cc="${HOST_CC}"

def flt_target(cmd):
    for x in cmd:
        if 'self-contained' in x and '.o' in x:
            continue
        elif '-Wl,' in x:
            continue
        elif x == '-static-pie':
            continue
        else:
            yield x

def flt_host(cmd):
    return cmd

if '--no' in str(sys.argv):
    cc = host_cc
else:
    cc = target_cc

#subprocess.check_call([cc] + sys.argv[1:])

try:
    subprocess.check_call([cc] + sys.argv[1:])
except:
    subprocess.check_call(list(flt_target([cc] + sys.argv[1:])))
EOF

chmod +x cc
{% endblock %}

{% set cargo_options %}
{% block cargo_options %}
{% endblock %}
{% endset %}

{% block build %}
cargo build --release {{ix.fix_list(cargo_options)}}
{% endblock %}

{% block install %}
cargo install --path .
{% endblock %}
