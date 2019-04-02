geth --datadir="ethdata" init genesis.json
ACCOUNT=$(cat account.out)
nohup geth \
	--datadir="ethdata" \
	--networkid 4088 \
	--nodiscover \
	--unlock $ACCOUNT \
	--password "./password" \
	--rpc \
	--rpcport "8000" \
	--rpcaddr "0.0.0.0" \
	--rpccorsdomain "*" \
	--rpcapi "eth,net,web3,miner,debug,personal,rpc" 0<&- &>/dev/null &