# Chromium Webapps with Zen Browser Integration

This setup allows you to use Chromium's clean `--app` mode for webapps while having external links open in Zen Browser with the correct container and workspace.

## The Problem

- **Chromium webapps** (`chromium --app=URL`) provide a clean, frameless window experience
- **But**: Links clicked inside these webapps open in Chromium, not your default browser
- **Extra challenge**: Need to route links to different Zen containers (Work vs Personal)

## The Solution

```
┌─────────────────────────────────────────────────────────────────┐
│                         ARCHITECTURE                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   Chromium Webapp                    Zen Browser                │
│   ┌─────────────┐                   ┌─────────────┐            │
│   │ WhatsApp    │  click link       │ Personal    │            │
│   │ (Personal)  │ ───────────────►  │ Workspace   │            │
│   └─────────────┘   ext intercepts  │ + Container │            │
│                     zen-open://     └─────────────┘            │
│   ┌─────────────┐                   ┌─────────────┐            │
│   │ Outlook     │  click link       │ Work        │            │
│   │ (Work)      │ ───────────────►  │ Workspace   │            │
│   └─────────────┘                   │ + Container │            │
│                                     └─────────────┘            │
└─────────────────────────────────────────────────────────────────┘
```

### Components

1. **open-in-zen Chrome Extension**: Intercepts external link clicks, redirects to `zen-open://` protocol
2. **zen-open:// Protocol Handler**: OS-level handler that calls our script
3. **zen-open-url Script**: Opens URLs in Zen with the correct container based on `WEBAPP_CONTEXT` env var
4. **Zen Browser Setup**: Workspaces + Containers + "Open URL in Container" extension

## Prerequisites

### Zen Browser Setup

1. **Create Workspaces**: Personal and Work (or your preferred names)

2. **Assign Containers to Workspaces**:
   - Personal workspace → Personal container (as default)
   - Work workspace → Work container (as default)

3. **Enable Auto-Switch Setting**:
   - Settings → Tab Management → Workspaces
   - Enable: "Switch to workspace where container is set as default when opening container tabs"

4. **Install "Open URL in Container" Extension**:
   - Firefox Add-ons: https://addons.mozilla.org/en-US/firefox/addon/open-url-in-container/
   - This allows opening URLs directly into specific containers via special URL format

## Installation

```bash
cd ~/.dotfiles
./install-webapps.sh
```

The installer will:
- Stow the webapps dotfiles (extension, config, protocol handler, webapp .desktop files)
- Register the `zen-open://` protocol handler
- Offer to open Zen Browser to install the required extension
- Verify all components are in place

**Important**: Restart Chromium after installation for the extension to load.

## Usage

### Launch Webapps with Context

```bash
# Personal webapp
WEBAPP_CONTEXT=Personal chromium --app="https://web.whatsapp.com"

# Work webapp
WEBAPP_CONTEXT=Work chromium --app="https://outlook.office.com/mail/"
```

### With omarchy-launch-webapp

Modify your `.desktop` files to include the context:

```desktop
[Desktop Entry]
Name=WhatsApp
Exec=env WEBAPP_CONTEXT=Personal omarchy-launch-webapp https://web.whatsapp.com/
...
```

Or create wrapper scripts in `~/.dotfiles/bin/`:

```bash
#!/bin/bash
# webapp-personal
export WEBAPP_CONTEXT=Personal
exec omarchy-launch-webapp "$@"
```

## File Structure

```
~/.dotfiles/
├── install-webapps.sh            # Idempotent installer
├── bin/
│   └── zen-open-url              # URL handler script
├── webapps/
│   ├── .config/
│   │   ├── chromium-flags.conf   # Loads the extension
│   │   └── chromium-extensions/
│   │       └── open-in-zen/      # Our custom extension
│   │           ├── manifest.json
│   │           ├── content.js
│   │           └── icon.png
│   └── .local/share/applications/
│       ├── zen-open-handler.desktop  # Protocol handler
│       ├── WhatsApp.desktop          # Webapp .desktop files
│       ├── ChatGPT.desktop
│       ├── ...
│       └── icons/
│           ├── WhatsApp.png          # Webapp icons
│           └── ...
└── docs/
    └── webapps.md                # This file
```

## How It Works

### 1. Extension Intercepts Links

The `open-in-zen` extension runs a content script on all pages that:
- Listens for click events on links
- Checks if the link is external (different hostname)
- If external, prevents default behavior and redirects to `zen-open://URL`

### 2. Protocol Handler Routes to Script

The OS has `zen-open://` registered to `zen-open-handler.desktop`, which calls:
```bash
~/bin/zen-open-url %u
```

### 3. Script Opens in Zen with Context

The script:
- Reads `WEBAPP_CONTEXT` environment variable (inherited from Chromium)
- Defaults to "Personal" if not set
- Opens Zen with: `zen-browser "ext+container:name=$CONTAINER&url=$URL"`

### 4. Zen Routes to Correct Workspace

The "Open URL in Container" extension in Zen:
- Parses the `ext+container:` URL
- Opens in the specified container
- Zen's "auto-switch" setting moves the tab to the correct workspace

## Troubleshooting

### Links not opening in Zen

1. **Check extension is loaded**: Visit `chrome://extensions` in Chromium
2. **Verify protocol handler**: `xdg-mime query default x-scheme-handler/zen-open`
3. **Test protocol directly**: `xdg-open "zen-open://https://example.com"`

### Wrong container/workspace

1. **Check WEBAPP_CONTEXT is set**: Add `echo $WEBAPP_CONTEXT > /tmp/ctx` to zen-open-url
2. **Verify Zen settings**: Ensure "Switch to workspace where container is set as default" is enabled
3. **Check container names**: Must match exactly (case-sensitive)

### Extension not loading

1. **Restart Chromium** after installation
2. **Check chromium-flags.conf**: `grep load-extension ~/.config/chromium-flags.conf`
3. **Verify extension files**: `ls ~/.config/chromium-extensions/open-in-zen/`

## Updating

If omarchy updates `chromium-flags.conf`, you may need to:
1. Re-run `./install-webapps.sh`, or
2. Manually re-add the extension path to `--load-extension=`

## Adding New Webapps

To add a new webapp to your dotfiles:

1. **Create the .desktop file** in `~/.dotfiles/webapps/.local/share/applications/`:
   ```desktop
   [Desktop Entry]
   Version=1.0
   Name=AppName
   Comment=AppName
   Exec=env WEBAPP_CONTEXT=Personal omarchy-launch-webapp https://example.com/
   Terminal=false
   Type=Application
   Icon=/home/alex/.local/share/applications/icons/AppName.png
   StartupNotify=true
   ```
   Replace `Personal` with `Work` for work-related apps.

2. **Add the icon** to `~/.dotfiles/webapps/.local/share/applications/icons/`:
   - Provide an icon URL (PNG format, e.g., from https://dashboardicons.com)
   - Download and save as `AppName.png`

3. **Re-stow** to create symlinks:
   ```bash
   cd ~/.dotfiles && stow -R webapps
   ```

4. **Update desktop database**:
   ```bash
   update-desktop-database ~/.local/share/applications/
   ```

### Current Webapps

| App | Container | URL |
|-----|-----------|-----|
| ChatGPT | Work | chatgpt.com |
| GitHub | Work | github.com |
| Google Photos | Personal | photos.google.com |
| Tailscale Admin Console | Personal | login.tailscale.com/admin/machines |
| WhatsApp | Personal | web.whatsapp.com |
| YouTube | Personal | youtube.com |

## Uninstalling

To remove this setup:
```bash
# Remove stowed files
cd ~/.dotfiles && stow -D webapps

# Remove protocol handler from mimeapps.list
sed -i '/x-scheme-handler\/zen-open/d' ~/.config/mimeapps.list

# Update desktop database
update-desktop-database ~/.local/share/applications/
```
