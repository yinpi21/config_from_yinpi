#!/usr/bin/env bash

ln -sf "$HOME/afs/config/Optimot/.XCompose" "$HOME/.XCompose"

export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim
export XMODIFIERS="@im=none"

nix shell nixpkgs#xorg.xkbcomp nixpkgs#xkeyboard_config --command bash -c "
    export XKB_CONFIG_ROOT=\$(nix build nixpkgs#xkeyboard_config --no-link --print-out-paths)/etc/X11/xkb
    xkbcomp -I\$XKB_CONFIG_ROOT -w 0 \$HOME/afs/config/Optimot/Optimot.xkb \$DISPLAY
"
