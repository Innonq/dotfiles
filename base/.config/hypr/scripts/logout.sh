#!/usr/bin/env bash

# Power Menu Options
lock="  Lock"
suspend="  Suspend"
hibernate="  Hibernate"
logout="  Logout"
reboot="  Reboot"
shutdown="  Shutdown"

options="$lock\n$suspend\n$hibernate\n$logout\n$reboot\n$shutdown"

# Show Wofi power menu (dedicated config + style)
chosen="$(echo -e "$options" | wofi --show dmenu \
    -c ~/.config/wofi/power.conf \
    -s ~/.config/wofi/power.css)"

case "$chosen" in
    *Lock)      hyprlock ;;
    *Suspend)   systemctl suspend ;;
    *Hibernate) systemctl hibernate ;;
    *Logout)    hyprctl dispatch exit ;;
    *Reboot)    systemctl reboot ;;
    *Shutdown)  systemctl poweroff ;;
esac
