const readFile = require('pify')(require('fs').readFile);
const Web3 = require('web3'); 
const solc = require('solc');

const contract = 'Greetingsv2.sol';
const transactionFee = 4700000;

function setupWeb3(address) {
  console.log(`Setting up web3 for address ${address}`);
  return new Web3(new Web3.providers.HttpProvider(`http://${address}:8000`));
}

async function compileContract() {
  const input = {
    language: 'Solidity',
    sources: {
      'Greetingsv2.sol': {
        content: await readFile(contract, 'utf8')
      }
    },
    settings: {
      outputSelection: {
        '*': {
          '*': [ '*' ]
        }
      }
    }
  };

  const output = JSON.parse(solc.compile(JSON.stringify(input)));
  if (output.errors) {
    throw new Error(JSON.stringify(output.errors));
  }

  const compiledContract = output.contracts['Greetingsv2.sol']['Greetingsv2'];

  return {
    abi: compiledContract.abi,
    code: `0x${compiledContract.evm.bytecode.object}`
  };
}

async function deployContract(web3) {
  const {abi, code} = await compileContract();
  const accounts = await web3.eth.getAccounts();
  accounts.forEach(a => console.log(`Found account ${a}`));

  const balance = await web3.eth.getBalance(accounts[0]);
  console.log('balance', balance);

  console.log('Deploying ...');
  const contract = await new web3.eth.Contract(abi)
    .deploy({ data: code })
    .send({ gas: transactionFee, from: accounts[0] });

  debugger;

  // console.log('contract deployed at', contract.options.address, 'abi: ', abi);
  console.log('contract deployed at', contract.options.address);
  return {
    abi,
    address: contract.options.address
  };
}

async function setGreeting(web3, contract) {
  const {abi, address} = contract;
  const instance = new web3.eth.Contract(abi, address);
  const res = await instance.methods.setGreeting('Im Happy3')
    .send({
      from: (await web3.eth.getAccounts())[0],
      gas: transactionFee
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
    console.log('set greeting');
    await setGreeting(m1, contract);
    console.log('get greeting', await getGreeting(m2, contract));
  }
  catch(e) {
    console.log(e);
  }
}

main();