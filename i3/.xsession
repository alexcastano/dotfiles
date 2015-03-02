#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

# Load resources for uxrtv
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
# Load xmodmap to change keys
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

exec xautolock -time 5 -locker 'locker' &
