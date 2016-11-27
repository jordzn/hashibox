# -*- mode: ruby -*-
# vi: set ft=ruby :

### Configuration
node_groups = (JSON.parse(File.read("config/nodes.json")))['node_groups']
node_config = node_groups['consul_cluster']

### Vagrant

Vagrant.configure("2") do |config|

  node_config.each do |node|
    node_name   = node[0] # name of node
    node_values = node[1] # content of node

    config.vm.define node_name do |config|
      # Configure node hostname
      config.vm.host_name = "%s" % node_name

      # Configure base box
      config.vm.box_url = 'https://vagrantcloud.com/puppetlabs/boxes/centos-6.6-64-nocm'
      config.vm.box = node_values[':base']

      # Configure memory and cpus
      config.vm.provider 'virtualbox' do |vb|
        vb.name = node_name
        vb.customize ['modifyvm', :id, '--memory', node_values[':memory']] if node_values[':memory']
        vb.customize ['modifyvm', :id, '--cpus', node_values[':cpus']] if node_values[':cpus']
        vb.customize ['modifyvm', :id, '--cpuexecutioncap', node_values[':cpuexecutioncap']] if node_values[':cpuexecutioncap']
        vb.customize ['modifyvm', :id, "--hostonlyadapter2", "vboxnet0"]
      end

      # Configure forwarding ports
      ports = node_values['ports']
      ports.each do |port|
        config.vm.network :forwarded_port,
          host:  port[':host'],
          guest: port[':guest'],
          id:    port[':id']
      end

    #   config.trigger.after [:provision, :up, :reload] do
    #     system('echo "
    #       rdr pass on lo0 inet proto tcp from any to 127.0.0.1 port 8500 -> 127.0.0.1 port 8500
    # " | sudo pfctl -ef - > /dev/null 2>&1; echo "==> Fowarding Ports: 8500 -> 8500 & Enabling pf"')
    #   end
    #
    #   config.trigger.after [:halt, :destroy] do
    #     system("sudo pfctl -df /etc/pf.conf > /dev/null 2>&1; echo '==> Removing Port Forwarding & Disabling pf'")
    #   end

      # Configure ip address
      if node_values[':ip'] == 'dhcp'
        config.vm.network "private_network", type: "dhcp", auto_config: true
      else
        config.vm.network "private_network", ip: node_values[':ip']
      end

      config.vm.synced_folder "./synced_folder", "/tmp/synced_folder"
      config.vm.synced_folder "./files/scripts", "/usr/local/bin"
      config.vm.synced_folder "./files/config", "/tmp/config"

      # Run scripts from node configuration
      if node_values['scripts']
        node_values['scripts'].each do |script|
          config.vm.provision :shell, :inline => script
        end
      end
    end
  end
end
