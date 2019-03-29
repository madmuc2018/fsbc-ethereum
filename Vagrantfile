def common_config(config, memory = "1500")
  config.vm.hostname="vagrant"
  config.vm.synced_folder ".", "/mnt/vagrant"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    v.customize ["modifyvm", :id, "--memory", memory]
  end

  # https://github.com/hashicorp/vagrant/issues/7508
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end

  # https://github.com/hashicorp/vagrant/issues/7508
  config.vm.provision "disable-apt-periodic-updates", type: "shell" do |s|
    s.privileged = true
    s.inline = "echo 'APT::Periodic::Enable \"0\";' > /etc/apt/apt.conf.d/02periodic"
  end

  config.vm.provision "shell", inline: <<-SHELL
    apt-get --purge unattended-upgrades
    apt-get update
    while pgrep unattended; do sleep 10; done;
    apt-get install -y build-essential
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    while pgrep unattended; do sleep 10; done;
    apt-get install -y nodejs
  SHELL
end

def geth_node(config)
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    cd /home/vagrant && git clone https://github.com/Yashwanthv21/Blockchain-Test-Network.git
    cd /home/vagrant/Blockchain-Test-Network/Ethereum-network
    rm genesis.json *.sh
    ln -s /mnt/vagrant/Blockchain-Test-Network/Ethereum-network/genesis.json genesis.json
    ln -s /mnt/vagrant/Blockchain-Test-Network/Ethereum-network/install.sh install.sh
    ln -s /mnt/vagrant/Blockchain-Test-Network/Ethereum-network/start-node.sh start-node.sh
    ./install.sh
  SHELL
end

Vagrant.configure("2") do |vagrant_conf|
  vagrant_conf.vm.define "m1" do |config|
    common_config(config)
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.201"
    geth_node(config)
    config.vm.hostname="vagrant1"
    config.vm.box = "ubuntu/xenial64"
  end

  vagrant_conf.vm.define "m2" do |config|
    common_config(config)
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.202"
    geth_node(config)
    config.vm.hostname="vagrant2"
    config.vm.box = "ubuntu/xenial64"
  end

  vagrant_conf.vm.define "m3" do |config|
    common_config(config)
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.203"
    geth_node(config)
    config.vm.hostname="vagrant3"
    config.vm.box = "ubuntu/xenial64"
  end

  vagrant_conf.vm.define "client" do |config|
    common_config(config, "512")
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.210"
    config.vm.hostname="client"
    config.vm.box = "ubuntu/xenial64"
  end
end
