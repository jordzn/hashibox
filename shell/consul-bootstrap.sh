# ARGS
# 1 = is server - true/false
# 2 = manage iptables - true/false
# 3 = node name
# 4 = bind address
# 5 = cluster size // agent target server
# 1 - n = consul server members

unzip /tmp/synced_folder/consul_0.7.1_linux_amd64.zip -d /tmp
sudo mv /tmp/consul /usr/bin
sudo mkdir /etc/consul.d
sudo iptables -I INPUT 1 -p tcp --dport 8300 -j ACCEPT
sudo iptables -I INPUT 1 -p tcp --dport 8301 -j ACCEPT
sudo iptables -I INPUT 1 -p tcp --dport 8500 -j ACCEPT
consul agent -server -data-dir=/tmp/consul -node=${1} -bind=${2} -bootstrap-expect=3 -config-dir=/etc/consul.d -ui


# if $2 do
#   sudo iptables -I INPUT 1 -p tcp --dport 8300 -j ACCEPT
#   sudo iptables -I INPUT 1 -p tcp --dport 8301 -j ACCEPT
#   sudo iptables -I INPUT 1 -p tcp --dport 8500 -j ACCEPT
# fi
#
# if $1 do
#   consul agent -server -data-dir=/tmp/consul -node=${3} -bind=${4} -bootstrap-expect=${5} -config-dir=/etc/consul.d -ui
#   consul join ${6} ${7} ${8}
# else
#   consul agent -data-dir=/tmp/consul -node=${3} -bind=${4} -config-dir=/etc/consul.d
#   consul join ${5}
# fi
