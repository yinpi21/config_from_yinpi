[ -f "$HOME/.config/audio-devices.sh" ] && . "$HOME/.config/audio-devices.sh"

alias g='git'
# fixfn : rechargement manuel du pilote clavier ASUS (Fn keys)
# → Remplacé par un hook systemd-sleep automatique :
#   /usr/lib/systemd/system-sleep/asus-nb-wmi-reload
#   (recharge asus_nb_wmi à chaque réveil de suspension)
# alias fixfn='sudo modprobe -r asus_nb_wmi && sudo modprobe asus_nb_wmi'
alias airpods='
pw-metadata 0 default.configured.audio.sink "{\"name\":\"$AIRPODS_SINK\"}" >/dev/null;
for i in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$i" "$AIRPODS_SINK";
done
echo "🌸 Audio déplacé vers les AirPods.";
'
alias speaker='
pw-metadata 0 default.configured.audio.sink "{\"name\":\"$SPEAKER_SINK\"}" >/dev/null;
for i in $(pactl list short sink-inputs | cut -f1); do
    pactl move-sink-input "$i" "$SPEAKER_SINK";
done
echo "🔊 Audio déplacé vers les speakers.";
'

epimount() {
    # --- CONFIGURATION ---
    local USER="frederic.lin"
    local REALM="CRI.EPITA.FR"
    local SERVER="ssh.cri.epita.fr"
    local MOUNT_POINT="$HOME/AFS"
    local KEYTAB="$HOME/.private.keytab"
    local REMOTE_PATH="/afs/cri.epita.fr/user/${USER:0:1}/${USER:0:2}/$USER/u/"

    # --- 1. KERBEROS (Ticket) ---
    # Vérifie si un ticket valide existe déjà
    if ! klist -s; then
        echo -e "\033[1;33m🔑 Authentification Kerberos (via Keytab)...\033[0m"

        # Tentative silencieuse d'authentification
        kinit -f -k -t "$KEYTAB" "$USER@$REALM" 2>/dev/null

        # Si échec (ex: mot de passe changé)
        if [ $? -ne 0 ]; then
            echo -e "\033[1;31m❌ Le Keytab semble invalide (mot de passe expiré ?).\033[0m"
            read -p "Voulez-vous le régénérer maintenant ? (o/n) " -n 1 -r
            echo "" # Saut de ligne

            if [[ $REPLY =~ ^[Oo]$ ]]; then
                # Demande le MDP sans l'afficher
                read -s -p "Entrez votre mot de passe EPITA actuel : " PASS
                echo ""

                # Injection des commandes dans ktutil via printf
                # addent lit le mdp sur la ligne suivante dans le pipe
                printf "addent -password -p %s@%s -k 1 -e aes256-cts-hmac-sha1-96\n%s\nwkt %s\nquit" \
                       "$USER" "$REALM" "$PASS" "$KEYTAB" | ktutil

                if [ $? -eq 0 ]; then
                    echo -e "\033[1;32m✅ Keytab régénéré.\033[0m"
                    # Nouvelle tentative immédiate
                    kinit -f -k -t "$KEYTAB" "$USER@$REALM"
                    if [ $? -ne 0 ]; then
                        echo -e "\033[1;31m❌ Toujours impossible de s'authentifier. Vérifiez le mot de passe saisi.\033[0m"
                        return 1
                    fi
                else
                    echo -e "\033[1;31m❌ Erreur de génération du Keytab.\033[0m"
                    return 1
                fi
            else
                echo "Annulation."
                return 1
            fi
        fi
    fi

    # --- 2. MONTAGE SSHFS ---
    if [ ! -d "$MOUNT_POINT" ]; then
        mkdir -p "$MOUNT_POINT"
    fi

    # Démontage propre si déjà monté ou buggé
    if mount | grep -q "$MOUNT_POINT"; then
         fusermount -u "$MOUNT_POINT" 2>/dev/null
    fi

    echo -e "\033[1;34m📂 Connexion au serveur...\033[0m"
    sshfs -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3,idmap=user,GSSAPIAuthentication=yes "$SERVER:$REMOTE_PATH" "$MOUNT_POINT"

    if [ $? -eq 0 ]; then
        echo -e "\033[1;32m✅ Succès ! AFS monté.\033[0m"
    else
        echo -e "\033[1;31m❌ Échec du montage.\033[0m"
    fi
}

epiunmount() {
    fusermount -u "$HOME/AFS"
    echo -e "\033[1;32m🔒 AFS démonté.\033[0m"
}

# Fonction Git Root
gr() {
  local root
  root=$(git rev-parse --show-toplevel 2>/dev/null)
  if [ -n "$root" ]; then
    cd "$root"
  else
    echo "❌ Pas dans un dépôt Git."
  fi
}

# Fonction sécurisée pour basculer le dossier Extras
extoggle() {
    local IN_VAULT="$HOME/Obsidian/Extras"
    local IN_HOME="$HOME/Extras"

    # 1. Guard : Vérifie si le dossier existe aux deux endroits simultanément
    if [ -d "$IN_VAULT" ] && [ -d "$IN_HOME" ]; then
        echo "⚠️ Erreur : 'Extras' existe déjà dans le Vault ET dans le Home."
        echo "Action annulée pour éviter de créer un dossier imbriqué (~/Extras/Extras)."
        return 1
    fi

    # 2. Logique de bascule habituelle
    if [ -d "$IN_VAULT" ]; then
        mv "$IN_VAULT" "$HOME/" && echo "📤 Extras déplacé vers ~/"
    elif [ -d "$IN_HOME" ]; then
        mv "$IN_HOME" "$HOME/Obsidian/" && echo "📥 Extras remis dans ~/Obsidian/"
    else
        echo "❌ Erreur : Dossier 'Extras' introuvable dans ~/ ou ~/Obsidian/"
        return 1
    fi
}

# Ton alias court
alias ex='extoggle'
