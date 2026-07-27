#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

fail() {
    printf 'Installer verification failed: %s\n' "$*" >&2
    exit 1
}

bash -n "$ROOT_DIR/install.sh"

grep -Fq 'REPO_OWNER="embedrapp"' "$ROOT_DIR/install.sh" \
    || fail "install.sh does not use the canonical GitHub owner"
grep -Fq 'REPO_NAME="downloads"' "$ROOT_DIR/install.sh" \
    || fail "install.sh does not use the canonical GitHub repository"
grep -Fq "\$Repo = 'embedrapp/downloads'" "$ROOT_DIR/install.ps1" \
    || fail "install.ps1 does not use the canonical GitHub repository"

if grep -En 'sinhaventures|embedr-release' "$ROOT_DIR/install.sh" "$ROOT_DIR/install.ps1"; then
    fail "legacy repository references remain"
fi

if grep -Ein 'xattr.*quarantine|com\.apple\.quarantine' "$ROOT_DIR/install.sh"; then
    fail "the macOS installer must not bypass Gatekeeper quarantine"
fi

if command -v pwsh >/dev/null 2>&1; then
    INSTALL_PS1="$ROOT_DIR/install.ps1" \
        pwsh -NoLogo -NoProfile -NonInteractive -Command \
        '$tokens = $null; $errors = $null; [System.Management.Automation.Language.Parser]::ParseFile($env:INSTALL_PS1, [ref]$tokens, [ref]$errors) > $null; if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }'
fi

"$ROOT_DIR/scripts/build-pages.sh"
cmp -s "$ROOT_DIR/install.sh" "$ROOT_DIR/dist/install.sh" \
    || fail "built install.sh differs from the repository source"
cmp -s "$ROOT_DIR/install.ps1" "$ROOT_DIR/dist/install.ps1" \
    || fail "built install.ps1 differs from the repository source"

printf 'Installer source and deployment output verified.\n'
