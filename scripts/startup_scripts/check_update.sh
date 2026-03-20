#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

if [ "$VERSION" -lt "$REPO_VERSION" ] 2>/dev/null; then
    dunstify "New config update available!" \
        "Run update-conf\n(Current: $VERSION, Latest: $REPO_VERSION)" \
        -t 60000
fi
