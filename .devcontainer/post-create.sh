#!/usr/bin/env bash
set -euo pipefail

# .venv is a container-local volume so it never collides with the host venv; make it writable.
sudo chown "$(id -u):$(id -g)" .venv

pipx install uv
uv sync --locked

echo "Preview: uv run zensical serve -a 0.0.0.0:27300  ->  http://localhost:27300/Redux_Documentation/"
