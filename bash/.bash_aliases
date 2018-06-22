alias ins='aurman -S --noconfirm'
alias rem='aurman -Rns'
alias upd='sudo pacman -Su'
alias upg='aurman -Syua --noconfirm'
alias shp='aurman -Si'
alias sea='aurman -Ss'
alias shf='aurman -Ql'
alias orphan='aurman -Qdtq'
alias f2p='aurman -Qo'
alias top='htop'
alias dhclient='dhclient -v'

alias ver-scr='xrandr --output DP1 --mode 1920x1200 --pos 0x0 --rotate left --output LVDS1 --mode 1366x768 --pos 1200x780'
alias hor-scr='xrandr --output DP1 --mode 1920x1200 --pos 0x0 --rotate normal --output LVDS1 --mode 1366x768 --pos 1920x432'
alias pro-scr='xrandr --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal --output LVDS1 --off'
alias mus-scr='xrandr --output HDMI1 --mode 1280x720 --pos 0x0 --rotate normal --output LVDS1 --mode 1366x768 --pos 0x0'
alias dis-scr='xrandr --output LVDS1 --mode 1366x768 --output DP1 --off --output VGA1 --off --output HDMI1 --off'
alias ofi-scr='xrandr --output eDP1 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --mode 1920x1080 --pos 0x0 --rotate normal'

alias remotevnc="ssh -t -L 5900:localhost:5900 insomnia 'x11vnc -ncache 10 -localhost -display :0'"

alias ssh-fix='eval `ssh-agent` ; echo $SSH_AUTH_SOCK ; ssh-add'
alias pg='ps aux | grep'

alias pythonweb='python -m http.server'
alias cal='cal -m'

alias be='bundle exec'
alias bes='bundle exec spring'

alias gg='surfraw google'
