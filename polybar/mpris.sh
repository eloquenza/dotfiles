#!/bin/bash

# Specifying the icon(s) in the script
# This allows us to change its appearance conditionally
play=""
pause=""

player_status=$(playerctl status 2> /dev/null)
if [[ $? -eq 0 ]]; then
    metadata="$(playerctl metadata artist) - $(playerctl metadata title)"
fi

# Foreground color formatting tags are optional
if [[ $player_status = "Playing" ]]; then
    echo "%{F#268bd2}$play $metadata"       # Orange when playing
elif [[ $player_status = "Paused" ]]; then
    echo "%{F#073642}$pause $metadata"       # Greyed out info when paused
else
    echo ""
fi
