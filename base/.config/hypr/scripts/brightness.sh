#!/usr/bin/env bash

# Give the brightnessctl command time to apply before reading
sleep 0.05

# Get brightness percentage
brightness=$(brightnessctl -m | awk -F, '{print int($4)}')

dunstify -a "brightness_script" -u low -i display-brightness -h int:value:"$brightness" -h string:x-dunst-stack-tag:brightness_notif "Brightness: ${brightness}%"
