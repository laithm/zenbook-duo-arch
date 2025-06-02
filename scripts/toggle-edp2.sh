#!/bin/bash

# Get monitor ID 1 state
state=$(hyprctl monitors | awk '/Monitor ID 1/,/focused:/' | grep enabled | awk '{print $2}')

if [ "$state" = "true" ]; then
  hyprctl keyword monitor "eDP-2,disable"
else
  hyprctl keyword monitor "eDP-2,2880x1800@120,0x0,2"
fi

