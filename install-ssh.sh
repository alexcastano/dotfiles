#!/bin/bash

echo "Installing systemd services..."

# Symlink the ssh configuration and service using stow
stow ssh

# Reload systemd user daemon to pick up new changes
systemctl --user daemon-reload

# Enable and start the ssh-agent service
systemctl --user enable --now ssh-agent.service

echo "✅ SSH configuration and services installed."
