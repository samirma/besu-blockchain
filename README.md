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
   sudo chown -R 1000:1000 Node-*
   cd Node-1
   besu --data-path=data public-key export-address --to=data/node1Address
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
