#!/bin/bash
set -e

USERNAME="notom"

# Create service user
if ! id "$USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
    chmod 0440 /etc/sudoers.d/$USERNAME
    echo "User '$USERNAME' created"
fi

# Copy root's SSH keys so we can SSH as the service user
if [ -f /root/.ssh/authorized_keys ]; then
    sudo -u "$USERNAME" mkdir -p /home/$USERNAME/.ssh
    cp /root/.ssh/authorized_keys /home/$USERNAME/.ssh/authorized_keys
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh
    chmod 700 /home/$USERNAME/.ssh
    chmod 600 /home/$USERNAME/.ssh/authorized_keys
fi

# Now a user was created please RECONNECT TO THE MACHINE AND LOG IN AS THE USER notom
# you can do that from VSCODE
# then you can run the following commands:

echo ""
echo "============================================================"
echo "  User '$USERNAME' has been created successfully."
echo "  Please RECONNECT to this machine and LOG IN AS '$USERNAME'."
echo "  You can do that from VSCode."
echo "  Then re-run this script as '$USERNAME'."
echo "============================================================"
echo ""
read -p "Press Enter to continue (only if you are already logged in as '$USERNAME')..."

if [ "$(whoami)" != "$USERNAME" ]; then
    echo "ERROR: You are currently logged in as '$(whoami)', not '$USERNAME'."
    echo "Please reconnect as '$USERNAME' and re-run this script."
    exit 1
fi

sudo chown $USER:$USER /opt
git clone https://github.com/notomio/notom-connect-gateway.git /opt/notom-connect-gateway

