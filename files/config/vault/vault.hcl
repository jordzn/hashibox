backend "consul" {
  address = "172.20.20.10:8500"
  scheme = "http"
  path = "vault-ha/"
}

disable_mlock=true

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = 1
}
