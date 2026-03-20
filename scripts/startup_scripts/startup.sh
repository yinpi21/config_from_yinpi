#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

nohup firefox intra.forge.epita.fr > /dev/null 2>&1 &
nohup "$SCRIPTS/system/open_afs.sh" &

IDA=42
IDB=43

dunstify -r "$IDA" -t 0 "=== Config Startup ==="

# Applique le wallpaper
if [ -f "$SCRIPTS/wallpaper_scripts/safe_change_wallpaper.sh" ]; then
    sh "$SCRIPTS/wallpaper_scripts/safe_change_wallpaper.sh" > /dev/null 2>&1
fi

# Installation des paquets supplémentaires si absents
if [ ! -x "$HOME/.nix-profile/bin/bat" ]; then
    dunstify -r "$IDB" -t 0 "Installing additional packages..."
    PACKAGES="
    nixpkgs#autotiling
    nixpkgs#papirus-icon-theme
    nixpkgs#bat
    nixpkgs#adw-gtk3
    nixpkgs#pqiv
    nixpkgs#emacs
    nixpkgs#clang-tools
    nixpkgs#ripgrep
    nixpkgs#flameshot
    nixpkgs#zoxide
    "
    if nix profile install $PACKAGES --impure > /dev/null 2>&1; then
        dunstify -r "$IDB" -t 5000 "Packages installed [OK]"
    else
        dunstify -r "$IDB" -u critical "Packages installation [FAIL]"
    fi
fi

dunstify -r "$IDB" -t 0 "Reloading i3..."
if i3-msg restart > /dev/null 2>&1; then
    dunstify -r "$IDB" -t 3000 "Reloading i3 [OK]"
else
    dunstify -r "$IDB" -t 3000 "Reloading i3 [SKIP]"
fi

# Exécution des scripts utilisateur dans startup_scripts/
LOG_FILE="/tmp/startup_scripts.log"
echo "===== STARTUP LOG =====" > "$LOG_FILE"

if [ -d "$SCRIPTS/startup_scripts" ]; then
    for f in "$SCRIPTS/startup_scripts"/*; do
        [ -f "$f" ] || continue
        fname="${f##*/}"

        if [ "$fname" != "startup.sh" ] && [ "$fname" != "aklogger.sh" ] && [ "$fname" != "check_update.sh" ]; then
            chmod +x "$f"
            echo "===== LOG $fname =====" >> "$LOG_FILE"
            dunstify -r "$IDB" -t 0 "Execution : $fname"
            if ! "$f" >> "$LOG_FILE" 2>&1; then
                dunstify -u critical "Error executing : $fname" "See $LOG_FILE"
            fi
        fi
    done

    [ -f "$SCRIPTS/startup_scripts/aklogger.sh" ]    && sh "$SCRIPTS/startup_scripts/aklogger.sh"    > /dev/null 2>&1 &
    [ -f "$SCRIPTS/startup_scripts/check_update.sh" ] && sh "$SCRIPTS/startup_scripts/check_update.sh" > /dev/null 2>&1 &
fi

dunstify -r "$IDB" -t 5000 "All done! System ready."
sleep 5
dunstify -C "$IDA"
