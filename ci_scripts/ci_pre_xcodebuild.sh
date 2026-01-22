#!/bin/zsh
set -euo pipefail
set -x

cd "${CI_PRIMARY_REPOSITORY_PATH:-$PWD}"

echo "==> Installing mise"
curl -fsSL https://mise.run | sh

export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

echo "==> Mise version"
mise --version

echo "==> Installing Tuist"
TUIST_VERSION="${TUIST_VERSION:-4.128.2}"
mise install "tuist@${TUIST_VERSION}"
mise use -g "tuist@${TUIST_VERSION}"

echo "==> Tuist version"
tuist version

echo "==> Installing external dependencies (SPM via Tuist)"
tuist install

echo "==> Generating Xcode workspace"
tuist generate --no-open

echo "==> Done"
