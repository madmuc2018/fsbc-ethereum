# Install the required softwares for Ethereum
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get -y install ethereum

# Create a new Ethereum Account
ACCOUNT=$(geth --datadir ethdata account new --password "/mnt/vagrant/password" | cut -d '{' -f2 | cut -d '}' -f1)
echo $ACCOUNT > account.out
node /mnt/vagrant/genesis-generator.js $ACCOUNT