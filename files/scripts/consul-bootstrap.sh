#!/bin/bash
set -euo pipefail

# ARGS
# 1 = is server - true/false
# 2 = node name
# 3 = bind address
# 4 = cluster size // agent target server
# 5 = is initial server - true/false
# 6 - n = consul server members


yum install unzip bind-utils -y
unzip /tmp/synced_folder/consul_0.8.3_linux_amd64.zip -d /tmp
sudo mv /tmp/consul /usr/bin
sudo mkdir -p /etc/consul.d

if $1; then
  if $5; then
    consul agent -server -data-dir=/tmp/consul -node=$2 -bind=$3 -bootstrap-expect=$4 -config-dir=/etc/consul.d -ui -client 0.0.0.0 &>/tmp/logs/$2.log &
    sleep 5
  else
    consul agent -server -data-dir=/tmp/consul -node=$2 -bind=$3 -bootstrap-expect=$4 -config-dir=/etc/consul.d -ui -client 0.0.0.0 &>/tmp/logs/$2.log &
    sleep 5
    consul join $6
  fi
else
  consul agent -data-dir=/tmp/consul -node=$2 -bind=$3 -config-dir=/etc/consul.d &>/dev/null &
  sleep 5
  consul join $4
fi
