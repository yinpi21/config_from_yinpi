#!/bin/sh

source "$HOME/afs/config/scripts/globals.sh"

# Vérification quota AFS
used=$(fs quota "$HOME/afs" 2>/dev/null | cut -d'%' -f1 | tr -d ' ')
if [ "$used" -ge 95 ]; then
    printf "${BLUE}::${NC} %-42s[${RED}KO${NC}]\n" "Checking AFS quota"
    printf "${RED}Error: AFS quota at ${used}%%. Run 'clean-afs' first.${NC}\n"
    exit 1
fi

{
    echo -e "${RED}==== CONFIG UPDATE ====${NC}"
    echo -e "${BLUE}:: Current Version : $VERSION${NC}"
    echo -e "${BLUE}:: Latest Version  : $REPO_VERSION${NC}"
    echo -ne "${BLUE}::${NC} Updating config ($BRANCH)...  "

    err=$(mktemp)

    (
        set -e
        cd "$REPO"
        git pull --ff-only origin "$BRANCH"
        bash "$REPO/setup-school.sh"
        # Invalide le cache de version pour la prochaine vérification
        rm -f "$REPO_VERSION_FILE"
    ) >"$err" 2>&1 &

    pid=$!
    i=0
    while kill -0 $pid 2>/dev/null; do
        case $((i % 4)) in
            0) printf "\b-" ;; 1) printf "\b\\" ;;
            2) printf "\b|" ;; 3) printf "\b/" ;;
        esac
        i=$((i + 1))
        sleep 0.1
    done

    wait $pid
    EXIT_CODE=$?

    if [ $EXIT_CODE -eq 0 ]; then
        rm -f "$err"
        echo -e "\b[${GREEN}OK${NC}]"
        i3-msg restart >/dev/null 2>&1
    else
        echo -e "\b[${RED}KO${NC}]"
        cat "$err"
        rm -f "$err"
        exit 1
    fi
}
