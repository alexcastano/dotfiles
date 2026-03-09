#!/bin/bash
# Run this once per machine to enable auto-restow on git pull.

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

git -C "$DOTFILES_DIR" config core.hooksPath githooks
echo "Git hooks configured. Packages will auto-restow on git pull."
