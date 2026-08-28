# Agent Guidelines for Dotfiles Repository

## Important Rules
- **Document discoveries**: When adding new features or scripts, suggest documenting them in `docs/`. Keep documentation minimal - just the essentials to understand what exists and where to investigate further.
- **NEVER modify `~/.local/share/omarchy/`**: This is omarchy's git repo. Changes will be lost on updates. Use hooks or dotfiles instead.

## Repository Structure
This is a dotfiles repository using GNU Stow for symlinking. Main directories: `bash/`, `git/`, `hyprland/`, `shell/`, `vim/`, `bin/`, `webapps/`.

## Documentation Index
- [docs/omarchy-quattro-migration.md](docs/omarchy-quattro-migration.md) - **EN CURSO** (rama `quattro`): inventario de la migración de Omarchy 3 a quattro. **Lee la sección "Cómo trabajamos" antes de tocar `hyprland/`**: se decide entrada por entrada, sin sesgo por defecto y sin prisa.
- [docs/hyprland.md](docs/hyprland.md) - Hyprland/Omarchy architecture and what to track
- [docs/webapps.md](docs/webapps.md) - Chromium webapps with Zen Browser integration (open-in-zen extension)
- [docs/lazyvim.md](docs/lazyvim.md) - LazyVim architecture, plugin system, and customization patterns

## Testing & Validation
- Test scripts manually: `~/.local/bin/<script_name>`
- Reload Hyprland: `hyprctl reload`
- Validate shell scripts: `bash -n <script>` or `shellcheck <script>` if available

## Shell Script Style (Bash/Sh)
- Shebang: `#!/bin/bash` or `#!/bin/sh` (sh for POSIX compatibility)
- Comments: Inline for non-obvious logic, header comments for click handlers
- Error handling: Redirect stderr with `2>/dev/null`, check exit codes with `$?`
- Variables: lowercase with underscores (e.g., `device_mac`, `output`)
- Use `[[` in bash, `[` in sh for conditionals
- Escape special chars for pango markup: `&` → `&amp;`, `<` → `&lt;`, `>` → `&gt;`

## File Changes
- Always test scripts after modifications
- Preserve executable permissions: `chmod +x <script>`
