#!/bin/bash
# SlouchGuard installer
# Usage: curl -fsSL https://raw.githubusercontent.com/KaranSud/slouchguard/main/scripts/install.sh | bash
set -euo pipefail

REPO="KaranSud/slouchguard"
APP_PATH="/Applications/SlouchGuard.app"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Fetching the latest SlouchGuard release..."
URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -o '"browser_download_url": *"[^"]*SlouchGuard\.zip"' \
    | head -1 | sed 's/.*"\(https[^"]*\)"/\1/')

if [ -z "$URL" ]; then
    echo "Could not find a release download. Check https://github.com/$REPO/releases" >&2
    exit 1
fi

curl -fsSL -o "$TMP_DIR/SlouchGuard.zip" "$URL"

# Replace any existing install cleanly.
if pgrep -x SlouchGuard >/dev/null 2>&1; then
    pkill -x SlouchGuard || true
    sleep 1
fi
rm -rf "$APP_PATH"
ditto -x -k "$TMP_DIR/SlouchGuard.zip" /Applications/

# The app is ad-hoc signed (no paid Apple Developer cert), so clear the
# Gatekeeper quarantine flag that downloads pick up.
xattr -dr com.apple.quarantine "$APP_PATH" 2>/dev/null || true

open "$APP_PATH"

echo ""
echo "SlouchGuard is installed and running. Look for the icon near your clock."
echo "First run: allow Motion & Fitness and notifications, put in your AirPods,"
echo "then click the menu bar icon and hit Calibrate while sitting tall."
