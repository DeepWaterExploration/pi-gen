#!/bin/bash -e
# Install the Bridge Adapter

echo "Starting bridge-adapter installation script"
log "Installing Bridge Adapter"

#run the script as root from now on
on_chroot << EOF
INSTALL_DIR=/opt/bridge-adapter
echo "Installing Bridge Adapter to \${INSTALL_DIR}"
mkdir -p "\${INSTALL_DIR}"
ls "\${INSTALL_DIR}"

wget "https://raw.githubusercontent.com/DeepWaterExploration/DWEOS-wifi-detector/refs/heads/main/main.py" -O "\${INSTALL_DIR}/main.py"
wget "https://raw.githubusercontent.com/DeepWaterExploration/DWEOS-wifi-detector/refs/heads/main/requirements.txt" -O "\${INSTALL_DIR}/requirements.txt"
wget "https://raw.githubusercontent.com/DeepWaterExploration/DWEOS-wifi-detector/refs/heads/main/NetworkManager.py" -O "\${INSTALL_DIR}/NetworkManager.py"
wget "https://raw.githubusercontent.com/DeepWaterExploration/DWEOS-wifi-detector/refs/heads/main/run_with_env.sh" -O "\${INSTALL_DIR}/run_with_env.sh"

cd "\${INSTALL_DIR}"

python3 -m venv env
. env/bin/activate
pip install -r requirements.txt

cat > /etc/systemd/system/bridge-adapter.service << SERVICE_EOF
[Unit]
Description=Web Based UVC Control Driver for the DeepWater Exploration exploreHD and HDCam.

[Service]
Type=simple
TimeoutStartSec=0
Restart=always
ExecStart=\${INSTALL_DIR}/run_with_env.sh

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl enable bridge-adapter
systemctl start bridge-adapter

echo "Bridge adapter installation completed"
EOF