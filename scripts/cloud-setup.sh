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
# Trust this project so .codex/config.toml (project-level overrides) is loaded.
# Parse the TOML instead of grepping so equivalent spellings are not duplicated.
PROJ="${CLAUDE_PROJECT_DIR:-$PWD}"
mkdir -p "$HOME/.codex"
python3 - "$PROJ" "$HOME/.codex/config.toml" <<'PY2'
import sys, os, tomllib
proj, cfg = sys.argv[1], sys.argv[2]
data = {}
if os.path.exists(cfg):
    try:
        with open(cfg, "rb") as f:
            data = tomllib.load(f)
    except Exception as e:
        print(f"skip trust: cannot parse {cfg}: {e}", file=sys.stderr)
        sys.exit(0)
if proj in data.get("projects", {}):
    sys.exit(0)
with open(cfg, "a") as f:
    f.write('\n[projects."%s"]\ntrust_level = "trusted"\n' % proj.replace("\\", "\\\\").replace('"', '\\"'))
PY2
codex login status || echo "Not logged in: run 'codex login --device-auth'"
