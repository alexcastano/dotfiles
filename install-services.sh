#!/bin/bash

echo "Installing systemd services..."

# Symlink the systemd unit files using stow
stow systemd

# Reload systemd user daemon to pick up new changes
systemctl --user daemon-reload

# Enable and start the ssh-agent service
systemctl --user enable --now ssh-agent.service

echo "✅ Systemd services installed and ssh-agent started."
