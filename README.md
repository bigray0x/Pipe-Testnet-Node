# Pipe-Testnet-Node

this guide is for those who ran pipe devnet node and has gotten an invite code to run the devnet node.

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
Test Docker Installation

```bash
sudo docker run hello-world
```


step 2 : Create Pipe Docker Directory and Dockerfile

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
RUN wget -O pop.tar.gz https://download.pipe.network/static/pop-v0.3.0-linux-x64.tar.gz && \
    tar -xzf pop.tar.gz && \
    chmod +x pop && \
    mv pop /usr/local/bin/pop && \
    rm pop.tar.gz

# Create volume for config
VOLUME /app/config

# Run POP with config
CMD ["pop", "--config", "/app/config/config.json"]
```
