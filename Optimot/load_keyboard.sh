#!/usr/bin/env bash

ln -sf /home/frederic.lin/afs/config/Optimot/.XCompose ~/.XCompose

# 1. Configurer les variables pour XCompose
 export GTK_IM_MODULE=xim
 export QT_IM_MODULE=xim
 export XMODIFIERS="@im=none"

# 2. Charger le layout XKB via Nix
# On utilise 'nix shell' pour garantir que les outils sont là sans install root
 nix shell nixpkgs#xorg.xkbcomp nixpkgs#xkeyboard_config --command bash -c "
  export XKB_CONFIG_ROOT=\$(nix build nixpkgs#xkeyboard_config --no-link --print-out-paths)/etc/X11/xkb;
  xkbcomp -I\$XKB_CONFIG_ROOT -w 0 ~/afs/config/Optimot/Optimot.xkb \$DISPLAY
"
