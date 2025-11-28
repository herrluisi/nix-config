#! /bin/bash

# Out HDMI: DP-4
# Out Laptop screen: eDP-1
# Out Station over USB-C:
#   - DP-11: Ancor Communications Inc BE24A G1LMQS040301
#   - DP-9: Hewlett-Packard HP 23xig 3CM431057J


# Home:
#   - eDP-1: 2560x1600 (pos 3840 0)
#   - DP-11: 1920x1080 (pos 1920 0)
#   - DP-9: 1920x1080 (pos 0 0)


if [ "$1" = "home" ]; then
  echo "enter home station mode"
  swaymsg output eDP-1 pos 3840 0 res 2560x1600 scale 1.5 && swaymsg output DP-11 pos 1920 0 res 1920x1080 scale 1 && swaymsg output DP-9 pos 0 0 res 1920x1080 scale 1
  echo "entered home station mode"

elif [ "$1" = "mirror" ]; then
  echo "entering mirror mode"
  swaymsg output * pos 0 0 res 1920x1080 scale 1
  echo "mirror mode entered"
fi

