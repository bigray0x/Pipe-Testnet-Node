#!/bin/bash

set -e

# ========================
#     SCRIPT BY BIGRAY0X
# ========================
cat <<'EOF'

██████╗ ██╗ ██████╗ ██████╗ ██████╗  █████╗ ██╗   ██╗ ██████╗ ██╗  ██╗
██╔══██╗██║██╔════╝██╔════╝ ██╔══██╗██╔══██╗██║   ██║██╔════╝ ██║ ██╔╝
██████╔╝██║██║     ██║  ███╗██████╔╝███████║██║   ██║██║  ███╗█████╔╝ 
██╔═══╝ ██║██║     ██║   ██║██╔═══╝ ██╔══██║██║   ██║██║   ██║██╔═██╗ 
██║     ██║╚██████╗╚██████╔╝██║     ██║  ██║╚██████╔╝╚██████╔╝██║  ██╗
╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                       SCRIPT BY BIGRAY0X
EOF

# Variables
POP_BINARY_URL="https://download.pipe.network/static/pop-v0.3.0-linux-x64.tar.gz"
CONFIG_DIR="$HOME/pop-node"
CONFIG_FILE="$CONFIG_DIR/config.json"

# 1. Update system and install dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install -y libssl-dev ca-certificates curl tar tmux

# 2. Download and install POP binary
echo "[*] Downloading POP binary..."
wget -q $POP_BINARY_URL -O /tmp/pop.tar.gz
sudo tar -xzf /tmp/pop.tar.gz -C /usr/local/bin
sudo chmod +x /usr/local/bin/pop
rm /tmp/pop.tar.gz

# 3. Network tuning
echo "[*] Applying network performance settings..."
sudo tee /etc/sysctl.d/99-popcache.conf > /dev/null <<EOF
net.ipv4.ip_local_port_range = 1024 65535
net.core.somaxconn = 65535
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_rmem = 4096 87380 16777216
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
EOF
sudo sysctl -p /etc/sysctl.d/99-popcache.conf

# 4. File limits
echo "[*] Setting file limits..."
sudo tee /etc/security/limits.d/popcache.conf > /dev/null <<EOF
*    hard nofile 65535
*    soft nofile 65535
EOF

# 5. Create config directory
mkdir -p "$CONFIG_DIR"

# 6. Prompt for user input
read -p "Enter your PoP name: " POP_NAME
read -p "Enter your location (e.g., City, Country): " POP_LOCATION
read -p "Enter your invite code: " INVITE_CODE

# 7. Generate config.json
cat > "$CONFIG_FILE" <<EOF
{
  "pop_name": "$POP_NAME",
  "pop_location": "$POP_LOCATION",
  "server": {
    "host": "0.0.0.0",
    "port": 4000
  },
  "invite_code": "$INVITE_CODE"
}
EOF

# 8. Start PoP node in tmux
echo "[*] Starting POP node in a tmux session named 'popnode'..."
tmux new-session -d -s popnode "pop --config $CONFIG_FILE"

echo "=== DONE! Your PoP node is now running in a tmux session named 'popnode'."
echo "Use 'tmux attach -t popnode' to view logs."
