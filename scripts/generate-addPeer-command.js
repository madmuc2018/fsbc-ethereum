const enode = process.argv[2];
const ip = process.argv[3];

// const enode = "enode://eb8c33f931cffa044f57b16df32ad6246c783571df3e97b9f3f44ca522fd18aea8df9fa5cca9499003cbdbd8c7866aafdc765973f9ef70c0c2d766baba86086b@174.2.240.14:30303?discport=0"
// const ip = "192.168.0.200"

if (!enode && !ip) {
  throw new Error('No enode or ip provided');
}

const AT_SPLIT = enode.split('@');
const n_enode = `${AT_SPLIT[0]}@${ip}:${AT_SPLIT[1].split(':')[1]}`;

const addPeer = `geth --exec 'admin.addPeer(${n_enode})' attach ipc://home/vagrant/Blockchain-Test-Network/Ethereum-network/ethdata/geth.ipc || echo Could not connect to node at ${ip}`;

// process.stdout.write(addPeer);
console.log(addPeer);