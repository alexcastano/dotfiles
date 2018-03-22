xrandr --newmode 2560x1440 241.50 2560 2608 2640 2720 1440 1443 1448 1481 +hsync -vsync
xrandr --addmode HDMI-2 2560x1440
xrandr --output HDMI-2 --mode 2560x1440 --output eDP-1 --off

switch-hdmi-audio
/home/alex/.config/polybar/launch.sh

change_layout
