#!/usr/bin/env bash
# Cloud environment setup script: installs the Codex CLI.
set -euo pipefail
command -v codex >/dev/null 2>&1 || npm i -g @openai/codex
codex --version
# Optional: restore a saved login. CODEX_AUTH_JSON is an environment secret
# holding the contents of ~/.codex/auth.json (see SETUP.md for the risks).
if [ -n "${CODEX_AUTH_JSON:-}" ] && [ ! -f "$HOME/.codex/auth.json" ]; then
  mkdir -p "$HOME/.codex"
  umask 077
  printf '%s' "$CODEX_AUTH_JSON" > "$HOME/.codex/auth.json"
fi
codex login status || echo "Not logged in: run 'codex login --device-auth'"
