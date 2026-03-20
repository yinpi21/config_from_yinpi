#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

theme="$CONFIG/rofi/power_menu.rasi"
uptime="$(uptime -p | sed -e 's/up //g')"
host=" $USER"

shutdown='  Shutdown'
reboot='  Reboot'
lock='  Lock'
logout='  Logout'
yes='  Yes'
no='  No'

rofi_cmd() {
    rofi -dmenu -dpi 1 \
        -p "$host" \
        -theme-str "textbox-uptime { str: \"$uptime\"; }" \
        -theme "$theme"
}

confirm_cmd() {
    rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 400px;}' \
        -theme-str 'mainbox {children: [ "message", "listview" ];}' \
        -theme-str 'listview {columns: 2; lines: 1;}' \
        -theme-str 'element-text {horizontal-align: 0.5;}' \
        -theme-str 'textbox {horizontal-align: 0.5;}' \
        -dmenu \
        -p 'Confirmation' \
        -mesg 'Are you Sure?' \
        -theme "$theme" \
        -dpi 1
}

confirm_exit() {
    echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
    echo -e "$lock\n$logout\n$reboot\n$shutdown" | rofi_cmd
}

run_cmd() {
    selected="$(confirm_exit)"
    if [ "$selected" = "$yes" ]; then
        case "$1" in
            --shutdown) systemctl poweroff ;;
            --reboot)   systemctl reboot   ;;
            --logout)   i3-msg exit        ;;
        esac
    fi
}

chosen="$(run_rofi)"
case "$chosen" in
    "$shutdown") run_cmd --shutdown ;;
    "$reboot")   run_cmd --reboot   ;;
    "$lock")     sh "$SCRIPTS/system/i3lock.sh" ;;
    "$logout")   run_cmd --logout   ;;
esac
