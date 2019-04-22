# Create a new Ethereum Account
ACCOUNT=$(geth --datadir ethdata account new --password "./password" | cut -d '{' -f2 | cut -d '}' -f1)
echo $ACCOUNT > account.out