#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER_BASE="${EMBEDR_INSTALLER_BASE_URL:-https://get.embedr.app}"
INSTALLER_BASE="${INSTALLER_BASE%/}"
MAX_ATTEMPTS="${MAX_ATTEMPTS:-30}"
RETRY_SECONDS="${RETRY_SECONDS:-20}"
TEMP_DIR="$(mktemp -d)"

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

for attempt in $(seq 1 "$MAX_ATTEMPTS"); do
    if curl -fsSL --connect-timeout 10 --max-time 30 \
        "$INSTALLER_BASE/install.sh" -o "$TEMP_DIR/install.sh" \
        && curl -fsSL --connect-timeout 10 --max-time 30 \
            "$INSTALLER_BASE/install.ps1" -o "$TEMP_DIR/install.ps1" \
        && cmp -s "$ROOT_DIR/install.sh" "$TEMP_DIR/install.sh" \
        && cmp -s "$ROOT_DIR/install.ps1" "$TEMP_DIR/install.ps1"; then
        printf 'Live installer scripts match the repository source.\n'
        exit 0
    fi

    if [ "$attempt" -lt "$MAX_ATTEMPTS" ]; then
        printf 'Live installer deployment is not current (attempt %s/%s); retrying in %ss.\n' \
            "$attempt" "$MAX_ATTEMPTS" "$RETRY_SECONDS"
        sleep "$RETRY_SECONDS"
    fi
done

printf 'Live installer deployment does not match the repository source after %s attempts.\n' \
    "$MAX_ATTEMPTS" >&2
exit 1
