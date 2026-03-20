#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

LOCK_FILE="/tmp/note.lock"
NOTE_FILE="$AFS/.note.txt"

if [ ! -f "$LOCK_FILE" ] || ! (kill -s 0 $(cat "$LOCK_FILE") 2>/dev/null); then
    touch "$LOCK_FILE"
    echo "$PPID" > "$LOCK_FILE"
    emacs "$NOTE_FILE"
    rm "$LOCK_FILE"
fi
