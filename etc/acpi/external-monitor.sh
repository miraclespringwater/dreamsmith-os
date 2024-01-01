#!/bin/sh
export DISPLAY=:0
export XAUTHORITY=/home/dream/.Xauthority

if [ "$1" = "dock" ]; then
    logger "ACPI event: Turning on DP2-2-1. This will take 10 seconds or so..."
    while (xrandr | grep "DP2-2-1 disconnected"); do
        sleep 1
    done
    sleep 1
    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2-1 --mode 1920x1080 --pos 0x0 --rotate normal
else
    logger "ACPI event: Turning off DP2-2-1"
    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-2-1 --off
fi
