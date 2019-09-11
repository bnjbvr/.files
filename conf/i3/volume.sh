#!/bin/bash

pactl set-sink-volume @DEFAULT_SINK@ $1
notify-send -t 500 "Volume: $(pactl list sinks | grep "^\sVolume" | awk '{print $5}')"
