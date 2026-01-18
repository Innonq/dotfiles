#!/usr/bin/env

killall waybar || true

waybar &

hyprctl reload