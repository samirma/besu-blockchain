# Besu Blockchain for GNC Project

This repository contains a custom blockchain network based on Hyperledger Besu, designed to be used by the GNC project. The network follows the Clique consensus algorithm.

## Getting Started

To set up the Besu blockchain network, follow these steps:

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/samirma/besu-blockchain.git
   ```

2. **Navigate to the Project Directory**:
   ```bash
   cd besu-blockchain
   ```

2.1 **Create Project Directory**:
   ```bash
   mkdir -p {Node-1,Node-2,Node-3}/data
   cd Node-1
   docker run  -v ./data:/var/lib/besu hyperledger/besu:25.2.2 --data-path=/var/lib/besu public-key export-address --to=/var/lib/besu/node1Address

   cp Node-1/*

   #sudo chown -R 1000:1000 Node-*
   ```

2.2 **Start outside from docker compose**:
   ```bash

   # Node-1
   docker rm node-1 ;  docker run --name node-1 \
   -v ./Node-1/data:/opt/besu/data \
   -v ./cliqueGenesis.json:/opt/besu/cliqueGenesis.json \
   -p 30303:30303 \
   -p 8545:8545 \
   hyperledger/besu:25.2.2 --data-path=/opt/besu/data --genesis-file=/opt/besu/cliqueGenesis.json --network-id 123 --rpc-http-enabled --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --sync-min-peers 3



   # Node-1
   docker rm node-2 ;  docker run --name node-2 \
   -v ./Node-2/data:/opt/besu/data \
   -v ./cliqueGenesis.json:/opt/besu/cliqueGenesis.json \
   -p 8546:8546 \
   -p 30304:30304 \
   hyperledger/besu:25.2.2 --data-path=/opt/besu/data --genesis-file=/opt/besu/cliqueGenesis.json --bootnodes=enode://3edbd256b7a336c0d6d005d4f01e1e0e5c29fe69d2deb26f8d88d925d6bcba6e1b60cf758b0484ffb4261a56cee7cbd0e749641fecabb4952edec88c6e562658@127.0.0.1:30303 --network-id 123 --p2p-port=30304 --rpc-http-enabled --rpc-http-api=ETH,NET,CLIQUE --host-allowlist="*" --rpc-http-cors-origins="all" --rpc-http-port=8546 --profile=ENTERPRISE



   ```


3. **Docker Compose Configuration**:
   The `docker-compose.yml` file defines the network configuration. It includes three Besu nodes (node-1, node-2, and node-3) with specific settings.

   - **Node 1 (node-1)**:
     - Data path: `/opt/besu/data`
     - Genesis file: `/opt/besu/cliqueGenesis.json`
     - Network ID: 123
     - RPC HTTP enabled
     - RPC HTTP API: ETH, NET, CLIQUE
     - Host allowlist: "*"
     - CORS origins: "all"
     - Ports: 30303 (P2P), 8545 (RPC HTTP)

   - **Node 2 (node-2)**:
     - Similar configuration to node-1
     - Bootnodes: Connects to node-1
     - Ports: 30304 (P2P), 8546 (RPC HTTP)

   - **Node 3 (node-3)**:
     - Similar configuration to node-1
     - Bootnodes: Connects to node-1
     - Ports: 30305 (P2P), 8547 (RPC HTTP)

4. **Volumes and Data Persistence**:
   - Data directories for each node are mapped to local directories (e.g., `./Node-1/data`).
   - The `cliqueGenesis.json` file is also mapped to each node.

5. **Network Configuration**:
   - The network uses a custom bridge network named `chain_net`.
   - IP addresses are assigned to each node within the subnet `172.4.0.0/24`.

6. **Start the Network**:
   ```bash
   docker-compose up -d
   ```

7. **Access Nodes**:
   - Node 1: http://localhost:8545
   - Node 2: http://localhost:8546
   - Node 3: http://localhost:8547

## Additional Resources

- [Hyperledger Besu Documentation](https://besu.hyperledger.org/private-networks/tutorials/clique)

Feel free to explore and customize this Besu blockchain network for your GNC project! 🚀
