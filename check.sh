curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}' localhost:8545
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' localhost:8545



curl -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":1}'  http://35.208.144.105:8545/



 curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["0xeb1b2d98cadd52ba8a519376148babf0172609bd", "latest"], "id":1}' http://localhost:8545

