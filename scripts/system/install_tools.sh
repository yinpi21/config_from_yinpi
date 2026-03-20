#!/bin/sh
command -v fzf >/dev/null 2>&1 || nix-env -f '<nixpkgs>' -iA fzf
command -v fd  >/dev/null 2>&1 || nix-env -f '<nixpkgs>' -iA fd
