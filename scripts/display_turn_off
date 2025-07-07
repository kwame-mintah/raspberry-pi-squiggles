#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/collective/.Xauthority

# Turn off HDMI-2
xrandr --output HDMI-2 --off && \
xrandr --output HDMI-1 --primary

# Move mouse to second screen
xdotool mousemove 1920 540

# Start screen saver again
xscreensaver-command -activate
