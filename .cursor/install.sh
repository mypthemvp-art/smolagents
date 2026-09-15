#!/usr/bin/env bash
# Idempotent development bootstrap for smolagents in Cursor Cloud Agents.
# Installs the package in editable mode with the full dev extras so that
# `make quality`, `make test`, and the `smolagent`/`webagent` CLIs work
# out of the box in any fresh shell (no virtualenv activation required).
set -euo pipefail

cd "$(dirname "$0")/.."

# Some tools and tests invoke `python` (not `python3`); ensure it resolves
# to the system interpreter on the default PATH.
sudo ln -sf /usr/bin/python3 /usr/local/bin/python

# Install uv (fast Python package manager) system-wide if it is missing.
if ! command -v uv >/dev/null 2>&1; then
  sudo python3 -m pip install --quiet uv
fi

# Editable install of smolagents with all dev dependencies into the system
# interpreter. uv reuses its global cache, so re-runs are fast and idempotent.
sudo "$(command -v uv)" pip install --system -e ".[dev]"

python3 -c "import smolagents; print(f'smolagents {smolagents.__version__} ready')"
