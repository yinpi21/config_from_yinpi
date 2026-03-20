# BRANCH
BRANCH="main"

# COLORS
BLACK="\033[30m"
WHITE="\033[97m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
GRAY="\033[90m"
LIGHT_GRAY="\033[37m"
LIGHT_RED="\033[91m"
LIGHT_GREEN="\033[92m"
LIGHT_YELLOW="\033[93m"
LIGHT_BLUE="\033[94m"
LIGHT_MAGENTA="\033[95m"
LIGHT_CYAN="\033[96m"
NC="\033[0m"

# CONFIG DIRECTORIES
AFS="$HOME/afs"
CONFS="$AFS/.confs"
REPO="$AFS/config"
CONFIG="$REPO/config"
SCRIPTS="$REPO/scripts"
WALLPAPERS="$CONFS/wallpapers"

# REPO (remplacer par l'URL de ton repo)
REPO_CONFIG="https://github.com/yinpi21/config_from_yinpi.git"
RAW_REPO_CONFIG="https://raw.githubusercontent.com/yinpi21/config_from_yinpi/refs/heads/$BRANCH/"

# VERSION
VERSION_FILE="$REPO/version"
VERSION=$(cat "$VERSION_FILE" 2>/dev/null || echo 0)

REPO_VERSION_FILE="/tmp/config_repo_version"
if ! [ -f "$REPO_VERSION_FILE" ]; then
    curl -Ls "${RAW_REPO_CONFIG}version" > "$REPO_VERSION_FILE" 2>/dev/null
fi
REPO_VERSION=$(cat "$REPO_VERSION_FILE" 2>/dev/null || echo 0)
