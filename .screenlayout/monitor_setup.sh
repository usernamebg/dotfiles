#!/bin/sh

xrandr --output DisplayPort-0 --off \
  --output DisplayPort-1 --primary --mode 2560x1440 --rate 74.97 --pos 1440x439 --rotate normal \
  --output DisplayPort-2 --mode 2560x1440 --rate 74.97 --pos 0x0 --rotate left \
  --output HDMI-A-0 --off
