#!/bin/bash

# hardcoded, shouldn't change in PipeWire
HEADSET_SINK_ID=$(pactl list short sinks | grep "alsa_output.usb" | cut -f 1)
SPEAKER_SINK_ID=$(pactl list short sinks | grep "alsa_output.pci" | cut -f 1)

PID=$(xdotool getwindowfocus getwindowpid)
PIPEWIRE_CLIENT_ID=$(pactl list clients | grep -e 'object.serial' -e "application.process.id = \"${PID}\"" | grep -B 1 'application' | grep -oP '\d*' -m 1)
SINK_INPUT_ID_FROM_CLIENT=$(pactl list short sink-inputs | grep $PIPEWIRE_CLIENT_ID | cut -f 1)
CURRENT_SINK_ID=$(pactl list short sink-inputs | grep $PIPEWIRE_CLIENT_ID | cut -f 2)
[[ "$CURRENT_SINK_ID" -eq "$HEADSET_SINK_ID" ]] \
    && NEW_SINK_ID=$SPEAKER_SINK_ID \
    || NEW_SINK_ID=$HEADSET_SINK_ID

pactl move-sink-input $SINK_INPUT_ID_FROM_CLIENT $NEW_SINK_ID
