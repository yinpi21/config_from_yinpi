#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

LOCK_FILE="/tmp/flashbang.lock"

[ -f "$LOCK_FILE" ] && exit 0

touch "$LOCK_FILE"

pqiv "$SCRIPTS/flashbang/fb.gif" --transparent-background=true --window-title="fbgif" --scale-images-up -i &
sleep 3.6
pkill pqiv

xrandr --output DP-1  --brightness 40 > /dev/null 2>&1
xrandr --output HDMI-1 --brightness 40 > /dev/null 2>&1

b=40
while [ "$(echo "$b 1" | awk '{print ($1 > $2)}')" = 1 ]; do
    xrandr --output DP-1  --brightness "$b" > /dev/null 2>&1
    xrandr --output HDMI-1 --brightness "$b" > /dev/null 2>&1
    b=$(echo "$b * 0.99" | bc)
done

xrandr --output DP-1  --brightness 1 > /dev/null 2>&1
xrandr --output HDMI-1 --brightness 1 > /dev/null 2>&1

rm "$LOCK_FILE"
