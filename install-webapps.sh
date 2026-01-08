#!/bin/bash
# Chromium Webapps Setup - Idempotent installer
# This script sets up the open-in-zen extension and protocol handler
#
# See docs/webapps.md for full documentation

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure git is clean before starting
if [[ -n "$(cd "$DOTFILES_DIR" && git status --porcelain)" ]]; then
    echo "Error: Git working directory is dirty. Please commit or stash changes first."
    exit 1
fi

echo "========================================"
echo "Chromium Webapps + Zen Browser Setup"
echo "========================================"
echo ""

# 1. Stow webapps dotfiles
echo "[1/5] Stowing webapps dotfiles..."
cd "$DOTFILES_DIR"
stow --adopt webapps
git restore .
echo "      Done"

# 2. Register zen-open:// protocol handler (idempotent)
echo "[2/5] Registering zen-open:// protocol handler..."
MIMEAPPS="$HOME/.config/mimeapps.list"
HANDLER_ENTRY="x-scheme-handler/zen-open=zen-open-handler.desktop"

if [[ -f "$MIMEAPPS" ]]; then
    if ! grep -q "x-scheme-handler/zen-open" "$MIMEAPPS"; then
        if grep -q "\[Default Applications\]" "$MIMEAPPS"; then
            sed -i "/\[Default Applications\]/a $HANDLER_ENTRY" "$MIMEAPPS"
        else
            echo -e "\n[Default Applications]\n$HANDLER_ENTRY" >> "$MIMEAPPS"
        fi
        echo "      Added to mimeapps.list"
    else
        echo "      Already registered"
    fi
else
    mkdir -p "$(dirname "$MIMEAPPS")"
    cat > "$MIMEAPPS" << EOF
[Default Applications]
$HANDLER_ENTRY
EOF
    echo "      Created mimeapps.list"
fi

# 3. Update desktop database
echo "[3/5] Updating desktop database..."
update-desktop-database "$HOME/.local/share/applications/" 2>/dev/null || true
echo "      Done"

# 4. Verify installation
echo "[4/5] Verifying installation..."
ERRORS=0

if [[ ! -f "$HOME/.config/chromium-extensions/open-in-zen/manifest.json" ]]; then
    echo "      [FAIL] Extension not found"
    ERRORS=$((ERRORS + 1))
else
    echo "      [OK] Chrome extension installed"
fi

if [[ ! -f "$HOME/.config/chromium-flags.conf" ]]; then
    echo "      [FAIL] chromium-flags.conf not found"
    ERRORS=$((ERRORS + 1))
else
    echo "      [OK] chromium-flags.conf configured"
fi

HANDLER=$(xdg-mime query default x-scheme-handler/zen-open 2>/dev/null)
if [[ "$HANDLER" != "zen-open-handler.desktop" ]]; then
    echo "      [FAIL] Protocol handler not registered"
    ERRORS=$((ERRORS + 1))
else
    echo "      [OK] Protocol handler registered"
fi

if [[ ! -x "$HOME/bin/zen-open-url" ]]; then
    echo "      [FAIL] zen-open-url script not found or not executable"
    ERRORS=$((ERRORS + 1))
else
    echo "      [OK] zen-open-url script ready"
fi

# 5. Zen Browser extension
echo "[5/5] Zen Browser extension..."
ZEN_EXT_URL="https://addons.mozilla.org/en-US/firefox/addon/open-url-in-container/"

echo "      The 'Open URL in Container' extension is required in Zen Browser."
echo ""
read -p "      Open Zen Browser to install the extension? [Y/n] " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "      Opening Zen Browser..."
    zen-browser "$ZEN_EXT_URL" &>/dev/null &
    disown
    echo "      Please install the extension and configure Zen:"
    echo "        1. Install the extension from the page that opened"
    echo "        2. Go to Settings -> Tab Management -> Workspaces"
    echo "        3. Enable: 'Switch to workspace where container is set as default'"
    echo "        4. Assign containers to your workspaces (Work -> Work, Personal -> Personal)"
fi

# Summary
echo ""
echo "========================================"
if [[ $ERRORS -eq 0 ]]; then
    echo "Installation complete!"
    echo "========================================"
    echo ""
    echo "IMPORTANT: Restart Chromium to load the extension."
    echo ""
    echo "Usage:"
    echo "  WEBAPP_CONTEXT=Personal chromium --app=\"https://web.whatsapp.com\""
    echo "  WEBAPP_CONTEXT=Work chromium --app=\"https://outlook.office.com\""
    echo ""
    echo "See docs/webapps.md for full documentation."
else
    echo "Installation completed with $ERRORS error(s)"
    echo "========================================"
    echo "Check the messages above and fix any issues."
    exit 1
fi
