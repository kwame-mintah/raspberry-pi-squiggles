#!/bin/bash
# # At 22:05 PM, disable HDMI-2 (main display) and move mouse to HDMI-1 (mini monitor)
(crontab -l 2>/dev/null; echo "0 22 * * * /home/collective/Documents/Local/scripts/display_reset.sh") | crontab -
