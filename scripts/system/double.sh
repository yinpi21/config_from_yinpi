#!/bin/sh

# Get the ID of the current focused window
ID=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

# Get the PID of the window
PID=$(xprop -id "$ID" _NET_WM_PID | awk '{print $3}')

# Get the child PID (the shell running inside the terminal)
CHILD_PID=$(pgrep -P "$PID")

# Get the CWD
if [ -n "$CHILD_PID" ]; then
    CWD=$(readlink -f "/proc/$CHILD_PID/cwd")
else
    CWD=$(readlink -f "/proc/$PID/cwd")
fi

# Open a new terminal in the same directory
alacritty --working-directory "$CWD"
