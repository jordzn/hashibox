#!/bin/bash
set -euo pipefail

# ARGS
# 1 = node count

unzip /tmp/synced_folder/vault_0.6.2_linux_amd64.zip -d /tmp
sudo mkdir /etc/vault
sudo mv /tmp/vault /usr/bin
sudo cp /tmp/config/vault/vault.hcl /etc/vault/vault.hcl
sudo chown root:root /etc/vault/vault.hcl
sudo chmod 0644 /etc/vault/vault.hcl
export VAULT_ADDR=http://127.0.0.1:8200
echo "export VAULT_ADDR=http://127.0.0.1:8200" >> ~/.bash_profile
sudo vault server -config=/etc/vault/vault.hcl &>/tmp/logs/vault-$1.log &

if [[ $1 == 0 ]]; then
  vault init -key-shares=5 -key-threshold=3 >> /tmp/config/vault/keys || true
fi

for (( i = 1; i < 4; i++ )); do
  KEY=`grep "Unseal Key $i:" /tmp/config/vault/keys | cut -c 15-` && vault unseal $KEY -address=http://127.0.0.1:8200
done

sudo mkdir -p /etc/consul.d
sudo cp /tmp/config/vault/vault-leader.json /etc/consul.d/vault-leader.json
