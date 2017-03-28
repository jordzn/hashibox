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

###Does Vault HA result in backed up secrets?

###Can all Vault nodes be destroyed and come back into the same cluster?
From Host command line:
- vagrant destroy vault-0 vault-1 vault-2 -f
//destroy all Vault servers
//at this point Consul is now aware that the cluster is down
- vagrant up
//re-activate the 3 destroyed Vault servers
//the same keys from the previous cluster were used (because the HA backend takes this authentication)
//all 3 nodes re-joined the cluster. Consul considered the Vault cluster as healthy
//vault-0 elected as leader, vault-1 and vault-2 remain passive

###Can the active master Consul server be destroyed and not affect Vault?
From Host command line:
- vagrant destroy consul-0
//destroy the current Consul master node
//Vault still stayed active and clustered
//Clearly registered to the quorum and not just a single node
//However, when checking leader status it is hitting Consul-0 that was originally registered with

###What happens when all Vault servers are killed?
From Host command line:
- vagrant destroy vault-0 vault-1 vault-2
//destroy all Vault servers
//at this point Consul is now aware that the cluster is down
- vagrant up
//re-activate the 3 destroyed Vault servers
//the same keys from the previous cluster were used (because the HA backend takes this authentication)
//all 3 nodes re-joined the cluster. Consul considered the Vault cluster as healthy
//vault-0 elected as leader, vault-1 and vault-2 remain passive

###What happens when the active Vault server is killed?
From Host command line:
- vagrant destroy vault-0
//destroy active master Vault server
//consul is aware that vault-0 is down
//vault-1 has become master after 15 seconds
//Consul remained satisfied that Vault cluster was still active

###What happens when 2/3 Vault servers are killed (including 1 active 1 standby)?
From Host command line:
- vagrant destroy vault-0 vault-1
//destroy active master Vault server and standby
//consul is aware that vault-0 is down
//consul is aware that vault-1 is down
//Vault lock briefly invalidated, then re-elected and HA came back
//after 30 seconds, vault-2 became the active leader
- vagrant up
//bring back 2 dead Vault nodes
//re-joined the cluster, Consul still aware of an active Vault
