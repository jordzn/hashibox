# Vagrant Datacenter

A repository used for offline local testing and development.

## Commands

Bring up all nodes
`vagrant up`

SSH into a node
`vagrant ssh server-X`

Bring up an individual node
`vagrant up consul-X`
`vagrant up vault-X`

Destroy an individual node
`vagrant destroy consul-X`
`vagrant destroy vault-X`

Destroy all nodes
`vagrant destroy -f`


## Tests

Does Vault HA result in backed up secrets?

Can all Vault nodes be destroyed and come back into the same cluster?

Can the master Consul server be destroyed and not affect Vault?

What happens when all Vault servers are killed?

What happens when 2/3 Vault servers are killed?
