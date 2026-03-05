#!/bin/bash
# Non-interactive setup for baking a Scaleway gateway image.
# This script is meant to be downloaded and run from a fresh Ubuntu VM:
#   curl -fsSL https://raw.githubusercontent.com/notomio/notom-connect-gateway-prerequisitories/main/setup-scaleway-bake.sh | bash
#
# What it does:
#   1. Creates the 'notom' service user with passwordless sudo
#   2. Copies root's SSH keys to the notom user
#   3. Prepares /opt for the gateway repo
#
# After this, clone the gateway repo into /opt/notom-connect-gateway
# and run install-on-machine.sh.
set -euo pipefail

USERNAME="notom"

# Create service user
if ! id "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    echo "User '$USERNAME' created"
else
    echo "User '$USERNAME' already exists"
fi

# Copy root's SSH keys so we can SSH as the service user
if [ -f /root/.ssh/authorized_keys ]; then
    sudo -u "$USERNAME" mkdir -p /home/$USERNAME/.ssh
    cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh/authorized_keys
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
    echo "SSH keys copied to '$USERNAME'"
fi

# Prepare /opt for the gateway repo
chown $USERNAME:$USERNAME /opt

echo "Setup complete"
