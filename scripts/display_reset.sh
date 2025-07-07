#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/collective/.Xauthority

# Turn it back on later (set appropriate resolution)
xrandr --output HDMI-2 --auto --primary

# Move mouse to second screen
xdotool mousemove 1920 540
