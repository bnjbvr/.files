#!/bin/bash
if [ -e "/home/ben/code/i3status-rust/target/release/i3status-rs" ]; then
    hostname=$(hostname)
    if [ -e "/home/ben/.files/conf/i3-statusbar-$hostname.toml" ]; then
        ~/code/i3status-rust/target/release/i3status-rs \
            ~/.files/conf/i3-statusbar-$(hostname).toml
    else
        i3status
    fi
else
    i3status
fi
