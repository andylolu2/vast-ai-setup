#!/bin/bash

set -e

IMAGE=pytorch/pytorch:2.3.1-cuda12.1-cudnn8-devel  # Docker image to use
DISK=50  # Disk space in GB

# This script is used to search for rentable GPUs that meet the specified criteria.
# Usage: ./scripts/rent.sh "gpu_name"

# Check if the user has provided a GPU name
if [ -z "$1" ]; then
    echo "Usage: ./scripts/rent.sh \"gpu_name\""
    exit 1
fi
gpu_name=$1

./vast.py search offers \
    "\
    gpu_name in [$gpu_name] \
    num_gpus=1 \
    cuda_vers>=12.1 \
    disk_bw>=500 \
    disk_space>=10 \
    duration>=1 \
    inet_down>=200 \
    inet_down_cost<=0.1 \
    inet_up>=200 \
    inet_up_cost<=0.1 \
    rentable=True \
    rented=False \
    reliability>=0.9 \
    cpu_cores>=4 \
    cpu_ram>=32 \
    compute_cap>=750 \
    storage_cost<=10 \
    " \
    --limit 10 \
    --order "dph"

# Ask the user to pick an offer by entering the offer ID, or abort
echo "Enter the offer ID to rent the GPU, or press Enter to abort:"
read offer_id

if [ -z "$offer_id" ]; then
    exit 0
fi

echo "Attempting to rent GPU $gpu_name with offer ID $offer_id..."
output=$(./vast.py create instance $offer_id --image $IMAGE --disk $DISK --onstart ./scripts/setup.sh --ssh --direct --raw)
contract_id=$(echo $output | jq .new_contract)
echo "Contract ID: $contract_id"

# Wait until the instance is running
state=$(./vast.py show instance $contract_id --raw | jq .actual_status)
while [ "$state" != "\"running\"" ]; do
    echo "Instance is not running yet, waiting..."
    sleep 10
    state=$(./vast.py show instance $contract_id --raw | jq .actual_status)
done

# Get the instance's SSH command
ip_address=$(./vast.py show instance $contract_id --raw | jq .public_ipaddr | tr -d '"')
port=$(./vast.py show instance $contract_id --raw | jq .direct_port_start)

echo "Open VS Code and connect to the instance using the following command:"
echo "code-insiders --remote ssh-remote+root@$ip_address:$port /root"
echo "Or use the following command to SSH into the instance:"
echo "ssh ssh://root@$ip_address:$port"
