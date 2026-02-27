#!/usr/bin/env bash

# Get volume percentage
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}')
mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o MUTED)

if [[ -n "$mute_status" ]]; then
    dunstify -a "volume_script" -u low -i audio-volume-muted -h string:x-dunst-stack-tag:volume_notif "Volume: Muted"
else
    dunstify -a "volume_script" -u low -i audio-volume-high -h int:value:"$volume" -h string:x-dunst-stack-tag:volume_notif "Volume: ${volume}%"
fi
