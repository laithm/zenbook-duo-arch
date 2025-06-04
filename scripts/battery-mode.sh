#!/bin/bash

# Detect battery state
state=$(upower -i $(upower -e | grep BAT) | grep "state" | awk '{print $2}')

if [[ "$state" == "discharging" ]]; then
    echo "[Battery] Enabling power-saver settings"

    # Power profile
    powerprofilesctl set power-saver

    # CPU autoscaling
    auto-cpufreq --start

    # Lower refresh rate on all screens
    hyprctl keyword monitor "eDP-1, preferred, 0x0, 1, 60Hz"
    hyprctl keyword monitor "eDP-2, preferred, 0x900, 1, 60Hz"
    hyprctl keyword monitor "DP-2, preferred, 1440x0, 1, 60Hz"

    # Optional: Dim brightness
    brightnessctl set 40%
else
    echo "[AC] Restoring performance settings"

    powerprofilesctl set performance
    auto-cpufreq --stop

    hyprctl keyword monitor "eDP-1, preferred, 0x0, 2, 120Hz"
    hyprctl keyword monitor "eDP-2, preferred, 0x900, 2, 120Hz"
    hyprctl keyword monitor "DP-2, preferred, 1440x0, 1, 120Hz"

    brightnessctl set 100%
fi
