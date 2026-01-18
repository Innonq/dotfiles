#!/bin/zsh

STATE_FILE="/tmp/waybar-menu-state"

if [ -f "$STATE_FILE" ]; then
    rm "$STATE_FILE"
    echo '{"text": "❯", "class": "collapsed"}'
else
    touch "$STATE_FILE"
    echo '{"text": "❮", "class": "expanded"}'
fi