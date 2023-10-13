#!/bin/bash

RED='\033[1;31m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
NC='\033[0m'


echo -e "${YELLOW}[WARNING]${NC} For privacy purposes do ssh-add of your private key or configure your ~/.ssh/config file"
echo

read -r -p "$( echo -e ${YELLOW}[...]${NC} "Please enter Master node IP address: " )" master_ip
read -r -p "$( echo -e ${YELLOW}[...]${NC} 'Please enter Worker-1 node IP address: ' )" worker1_ip
read -r -p "$( echo -e ${YELLOW}[...]${NC} 'Please enter Worker-2 node IP address: ' )" worker2_ip


#ansible-playbook playbook.yaml --extra-vars="master_ip=$master_ip" --extra-vars="worker1=$worker1_ip"  --extra-vars="worker2=$worker2_ip"
ansible-playbook playbook.yaml --extra-vars="master_ip=$master_ip"