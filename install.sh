#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────
# install.sh — Bootstrap de la config EPITA sur un nouveau PC NixOS
#
# Usage :
#   curl -Ls https://raw.githubusercontent.com/yinpi21/config_from_yinpi/main/install.sh | bash
# ─────────────────────────────────────────────────────────────────────
set -e

REPO_URL="https://github.com/yinpi21/config_from_yinpi.git"
DEST="$HOME/afs/config"

ok()   { echo -e "\033[1;32m✓\033[0m  $*"; }
info() { echo -e "\033[1;34m→\033[0m  $*"; }
err()  { echo -e "\033[1;31m✗\033[0m  $*"; exit 1; }

# ── Vérification PC école ─────────────────────────────────────────────
[ -d "$HOME/afs" ] || err "~/afs introuvable — es-tu bien sur le PC école ?"

# ── Clone ou update ───────────────────────────────────────────────────
if [ -d "$DEST/.git" ]; then
    current_remote=$(git -C "$DEST" remote get-url origin 2>/dev/null || echo "")
    if [ "$current_remote" != "$REPO_URL" ]; then
        info "Remote incorrect ($current_remote), correction..."
        git -C "$DEST" remote set-url origin "$REPO_URL"
        git -C "$DEST" fetch origin
        git -C "$DEST" reset --hard origin/main
    else
        info "Repo déjà présent, mise à jour..."
        git -C "$DEST" pull --ff-only
    fi
    ok "Repo à jour"
else
    info "Clonage du repo dans $DEST..."
    git clone --depth 1 "$REPO_URL" "$DEST"
    ok "Repo cloné"
fi

# ── Déploiement des symlinks ──────────────────────────────────────────
info "Déploiement de la config..."
bash "$DEST/setup-school.sh"
ok "Config déployée"

# ── Hook bashrc ───────────────────────────────────────────────────────
BASHRC_LINE='[ -f "$HOME/afs/.confs/bashrc" ] && source "$HOME/afs/.confs/bashrc"'
if ! grep -qF 'afs/.confs/bashrc' "$HOME/.bashrc" 2>/dev/null; then
    printf '\n# Config yinpi\n%s\n' "$BASHRC_LINE" >> "$HOME/.bashrc"
    ok "Ligne ajoutée dans ~/.bashrc"
else
    ok "~/.bashrc déjà configuré"
fi

# ── Résumé ────────────────────────────────────────────────────────────
echo ""
echo "────────────────────────────────────────────"
echo " Installation terminée !"
echo ""
echo " Prochaines étapes :"
echo "  1. source ~/.bashrc"
echo "  2. Choisir un wallpaper : bg"
echo "  3. Recharger i3 : \$mod+Shift+r"
echo "────────────────────────────────────────────"
