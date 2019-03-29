
SHELL := /usr/bin/env bash

eth:
	# Spin up
	vagrant destroy -f
	vagrant up
	vagrant ssh m1 -- 'cd /home/vagrant/Blockchain-Test-Network/Ethereum-network && ./start-node.sh'
	vagrant ssh m1 -- 'pgrep geth'
	vagrant ssh m2 -- 'cd /home/vagrant/Blockchain-Test-Network/Ethereum-network && ./start-node.sh'
	vagrant ssh m2 -- 'pgrep geth'
	vagrant ssh m3 -- 'cd /home/vagrant/Blockchain-Test-Network/Ethereum-network && ./start-node.sh'
	vagrant ssh m3 -- 'pgrep geth'
	# Connect
	rm addPeers.sh || echo "Fresh addPeers.sh"
	touch addPeers.sh
	sudo chmod +x addPeers.sh
	vagrant ssh m1 -- 'node /mnt/vagrant/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc) 192.168.0.201 >> /mnt/vagrant/addPeers.sh'
	vagrant ssh m2 -- 'node /mnt/vagrant/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc) 192.168.0.202 >> /mnt/vagrant/addPeers.sh'
	vagrant ssh m3 -- 'node /mnt/vagrant/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc) 192.168.0.203 >> /mnt/vagrant/addPeers.sh'
	vagrant ssh m1 -- '/mnt/vagrant/addPeers.sh'
	vagrant ssh m2 -- '/mnt/vagrant/addPeers.sh'
	vagrant ssh m3 -- '/mnt/vagrant/addPeers.sh'
	# Mine
	vagrant ssh m1 -- 'geth --exec "miner.start()" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "miner.start()" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'
	vagrant ssh m3 -- 'geth --exec "miner.start()" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'
	#Check peers
	vagrant ssh m1 -- 'geth --exec "admin.peers" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "admin.peers" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'
	vagrant ssh m3 -- 'geth --exec "admin.peers" attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc'