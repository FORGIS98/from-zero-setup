#!/usr/bin/env bash
set -euo pipefail

if (( EUID == 0 )); then
  printf '%s\n' "Run this script as a regular user with sudo access." >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  printf '%s\n' "sudo is required to bootstrap this system." >&2
  exit 1
fi

REPO_URL="https://github.com/FORGIS98/from-zero-setup.git"
REPO_DIR="${HOME}/forgis98/from-zero-setup"

sudo pacman -Syu --noconfirm --needed git ansible base-devel

if [[ -d "${REPO_DIR}/.git" ]]; then
  git -C "${REPO_DIR}" pull --ff-only
else
  git clone "${REPO_URL}" "${REPO_DIR}"
fi

cd "${REPO_DIR}"
ansible-galaxy collection install -r requirements.yml
ansible-playbook -K site.yml
