#!/bin/bash -e

# Run the DWE OS install script
on_chroot <<- \EOF
    curl -s https://raw.githubusercontent.com/DeepwaterExploration/DWE_OS_2/main/install.sh | sudo bash -s
EOF
