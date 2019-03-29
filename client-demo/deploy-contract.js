let fs = require('fs');
let Web3 = require('web3'); 
const solc = require('solc');

const source = fs.readFileSync('./Greetingsv1.sol', 'utf8');
console.log('Compiling ...');
const output = solc.compile(source, 1);

let web3 = new Web3();
console.log('Setting up web3 ...');
web3.setProvider(new web3.providers.HttpProvider('http://192.168.0.201:8000'));
let contracts = output.contracts;

let abi = JSON.parse(contracts[':Greetingsv1'].interface);
let code = '0x'+contracts[':Greetingsv1'].bytecode;

console.log('waitBlock ...');
//wait til a miner includes the block
async function waitBlock() {
  console.log('Getting accounts ...');
  const accounts = await web3.eth.getAccounts();

  console.log('Deploying ...');
  let contract = await new web3.eth.Contract(abi)
    .deploy({ data: code })
    .send({ gas: 4700000, from: accounts[0] });

  console.log('contract deployed at', contract.options.address);

  const instance = new web3.eth.Contract(
    abi,
    contract.options.address
  );

  console.log('setting greeting variable to Im Happy');

  await instance.methods.setGreeting('Im Happy')
    .send({
      from: accounts[0],
      gas: 4700000
    });
  let y = await instance.methods.getGreeting().call();
  console.log(`getGreeting: ${y}`);
  debugger;
}

waitBlock();