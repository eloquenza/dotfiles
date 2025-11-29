#! /bin/bash

state="/home/eloquenza/.local/state/togglemonitorlock"
booleanvalue="false"

if [[ -f ${state} ]]; then
    booleanvalue=$(cat ${state})
fi

if [[ ${booleanvalue} == "true" ]]; then
    hyprctl keyword monitor DP-2, 2560x1440@144, 1920x0, 1, bitdepth, 10
    echo "false" > ${state}
    echo "false"
else
    hyprctl keyword monitor DP-2, 2560x1440@144, 2020x0, 1, bitdepth, 10
    echo "true" > ${state}
    echo "true"
fi
