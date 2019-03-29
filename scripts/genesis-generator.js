const newAccount = process.argv[2];

if (!newAccount) {
  throw new Error('No account provided');
}

const fs = require('fs');
const genFile = '/mnt/vagrant/Blockchain-Test-Network/Ethereum-network/genesis.json'

fs.readFile(genFile, 'utf8', (err, data) => {
  if (err) throw err;
  const genesis = JSON.parse(data);
  genesis.alloc[newAccount] = {balance: '15151515151515151515151515151515151515'};
  console.log(JSON.stringify(genesis));

  fs.writeFile(genFile, JSON.stringify(genesis), (err) => {
    if (err) throw err;
    console.log(`Account ${newAccount} added to genesis`);
  });
});