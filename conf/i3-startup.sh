#!/bin/bash

if [ "$(hostname)" == "xps-linux" ]; then
    # XPS-Linux.
    xrandr --output eDP1 --mode 1920x1080
    which udiskie && udiskie -ans &
else
    notify-send "i3specific.sh: I don't know this machine!"
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl

nm-applet &
/home/ben/.joplin/Joplin.AppImage &
