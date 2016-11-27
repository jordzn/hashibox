# -*- mode: ruby -*-
# vi: set ft=ruby :

### Configuration
node_config = (JSON.parse(File.read("config/nodes.json")))['nodes']

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

      # Configure ip address
      if node_values[':ip'] == 'dhcp'
        config.vm.network "private_network", type: "dhcp", auto_config: true
      else
        config.vm.network "private_network", ip: node_values[':ip']
      end

      config.vm.synced_folder "./synced_folder", "/tmp/synced_folder"
      config.vm.synced_folder "./files/scripts", "/usr/local/bin"
      config.vm.synced_folder "./files/config", "/tmp/config"
      config.vm.synced_folder "./files/logs", "/tmp/logs"

      # Run scripts from node configuration
      if node_values['scripts']
        node_values['scripts'].each do |script|
          config.vm.provision :shell, :inline => script
        end
      end
    end
  end
end
