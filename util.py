import json
import subprocess


def run_command(command: str):
    try:
        result = subprocess.run(
            command, shell=True, capture_output=True, text=True, check=True
        )
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error: Command '{command}' failed with exit code {e.returncode}")
        print(f"Error message: {e.stderr}")
        raise


def run_command_json(command: str):
    return json.loads(run_command(command))


BASE_REQUIREMENTS = f"\
    num_gpus=1 \
    cuda_vers>=12.1 \
    disk_bw>=500 \
    duration>=1 \
    inet_down>=200 \
    inet_down_cost<=0.1 \
    inet_up>=200 \
    inet_up_cost<=0.1 \
    rentable=True \
    rented=False \
    reliability>=0.9 \
    cpu_cores_effective>=4 \
    cpu_ram>=16 \
"

