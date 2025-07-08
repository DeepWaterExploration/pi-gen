#!/bin/bash -e

# Setup static ip

# TODO: Move static ip setup to firstrun so that it has a unique uuid

file_path="${ROOTFS_DIR}/etc/NetworkManager/system-connections/Wired connection 1.nmconnection"

cat > "$file_path" << EOF
[connection]
id=Wired connection 1
uuid=$(uuidgen)
type=ethernet
autoconnect-priority=-999
interface-name=eth0
timestamp=$(date +%s)

[ethernet]

[ipv4]
address1=192.168.2.2/24,192.168.2.1
method=manual

[ipv6]
addr-gen-mode=default
method=auto

[proxy]
EOF

chmod 600 "$file_path"
DWE_VERSION=${DWE_VERSION:-latest}

# Run the DWE OS install script
on_chroot <<- \EOF
    curl -s https://raw.githubusercontent.com/DeepwaterExploration/DWE_OS_2/main/install.sh | sudo bash -s -- $DWE_VERSION
EOF
