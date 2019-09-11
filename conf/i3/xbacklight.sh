#!/bin/bash

xbacklight $1 10
notify-send -t 500 "Backlight: $(xbacklight | cut -d'.' -f 1)"
