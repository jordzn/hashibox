#!/bin/bash
set -euo pipefail

# ARGS
# 1 = is server - true/false
# 2 = node name
# 3 = bind address
# 4 = cluster size // agent target server
# 5 - n = consul server members

yum install unzip bind-utils -y
unzip /tmp/synced_folder/consul_0.7.1_linux_amd64.zip -d /tmp
sudo mv /tmp/consul /usr/bin
sudo mkdir -p /etc/consul.d

if $1; then
  consul agent -server -data-dir=/tmp/consul -node=$2 -bind=$3 -bootstrap-expect=$4 -config-dir=/etc/consul.d -ui -client 0.0.0.0 &>/tmp/logs/$2.log &
  sleep 5
  consul join $5 $6 $7
else
  consul agent -data-dir=/tmp/consul -node=$2 -bind=$3 -config-dir=/etc/consul.d &>/dev/null &
  sleep 5
  consul join $4
fi
