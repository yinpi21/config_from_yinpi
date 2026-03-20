#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# setup-school.sh — Déploiement de la config sur le PC école (NixOS)
# Appelé par ~/.config/i3/config_epita via exec --no-startup-id
# ─────────────────────────────────────────────────────────────────────

REPO="$HOME/afs/config"
CONFS="$HOME/afs/.confs"

# ── Dossiers cibles ───────────────────────────────────────────────────
mkdir -p "$HOME/.emacs.d"
mkdir -p "$HOME/.config/i3"
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/emacs"
mkdir -p "$HOME/.config/picom"
mkdir -p "$HOME/.config/polybar"
mkdir -p "$HOME/.config/rofi"
mkdir -p "$HOME/.config/dunst"
mkdir -p "$HOME/.config/matugen/templates"
mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"
mkdir -p "$HOME/.config/qt5ct/colors"
mkdir -p "$HOME/.config/qt6ct/colors"
mkdir -p "$CONFS/config/clang-format"

# ── Dotfiles ──────────────────────────────────────────────────────────
rm -f "$HOME/.emacs" "$HOME/.gitignore"

ln -sf "$REPO/dotfiles/bashrc-ecole"  "$CONFS/bashrc"
ln -sf "$REPO/dotfiles/.gitconfig"    "$HOME/.gitconfig"
ln -sf "$REPO/dotfiles/.vimrc"        "$CONFS/vimrc"
ln -sf "$REPO/dotfiles/.bash_aliases" "$HOME/.bash_aliases"
ln -sf "$REPO/dotfiles/gdbinit"       "$CONFS/gdbinit"
cp    "$REPO/Optimot/.XCompose"        "$HOME/.XCompose"

# ── Emacs ─────────────────────────────────────────────────────────────
ln -sf "$REPO/emacs/init.el" "$HOME/.emacs.d/init.el"

# ── i3 ────────────────────────────────────────────────────────────────
ln -sf "$REPO/config/i3/config_epita" "$HOME/.config/i3/config"

# ── Alacritty ─────────────────────────────────────────────────────────
ln -sf "$REPO/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"

# ── Matugen ───────────────────────────────────────────────────────────
# config.toml et templates : symlinks (matugen lit, n'écrit pas dedans)
ln -sf "$REPO/config/matugen/config.toml" "$HOME/.config/matugen/config.toml"
for f in "$REPO/config/matugen/templates/"*; do
    ln -sf "$f" "$HOME/.config/matugen/templates/$(basename "$f")"
done
# Les outputs matugen (colors.*) sont générés à runtime dans ~/.config/
# → pas de symlink, matugen écrit directement

# ── Picom ─────────────────────────────────────────────────────────────
ln -sf "$REPO/config/picom/picom.conf" "$HOME/.config/picom/picom.conf"

# ── Polybar ───────────────────────────────────────────────────────────
# config.ini : symlink (statique)
# colors.ini : généré par matugen → pas de symlink
ln -sf "$REPO/config/polybar/config.ini" "$HOME/.config/polybar/config.ini"

# ── Rofi ──────────────────────────────────────────────────────────────
# Thèmes statiques : symlinks
# colors.rasi : généré par matugen → pas de symlink
for f in "$REPO/config/rofi/"*.rasi; do
    fname="$(basename "$f")"
    [ "$fname" = "colors.rasi" ] && continue
    ln -sf "$f" "$HOME/.config/rofi/$fname"
done

# ── Dunst ─────────────────────────────────────────────────────────────
# dunstrc est entièrement géré par matugen (template → ~/.config/dunst/dunstrc)
# On copie le template comme fallback au premier boot (matugen l'écrasera)
if [ ! -f "$HOME/.config/dunst/dunstrc" ]; then
    cp "$REPO/config/matugen/templates/dunstrc" "$HOME/.config/dunst/dunstrc"
fi

# ── Clang-format ──────────────────────────────────────────────────────
CLANG_DST="$CONFS/config/clang-format"
CLANG_SRC="$REPO/config/clang-format"

ln -sf "$CLANG_SRC/clang-format-c-epita-ing1-2025-2026"   "$CLANG_DST/clang-format-c-epita-ing1-2025-2026"
ln -sf "$CLANG_SRC/clang-format-cxx-epita-ing1-2025-2026" "$CLANG_DST/clang-format-cxx-epita-ing1-2025-2026"
ln -sf "clang-format-c-epita-ing1-2025-2026"               "$CLANG_DST/clang-format-c-current"
ln -sf "clang-format-cxx-epita-ing1-2025-2026"             "$CLANG_DST/clang-format-cxx-current"

# ── Scripts ───────────────────────────────────────────────────────────
# rm au cas où c'est un dossier réel (remplacé par un symlink)
rm -rf "$CONFS/scripts"
ln -sf "$REPO/scripts" "$CONFS/scripts"
chmod +x "$REPO/scripts"/{system,menus,wallpaper_scripts,startup_scripts,flashbang}/*.sh
