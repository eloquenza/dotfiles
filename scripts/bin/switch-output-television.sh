#!/bin/sh

# Source:
# https://frdmtoplay.com/i3-udev-xrandr-hotplugging-output-switching/
# Contains good information, reused the script framework for my use case, just switching on television output.

# Get out of town if something errors
set -e

# Get info on the monitors
DP_STATUS=$(</sys/class/drm/card0/card0-DP-2/status)
VGA_STATUS=$(</sys/class/drm/card0/card0-DVI-D-1/status)
HDMI_STATUS=$(</sys/class/drm/card0/card0-HDMI-A-2/status)

# Check to see if our state log exists
if [ ! -f /tmp/monitor ]; then
    touch /tmp/monitor
    STATE=1
else
    STATE=$(</tmp/monitor)
fi

# The state log has the NEXT state to go to in it

# If monitors are disconnected, stay in state 1
if [ "disconnected" == "$HDMI_STATUS" ]; then
    STATE=1
fi

case $STATE in
    1)
    # Both monitors are on, television is turned off/disabled
    /usr/bin/xrandr --output HDMI-1 --off
    /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Turned off the television output"
    STATE=2
    ;;
    2)
    # Both monitors are on, television is turned on/enabled
    /usr/bin/xrandr --output HDMI-1 --auto --right-of DP-2
    /usr/bin/notify-send -t 5000 --urgency=low "Graphics Update" "Turned on the television output"
    STATE=1
    ;;
    *)
    # Unknown state, assume we're in 1
    STATE=1
esac

echo $STATE > /tmp/monitor
