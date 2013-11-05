alias ins='yaourt -S'
alias rem='yaourt -Rns'
alias upd='sudo pacman -Su'
alias upg='yaourt -Syua'
alias shp='yaourt -Si'
alias sea='yaourt -Ss'
alias shf='yaourt -Ql'
alias orphan='yaourt -Qdtq'
alias f2p='yaourt -Qo'
alias top='htop'
alias dhclient='dhclient -v'

alias ver-scr='xrandr --output DP1 --mode 1920x1200 --pos 0x0 --rotate left --output LVDS1 --mode 1366x768 --pos 1200x780'
alias hor-scr='xrandr --output DP1 --mode 1920x1200 --pos 0x0 --rotate normal --output LVDS1 --mode 1366x768 --pos 1920x432'
alias dis-scr='xrandr --output LVDS1 --mode 1366x768 --output DP1 --off --output VGA1 --off --output HDMI1 --off'

alias remotevnc="ssh -t -L 5900:localhost:5900 insomnia 'x11vnc -ncache 10 -localhost -display :0'"

alias ssh-fix='eval `ssh-agent` ; echo $SSH_AUTH_SOCK ; ssh-add'
alias pg='ps aux | grep'

alias pythonweb='python -m http.server'
alias cal='cal -m'
