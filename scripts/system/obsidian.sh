#!/bin/sh
[ ! -d "$HOME/Obsidian" ] && git clone git@github.com:yinpi21/Obsidian.git "$HOME/Obsidian"
NIXPKGS_ALLOW_UNFREE=1 nix-shell -p obsidian --run "obsidian $HOME/Obsidian"
