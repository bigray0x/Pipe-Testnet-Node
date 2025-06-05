# Pipe-Testnet-Node

this guide is for those who ran pipe devnet node and or anyone has gotten an invite code to run the Testnet node.

![IMG_2730](https://github.com/user-attachments/assets/e6e5b781-9b73-446a-8d13-e9f3d7b395e1)

### Pre-Requisites 

Ram : 16GB
Core : 4+ CPU Cores
SSD : storage with 100GB+ available space
internet Connection : 1Gbps+ network connection

## step by step guide to run the testnet node using docker

### step 1 : install docker 

A: Install sudo and other pre-requisites :

```bash
apt update && apt install -y sudo && sudo apt-get update && sudo apt-get upgrade -y && sudo apt install curl ufw iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev -y
Install docker :
sudo apt update -y && sudo apt upgrade -y
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y && sudo apt upgrade -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
B: Test Docker Installation

```bash
sudo docker run hello-world
```


### step 2 : Create Pipe Docker Directory and Dockerfile

A: Create pipe-docker directory.

```bash
mkdir -p ~/pipe-docker && cd ~/pipe-docker
```

B: Create Dockerfile.

```bash
nano Dockerfile
```

C: Paste this into the file without editing it.
```bash
# Use Ubuntu 24.04 which ships with glibc >= 2.39
FROM ubuntu:24.04

# Install dependencies
RUN apt update && \
    apt install -y curl wget libssl-dev ca-certificates tmux && \
    apt clean

# Set work directory
WORKDIR /app

# Download pop binary
RUN wget -O pop.tar.gz https://download.pipe.network/static/pop-v0.3.2-linux-x64.tar.gz && \
    tar -xzf pop.tar.gz && \
    chmod +x pop && \
    mv pop /usr/local/bin/pop && \
    rm pop.tar.gz

# Create volume for config
VOLUME /app/config

# Run POP with config
CMD ["pop", "--config", "/app/config/config.json"]
```

### Step 3: Create config/config.json

A: Create the config and config.json folder and file. 

```bash
mkdir -p ~/pipe-docker/config && cd ~/pipe-docker/config && nano config.json
```

B: edit the file below and paste with your details inside the config.json.  

```bash
{
  "pop_name": "your-pop-name",
  "pop_location": "Your Location, Country",
  "server": {
    "host": "0.0.0.0",
    "port": 443,
    "http_port": 80,
    "workers": 40
  },
  "cache_config": {
    "memory_cache_size_mb": 4096,
    "disk_cache_path": "./cache",
    "disk_cache_size_gb": 100,
    "default_ttl_seconds": 86400,
    "respect_origin_headers": true,
    "max_cacheable_size_mb": 1024
  },
  "api_endpoints": {
    "base_url": "https://dataplane.pipenetwork.com"
  },
  "identity_config": {
    "node_name": "your-node-name",
    "name": "Your Name",
    "email": "your.email@example.com",
    "website": "https://your-website.com",
    "discord": "your_discord_username",
    "telegram": "your_telegram_handle",
    "solana_pubkey": "YOUR_SOLANA_WALLET_ADDRESS_FOR_REWARDS"
  },
  "invite_code": "your_code_here"
}
```
C: Build the dockerimage inside the pipe-docker folder.

```bash
cd $HOME/pipe-docker && docker build -t pipe-pop .
```
### Step 4: Run The Pipe Node

A: Run the node using docker.

```bash
docker rm -f popnode

docker run -d --name popnode \
  -v ~/pipe-docker/config/config.json:/app/config.json \
  -p 4000:4000 \
  pipe-pop pop /app/config.json
```

B: Monitor the Logs

```bash
docker logs -f popnode
```

if you see this then you're good!

![Image 5-12-25 at 12 45 PM](https://github.com/user-attachments/assets/864eb481-dbb9-46ea-9cf9-f065cd3b639e)

