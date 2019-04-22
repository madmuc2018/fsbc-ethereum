def common_config(config, memory = "3000")
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

  skip_upgrades(config)
  install_node(config)
  install_ethereum(config)
  # install_remix(config)
end

def skip_upgrades(config)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get --purge unattended-upgrades
    apt-get update
    while pgrep unattended; do sleep 10; done;
    apt-get install -y build-essential zip unzip apt-rdepends tree
  SHELL
end

def install_node(config)
  config.vm.provision "shell", inline: <<-SHELL
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
    apt-get install -y nodejs
  SHELL
end

def install_ethereum(config)
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    mkdir -p /home/vagrant/ethereum-packages
    unzip -q /mnt/vagrant/ethereum-packages.zip -d /home/vagrant/ethereum-packages
  SHELL
  config.vm.provision "shell", inline: <<-SHELL
    dpkg -i /home/vagrant/ethereum-packages/*.deb
    apt-get install -y -f
  SHELL
end

def install_ethereum_latest(config)
  config.vm.provision "shell", inline: <<-SHELL
    apt-get install software-properties-common
    add-apt-repository -y ppa:ethereum/ethereum
    apt-get update
    apt-get -y install ethereum
  SHELL
end

def install_remix(config)
  config.vm.provision "shell", inline: <<-SHELL
    npm install remix-ide -g --unsafe-perm
  SHELL
end

def forward_port(config, guest, host = guest)
  config.vm.network :forwarded_port, guest: guest, host: host, auto_correct: true
end

Vagrant.configure("2") do |vagrant_conf|
  vagrant_conf.vm.define "m1" do |config|
    common_config(config)
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.201"
    config.vm.hostname="vagrant1"
    config.vm.box = "ubuntu/xenial64"
    forward_port(config, 8080)
  end

  vagrant_conf.vm.define "m2" do |config|
    common_config(config)
    config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.202"
    config.vm.hostname="vagrant2"
    config.vm.box = "ubuntu/xenial64"
  end

  # vagrant_conf.vm.define "m3" do |config|
  #   common_config(config)
  #   config.vm.network "public_network", bridge: "en0: Wi-Fi (AirPort)", ip: "192.168.0.203"
  #   config.vm.hostname="vagrant3"
  #   config.vm.box = "ubuntu/xenial64"
  # end
end
