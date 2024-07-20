import argparse
import json
import re
import subprocess
import sys
import time
from pathlib import Path

from util import BASE_REQUIREMENTS, run_command, run_command_json

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Search for rentable GPUs that meet the specified criteria."
    )
    parser.add_argument(
        "gpu_name", type=str, help="Name of the GPU to search for or regex pattern"
    )
    parser.add_argument(
        "--disk",
        type=int,
        default=50,
        help="Disk space in GB (default: 50)",
    )
    parser.add_argument(
        "--image",
        type=str,
        default="pytorch/pytorch:2.3.1-cuda12.1-cudnn8-devel",
        help="Docker image to use (default: pytorch/pytorch:2.3.1-cuda12.1-cudnn8-devel)",
    )
    args = parser.parse_args()

    # Find all GPUs that match the specified name or regex pattern
    all_gpus = json.load(Path("gpu_names.json").open())
    matched_gpus = [gpu for gpu in all_gpus if re.fullmatch(args.gpu_name, gpu)]

    output = run_command(
        f"python vast.py search offers 'gpu_name in {matched_gpus} {BASE_REQUIREMENTS}' --order dph"
    )
    # Show first 10 results (+1 for the header)
    # Note: There is a "--limit n" flag in the vast.py script, but it's buggy
    print("\n".join(output.split("\n")[:11]))

    print("Enter the offer ID to rent the GPU, or press Enter to abort:")
    offer_id = input()
    if not re.fullmatch(r"\d+", offer_id):
        sys.exit(0)

    print(f"Attempting to rent offer ID {offer_id}...")
    output = run_command_json(
        f"python vast.py create instance {offer_id} \
        --image {args.image} \
        --disk {args.disk} \
        --onstart ./setup.sh \
        --ssh \
        --direct \
        --raw"
    )
    contract_id = output["new_contract"]
    print(f"Contract ID: {contract_id}")

    print("Waiting for the instance to start...")
    state = run_command_json(f"python vast.py show instance {contract_id} --raw")
    while state["actual_status"] != "running":
        print(f"Status: {state['status_msg']}")
        time.sleep(5)
        state = run_command_json(f"python vast.py show instance {contract_id} --raw")
    # Make sure the state finalizes
    time.sleep(5)
    state = run_command_json(f"python vast.py show instance {contract_id} --raw")

    public_ipaddr = state["public_ipaddr"]
    port = state["direct_port_start"]
    print("Open VS Code and connect to the instance using the following command:")
    print(f"code-insiders --remote ssh-remote+root@{public_ipaddr}:{port} /root")
    print("Or use the following command to SSH into the instance:")
    print(f"ssh ssh://root@{public_ipaddr}:{port}")
