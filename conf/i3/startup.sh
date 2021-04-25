#!/bin/bash

if [ "$(hostname)" == "xps-linux" ]; then
    # XPS-Linux.
    xrandr --output eDP1 --mode 1920x1080
    feh --bg-scale /home/ben/.files/conf/i3/xps.png
elif [ "$(hostname)" == "benjamin-bertja" ] || [ "$(hostname)" == "bertka-linux" ]; then
    # Grosse bertja!
    feh --bg-scale /home/ben/.files/conf/i3/unsplash.jpg
else
    notify-send "i3/startup.sh: I don't know this machine!"
fi

# Start bluetooth applet, if available.
if [ -f /usr/bin/blueman-applet ]
then
    blueman-applet &
fi

# Start cryptomator, if available.
if [ -f /home/ben/sync/bin/cryptomator ]
then
    /home/ben/sync/bin/cryptomator &
fi

path_i3wsr = $(which i3wsr)
if [ -x $path_i3wsr ]
then
    $path_i3wrs &
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl
# Map capslock to escape.
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
which redshift >/dev/null && redshift -c ~/.config/redshift.conf &
