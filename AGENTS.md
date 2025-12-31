# Agent Guidelines for Dotfiles Repository

## Important Rules
- **Document discoveries**: When adding new features or scripts, suggest documenting them in `docs/`. Keep documentation minimal - just the essentials to understand what exists and where to investigate further.
- **NEVER modify `~/.local/share/omarchy/`**: This is omarchy's git repo. Changes will be lost on updates. Use hooks or dotfiles instead.

## Repository Structure
This is a dotfiles repository using GNU Stow for symlinking. Main directories: `bash/`, `git/`, `hyprland/`, `i3/`, `shell/`, `vim/`, `bin/`, `webapps/`.

## Documentation Index
- [docs/hyprland.md](docs/hyprland.md) - Hyprland/Omarchy architecture and what to track
- [docs/which-key.md](docs/which-key.md) - Which-key popup for Hyprland submaps (eww-based)
- [docs/webapps.md](docs/webapps.md) - Chromium webapps with Zen Browser integration (open-in-zen extension)
- [docs/lazyvim.md](docs/lazyvim.md) - LazyVim architecture, plugin system, and customization patterns

## Testing & Validation
- Test scripts manually: `~/.config/i3/scripts/<script_name>`
- Reload i3: `i3-msg reload` or `i3-msg restart`
- Test i3blocks: `i3blocks -c ~/.config/i3/i3blocks.conf`
- Validate shell scripts: `bash -n <script>` or `shellcheck <script>` if available

## Shell Script Style (Bash/Sh)
- Shebang: `#!/bin/bash` or `#!/bin/sh` (sh for POSIX compatibility)
- Comments: Inline for non-obvious logic, header comments for click handlers
- Error handling: Redirect stderr with `2>/dev/null`, check exit codes with `$?`
- Variables: lowercase with underscores (e.g., `device_mac`, `output`)
- Use `[[` in bash, `[` in sh for conditionals
- Escape special chars for pango markup: `&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`

## i3blocks Scripts
- Output format: Plain text or pango markup (if `markup=pango` in config)
- Click events: Check `$BLOCK_BUTTON` (1=left, 2=middle, 3=right, 4=scroll-up, 5=scroll-down)
- Signals: Use `pkill -RTMIN+<N> i3blocks` for instant refresh (match signal number in config)
- Icons: Use Nerd Font icons (test rendering before committing)
- Exit immediately after handling clicks to prevent blocking

## File Changes
- Always test scripts after modifications
- Preserve executable permissions: `chmod +x <script>`
- Keep spacing consistent in i3blocks.conf (labels should include trailing space if needed)
