#!/bin/bash

if [ "$(hostname)" == "xps-linux" ]; then
    # XPS-Linux.
    xrandr --output eDP1 --mode 1920x1080
    feh --bg-scale /home/ben/.files/conf/i3/xps.png

    # Start bluetooth applet.
    blueman-applet &
elif [ "$(hostname)" == "benjamin-bertja" ]; then
    # Grosse bertja!
    feh --bg-scale /home/ben/.files/conf/i3/bertja-1.jpg /home/ben/.files/conf/i3/bertja-2.jpg
else
    notify-send "i3/startup.sh: I don't know this machine!"
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

# Disk tray icon.
udiskie -ans &

# Compton (compositor).
compton &

# Nextcloud sync client.
nextcloud &

# Network-manager applet.
nm-applet &

# Run redshift if it's installed.
which redshift >/dev/null && redshift &

# Notes editor.
/home/ben/.joplin/Joplin.AppImage &
