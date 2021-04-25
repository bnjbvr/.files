#!/bin/bash
if [ -e "/home/ben/.files/bin/i3status-rs" ]; then
    hostname=$(hostname)
    if [ -e "/home/ben/.files/conf/i3/statusbar-$hostname.toml" ]; then
        ~/.files/bin/i3status-rs ~/.files/conf/i3/statusbar-$(hostname).toml
    else
        i3status
    fi
else
    i3status
fi
