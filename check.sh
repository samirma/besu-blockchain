curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' localhost:8545
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' localhost:8545



curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'  http://35.208.144.105:8545/
