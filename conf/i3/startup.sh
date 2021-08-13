#!/bin/bash

## All the programs run at startup.

if [ "$(hostname)" == "xps-linux" ]; then
    # XPS-Linux.
    xrandr --output eDP1 --mode 1920x1080
    feh --bg-fill /home/ben/.files/conf/i3/xps.png
elif [ "$(hostname)" == "benjamin-bertja" ] || [ "$(hostname)" == "bertka-linux" ]; then
    # Grosse bertja!
    feh --bg-fill /home/ben/.files/conf/i3/unsplash.jpg
else
    notify-send "i3/startup.sh: I don't know this machine!"
fi

# On every restart, try to set a favorite keyboard layout.
setxkbmap us -variant benjamin || setxkbmap us -variant altgr-intl

# Map capslock to escape.
xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'

run_if_present () {
    exists=NO

    command -v $1 &> /dev/null
    if [ $? -eq 0 ]
    then
        exists=YES
    else
        which $1 > /dev/null
        if [ $? -eq 0 ]
        then
            exists=YES
        fi
    fi

    if [ $exists = "YES" ]
    then
        if [ $# -ge 2 ]
        then
            prog=$1
            shift
            $prog $@ &
        else
            $1 &
        fi
    fi
}

run_if_present /usr/bin/ulauncher

# Bluetooth applet.
run_if_present /usr/bin/blueman-applet

# Disk tray icon.
run_if_present udiskie -ans

# On-disk encryption.
run_if_present /home/ben/sync/bin/cryptomator

# Lighter screen color with red.
run_if_present redshift -c ~/.config/redshift.conf

# i3 rename workspace according to windows it contains
run_if_present /home/ben/.cargo/bin/i3wsr --icons awesome --no-icon-names --remove-duplicates

# Network-manager applet.
nm-applet &

# Compton (compositor).
compton &

# Nextcloud sync client.
nextcloud &
