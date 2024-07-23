# Dev GPU setup with vast.ai

This is a collection of helper scripts and instructions to setup a GPU machine on vast.ai for deep learning development. I use this setup for my personal projects and research.

## My workflow

1. **Rent a machine**. `rent.py` script helps you find a machine with the desired GPU with my default configuration (e.g. docker image, ssh, and some sensible filtering of machines). See `gpu_names.json` for the list of GPUs.

    ```bash
    # Pick a machine with the desired GPU (e.g. RTX 3000 series)
    python rent.py "RTX 30.*"
    ```

2. **Machine starts**. The machine will setup according to the `setup.sh` script. Modify to suit your needs (e.g. personal dotfiles and git setup). This usually takes about 5 minutes.


3. **Connect to machine**. `rent.py` will wait for the machine to be ready, then output the ssh command to connect to the machine (with ssh or vscode).

    ```bash
    ssh ssh://root@123.123.123.123:12312
    # or
    code-insiders --remote ssh-remote+root@123.123.123.123:12312 /root
    ```

4. **Clone your project**. Clone your project and start developing. Make sure to enable SSH agent forwarding to clone by SSH.

5. **Install project dependencies**. Install your project dependencies (e.g. `pip install -r requirements.txt`).

## Setup

1. **Install dependencies**. The only non-standard dependency is `requests` used by the Vast CLI.

    ```bash
    pip install requests
    ```

2. **Vast AI setup**. You need to upload your SSH public key to Vast AI to connect to the machines. You also need to configure your Vast API key. Check out the [Vast CLI documentation](https://cloud.vast.ai/cli/) for more information.