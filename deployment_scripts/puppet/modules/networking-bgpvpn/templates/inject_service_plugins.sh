#!/bin/bash
set -e
usage() {
    echo "usage: $0 <neutron-conf-file> <service_plugins_to_add>" >&2
}
if [[ $# -ne 2 ]]; then
    usage
    exit
fi
conf_file=$1
service_plugin=$2
if [ -e conf_file ]; then
    echo "File: $conf_file not found."
    exit 1
fi
if ! grep -q "$service_plugin" $conf_file ; then
    service_plugins_v1=$(grep "^service_plugins" $conf_file | awk {'print $3'})
    service_plugins_v2=$(grep "^service_plugins" $conf_file | awk {'print $2'})
    service_plugins=${service_plugins_v1:-$service_plugins_v2}
    sed -i "s/$service_plugins/$service_plugins,$service_plugin/" $conf_file
fi

if ! grep -q "$service_plugin" $conf_file; then
    echo "Could not add $service_plugin as service plugin in $conf_file."
    exit 2
fi
