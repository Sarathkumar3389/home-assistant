#!/bin/bash

# Exit on error
set -e

echo "=== SSH Key Setup Script ==="

# Ask for username and host
read -p "Enter remote username: " USERNAME
read -p "Enter remote host (IP or hostname): " HOST

# Check if SSH key already exists
if [ ! -f "$HOME/.ssh/id_rsa" ]; then
    echo "[+] No SSH key found. Generating new key pair..."
    ssh-keygen -t rsa -b 4096 -C "$USER@$HOST" -N "" -f "$HOME/.ssh/id_rsa"
else
    echo "[+] SSH key already exists. Skipping generation."
fi

# Install public key to remote host
echo "[+] Copying public key to $USERNAME@$HOST ..."
ssh-copy-id -i "$HOME/.ssh/id_rsa.pub" $USERNAME@$HOST

# Fix permissions on both ends
echo "[+] Fixing permissions..."
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub

# Test login
echo "[+] Testing SSH connection..."
ssh -o PasswordAuthentication=no $USERNAME@$HOST "echo '[+] SSH login successful!'"

echo "=== Done! You can now login using: ssh $USERNAME@$HOST ==="
