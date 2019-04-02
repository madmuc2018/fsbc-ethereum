# Local, private ethereum network using Vagrant
- Credits to [Venati's medium article](https://medium.com/@yashwanthvenati/setup-private-ethereum-blockchain-network-with-multiple-nodes-in-5-mins-708ab89b1966)
- Spin up 3 VMs, each running an ethereum node, all connected together forming a private network, good for testing and learning. Apart from the 3 VMs, there is also one VM with Node.js environment for intacting with the network and testing out solidity contracts

# Requirements
- Virtualbox and Vagrant

# How to run
- Clone this repo and run `make eth`

# Notes
- Since the datadir flag is used in the geth commands, there will be 2 different ethereum directories (~/.ethereum and the datadir).  so specify which ipc to attach to
- The genesis.json file is shared among the VMs. Make sure to start initializing the nodes after all changes have been made to the genesis file