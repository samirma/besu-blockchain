#!/bin/bash

# Configuration
RPC_URL="http://localhost:8545"
ADDRESS="0xeb1b2d98cadd52ba8a519376148babf0172609bd"
SLEEP_INTERVAL=16  # Seconds between block checks

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

# Error handling
trap 'echo "\n${RED}Script interrupted. Exiting...${NC}"; exit 1' INT

# Helper function for RPC calls
rpc_call() {
    local method=$1
    local params=$2
    local response=$(curl -s -X POST -H "Content-Type: application/json" \
        --data "{\"jsonrpc\":\"2.0\",\"method\":\"$method\",\"params\":$params,\"id\":1}" "$RPC_URL")
    
    if [ $? -ne 0 ]; then
        echo "${RED}❌ RPC call failed. Check node connection.${NC}"
        exit 1
    fi
    
    echo $response | jq -r '.result'
}

# Enhanced progress bar with smoother animation
print_progress() {
    local total_time=$SLEEP_INTERVAL
    local i duration
    echo -ne "⏳ ${CYAN}Waiting ${total_time}s for new blocks...${NC}\n"
    
    for ((i=0; i<total_time; i++)); do
        printf "│%-${total_time}s│ %d/%d sec\r" \
            "$(printf '%0.s▸' $(seq 1 $i))" \
            $((i+1)) \
            $total_time
        sleep 1
    done
    echo -ne "\n\n"
}

# Check 1: Mining Status
echo "\n${BOLD}=== MINING STATUS CHECK ===${NORMAL}"
mining_status=$(rpc_call "eth_mining" "[]")

if [ "$mining_status" = "true" ]; then
    echo "${GREEN}✔ Mining active ${YELLOW}(status: $mining_status)${NC}"
else
    echo "${RED}❌ Mining inactive (should be active for validator nodes)${NC}"
    echo "${YELLOW}⚠  Check if the node is properly configured as a validator${NC}"
    exit 1
fi

# Check 2: Validator Status
echo "\n${BOLD}=== VALIDATOR STATUS CHECK ===${NORMAL}"
validator_set=$(rpc_call "clique_getSigners" "[\"latest\"]")

if [[ "$validator_set" == *"$ADDRESS"* ]]; then
    echo "${GREEN}✔ Node in validator set ${CYAN}(address: ${ADDRESS})${NC}"
else
    echo "${RED}❌ Node not in validator set${NC}"
    echo "${YELLOW}⚠  Verify the address is properly configured and authorized${NC}"
    exit 1
fi

# Check 3: Account Balance
echo "\n${BOLD}=== ACCOUNT BALANCE CHECK ===${NORMAL}"
balance_wei=$(rpc_call "eth_getBalance" "[\"$ADDRESS\", \"latest\"]")

if [ -z "$balance_wei" ]; then
    echo "${RED}❌ Failed to retrieve account balance${NC}"
    exit 1
else
    balance_eth=$(echo "scale=5; ${balance_wei}/1000000000000000000" | bc -l)
    echo "${GREEN}✔ Balance verified${NC}"
    printf "   Address: ${CYAN}%s${NC}\n" "$ADDRESS"
    printf "   Balance: ${YELLOW}%'.5f ETH${NC} (${YELLOW}%s WEI${NC})\n" "$balance_eth" "$balance_wei"
fi

# Check 4: Block Progression
echo "\n${BOLD}=== BLOCK PROGRESSION CHECK ===${NORMAL}"
block_before=$(rpc_call "eth_blockNumber" "[]")
printf "Initial block: ${CYAN}%s${NC} (Decimal: ${YELLOW}%d${NC})\n" "$block_before" "$((block_before))"

print_progress

block_after=$(rpc_call "eth_blockNumber" "[]")

if (( $((block_after)) > $((block_before)) )); then
    blocks_produced=$(( $((block_after)) - $((block_before)) ))
    echo "${GREEN}✔ Block progression normal ${CYAN}($blocks_produced new blocks)${NC}"
    printf "   Height: ${YELLOW}%d ➔ %d${NC}\n" "$((block_before))" "$((block_after))"
else
    echo "${RED}❌ Block progression failure (stuck at $block_before)${NC}"
    echo "${YELLOW}⚠  Check node synchronization and peer connections${NC}"
    exit 1
fi

# Check 5: Peer Connections
echo "\n${BOLD}=== PEER CONNECTIONS CHECK ===${NORMAL}"
peer_count=$(rpc_call "net_peerCount" "[]")

if (( $peer_count >= 1 )); then
    echo "${GREEN}✔ Network peers: ${YELLOW}${peer_count}${NC}"
else
    echo "${RED}❌ Insufficient peers (${peer_count})${NC}"
    echo "${YELLOW}⚠  Check network configuration and firewall settings${NC}"
    exit 1
fi

# Check 6: Chain ID Validation
echo "\n${BOLD}=== CHAIN ID CHECK ===${NORMAL}"
chain_id=$(rpc_call "eth_chainId" "[]")
chain_id_dec=$((chain_id))
printf "Detected Chain ID:\n"
printf "   Hex: ${CYAN}%s${NC}\n" "$chain_id"
printf "   Decimal: ${YELLOW}%d${NC}\n" "$chain_id_dec"

# Final Summary
echo "\n${BOLD}=== FINAL SUMMARY ===${NORMAL}"
echo "${GREEN}All system checks passed successfully!${NC}"
echo "Network Status:    ${GREEN}◉ OPERATIONAL${NC}"
echo "Chain Height:     ${YELLOW}$((block_after))${NC}"
echo "Validator Status: ${GREEN}✔ ACTIVE${NC}"
printf "Account Balance:   ${YELLOW}%'.5f ETH${NC}\n" "$balance_eth"
echo "Peer Connections: ${YELLOW}${peer_count}${NC}"
echo "Chain ID:         ${YELLOW}${chain_id_dec}${NC}"

exit 0