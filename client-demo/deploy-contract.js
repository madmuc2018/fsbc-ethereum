const fs = require('fs');
const Web3 = require('web3'); 
const solc = require('solc');

function setupWeb3(address) {
  console.log(`Setting up web3 for address ${address}`); 
  const web3 = new Web3();
  web3.setProvider(new web3.providers.HttpProvider(`http://${address}:8000`));
  return web3;
}

function compileContract() {
  const source = fs.readFileSync('./Greetingsv1.sol', 'utf8');
  console.log('Compiling ...');
  const output = solc.compile(source, 1);
  const contracts = output.contracts;
  return {
    abi: JSON.parse(contracts[':Greetingsv1'].interface),
    code: '0x'+contracts[':Greetingsv1'].bytecode
  };
}

async function deployContract(web3) {
  const {abi, code} = compileContract();
  const accounts = await web3.eth.getAccounts();
  accounts.forEach(a => console.log(`Found account ${a}`));

  console.log('Deploying ...');
  const contract = await new web3.eth.Contract(abi)
    .deploy({ data: code })
    .send({ gas: 4700000, from: accounts[0] });

  console.log('contract deployed at', contract.options.address, 'abi: ', abi);
  return {
    abi,
    address: contract.options.address
  };
}

async function setGreeting(web3, contract) {
  const {abi, address} = contract;
  const instance = new web3.eth.Contract(abi, address);
  const res = await instance.methods.setGreeting('Im Happy')
    .send({
      from: (await web3.eth.getAccounts())[0],
      gas: 4700000
    });
  return res;
}

async function getGreeting(web3, contract) {
  const {abi, address} = contract;
  const instance = new web3.eth.Contract(abi, address);
  const res = await instance.methods.getGreeting().call();
  return res;
}

async function main() {
  try {
    const m1 = setupWeb3('192.168.0.201');
    const m2 = setupWeb3('192.168.0.202');
    // const m3 = setupWeb3('192.168.0.203');

    const contract = await deployContract(m1);
    console.log(await setGreeting(m2, contract));
    console.log(await getGreeting(m1, contract));
  }
  catch(e) {
    console.log(e);
  }
}

main();