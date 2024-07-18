#!/bin/bash

./vast.py search offers \
    "\
    num_gpus=1 \
    cuda_vers>=12.1 \
    disk_bw>=500 \
    disk_space>=10 \
    duration>=1 \
    inet_down>=50 \
    inet_down_cost<=0.1 \
    inet_up>=50 \
    inet_up_cost<=0.1 \
    rentable=True \
    rented=False \
    reliability>=0.9 \
    cpu_cores>=4 \
    cpu_ram>=32 \
    compute_cap>=750 \
    dph<=3 \
    storage_cost<=10 \
    ubuntu_version>=20.04 \
    " \
    --limit 1000 \
    --raw | jq "map(.gpu_name) | unique" \
    > gpu_names.json
