# Vagrant Datacenter

A repository used for offline local experimentation, testing and development with Vault and Consul.

A full build will provide a pre-clustered, HA implementation of Vault and Consul spread across 6 nodes. Just unseal your Vault and you're good to go!

*Access the Consul UI at localhost:8585/ui*

If the following error is hit:
```
[vagrant@vault-0 ~]$ vault status
Error checking seal status: Get http://127.0.0.1/v1/sys/seal-status: dial tcp 127.0.0.1:80: getsockopt: connection refused
```
Run the following command:
`export VAULT_ADDR=http://127.0.0.1:8200` -- This is hit because Vault defaults to look for the https address for the Vault API.

## Pre-requisites
- Oracle VirtualBox

## Commands

Bring up all Consul/Vault nodes
`vagrant up consul-0 consul-1 consul-2 vault-0 vault-1 vault-2`

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

## Experimentation

### Does Vault HA result in backed up secrets?
Yes, at least a single member of the HA backend cluster stays alive. If a snapshot process is also applied to the HA backend, it is possible to lose all Vault and HA backend nodes and still re-initialize Vault and access the snapshotted secrets. The original unseal keys must be maintained however.

### Can all Vault nodes be destroyed and come back into the same cluster?
From Host command line:
- `vagrant destroy vault-0 vault-1 vault-2 -f`
_Destroyed all Vault servers, at this point Consul is now aware that the cluster is down_
- `vagrant up`
_Re-activated the 3 destroyed Vault servers, the same keys from the previous cluster were used (because the HA backend takes this authentication), all 3 nodes re-joined the cluster. Consul considered the Vault cluster as healthy, vault-0 elected as leader, vault-1 and vault-2 remain passive._

### Can the active master Consul server be destroyed and not affect Vault?
From Host command line:
- `vagrant destroy consul-0`
_Destroyed the current Consul master node, Vault still stayed active and clustered, clearly registered to the quorum and not just a single node. However, when checking leader status it is hitting consul-0 that was originally registered with._

### What happens when all Vault servers are killed?
From Host command line:
- `vagrant destroy vault-0 vault-1 vault-2`
_Destroyed all Vault servers. At this point Consul is now aware that the cluster is down_
- `vagrant up`
_Re-activates the 3 destroyed Vault servers, the same keys from the previous cluster were used (because the HA backend takes this authentication). All 3 nodes re-joined the cluster. Consul considered the Vault cluster as healthy vault-0 elected as leader, vault-1 and vault-2 remain passive._

### What happens when the active Vault server is killed?
From Host command line:
- `vagrant destroy vault-0`
_Destroyed active master Vault server, consul is aware that vault-0 is down, vault-1 has become master after 15 seconds, Consul remained satisfied that Vault cluster was still active._

### What happens when 2/3 Vault servers are killed (including 1 active 1 standby)?
From Host command line:
- `vagrant destroy vault-0 vault-1`
_Destroyed active master Vault server and standby. consul is aware that vault-0 is down, consul is then aware that vault-1 is down, Vault lock briefly invalidated, then re-elected and HA came back after 30 seconds, vault-2 became the active leader._
- `vagrant up`
_Brought back 2 dead Vault nodes re-joined the cluster, Consul still aware of an active Vault._
