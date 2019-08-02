#!/bin/bash

if [ "$(hostname)" == "XPS-Linux" ]; then
    # XPS-Linux.
    xrandr --output eDP-1 --mode 1920x1080
else
    notify-send "i3specific.sh: I don't know this machine!"
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl

nm-applet &
/home/ben/.joplin/Joplin.AppImage &
