
SHELL := /usr/bin/env bash

SHARED_ENV=/mnt/vagrant
ISOLATED_ENV=/home/vagrant/Ethereum-network

eth:
	rm ./config/genesis.json || echo Fresh genesis
	cp ./config/genesis.orig.json ./config/genesis.json
	# Spin up
	vagrant destroy -f
	vagrant up m1
	vagrant up m2
	# vagrant up m3
	vagrant up client
	# Setup
	vagrant ssh m1 -- 'cd $(SHARED_ENV) && make geth-node'
	vagrant ssh m2 -- 'cd $(SHARED_ENV) && make geth-node'
	# vagrant ssh m3 -- 'cd $(SHARED_ENV) && make geth-node'
	# Start node
	vagrant ssh m1 -- 'cd $(ISOLATED_ENV) && ./start-node.sh'
	vagrant ssh m1 -- 'pgrep geth'
	vagrant ssh m2 -- 'cd $(ISOLATED_ENV) && ./start-node.sh'
	vagrant ssh m2 -- 'pgrep geth'
	# vagrant ssh m3 -- 'cd $(ISOLATED_ENV) && ./start-node.sh'
	# vagrant ssh m3 -- 'pgrep geth'
	# Connect
	rm addPeers.sh || echo Fresh addPeers.sh
	touch addPeers.sh
	sudo chmod +x addPeers.sh
	vagrant ssh m1 -- 'node $(SHARED_ENV)/scripts/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc) 192.168.0.201 >> $(SHARED_ENV)/addPeers.sh'
	vagrant ssh m2 -- 'node $(SHARED_ENV)/scripts/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc) 192.168.0.202 >> $(SHARED_ENV)/addPeers.sh'
	# vagrant ssh m3 -- 'node $(SHARED_ENV)/scripts/generate-addPeer-command.js $$(geth --exec "admin.nodeInfo.enode" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc) 192.168.0.203 >> $(SHARED_ENV)/addPeers.sh'
	vagrant ssh m1 -- '$(SHARED_ENV)/addPeers.sh'
	vagrant ssh m2 -- '$(SHARED_ENV)/addPeers.sh'
	# vagrant ssh m3 -- '$(SHARED_ENV)/addPeers.sh'
	# Mine
	vagrant ssh m1 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	# vagrant ssh m3 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	#Check peers
	vagrant ssh m1 -- 'geth --exec "admin.peers" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "admin.peers" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	# vagrant ssh m3 -- 'geth --exec "admin.peers" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
geth-node:
	mkdir -p $(ISOLATED_ENV)/ethdata
	ln -s $(SHARED_ENV)/config/genesis.json $(ISOLATED_ENV)/genesis.json
	ln -s $(SHARED_ENV)/config/password $(ISOLATED_ENV)/password
	ln -s $(SHARED_ENV)/scripts/install.sh $(ISOLATED_ENV)/install.sh
	ln -s $(SHARED_ENV)/scripts/start-node.sh $(ISOLATED_ENV)/start-node.sh
	ln -s $(SHARED_ENV)/scripts/genesis-generator.js $(ISOLATED_ENV)/genesis-generator.js
	cd $(ISOLATED_ENV) && ./install.sh
start-mining:
	vagrant ssh m1 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	# vagrant ssh m3 -- 'geth --exec "miner.start()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
stop-mining:
	vagrant ssh m1 -- 'geth --exec "miner.stop()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	vagrant ssh m2 -- 'geth --exec "miner.stop()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
	# vagrant ssh m3 -- 'geth --exec "miner.stop()" attach ipc:/$(ISOLATED_ENV)/ethdata/geth.ipc'
tail-logs:
	vagrant ssh m1 -- 'tail $(ISOLATED_ENV)/run.log'
	vagrant ssh m2 -- 'tail $(ISOLATED_ENV)/run.log'
	# vagrant ssh m3 -- 'tail $(ISOLATED_ENV)/run.log'
install-yarn:
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
	sudo apt-get update
	while pgrep unattended; do sleep 10; done;
	sudo apt-get install --no-install-recommends yarn