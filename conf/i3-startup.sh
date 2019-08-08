#!/bin/bash

if [ "$(hostname)" == "xps-linux" ]; then
    # XPS-Linux.
    xrandr --output eDP1 --mode 1920x1080

    # Disk tray icon.
    udiskie -ans &

    # Compton (compositor).
    compton &
else
    notify-send "i3specific.sh: I don't know this machine!"
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl

# Nextcloud sync client.
nextcloud &

# Network-manager applet.
nm-applet &

# Notes editor.
/home/ben/.joplin/Joplin.AppImage &
