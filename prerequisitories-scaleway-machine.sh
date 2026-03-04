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

# Clone the repo
sudo -u "$USERNAME" bash -c '
    sudo chown $USER:$USER /opt
    git clone https://github.com/notomio/notom-connect-gateway.git /opt/notom-connect-gateway
'
