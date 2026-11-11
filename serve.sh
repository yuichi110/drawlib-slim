#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export UV_DEFAULT_INDEX="${UV_DEFAULT_INDEX:-https://pypi.org/simple}"

HAS_CHECK=0
for arg in "$@"; do
    if [ "$arg" = "--check" ]; then
        HAS_CHECK=1
        break
    fi
done

if [ "$HAS_CHECK" -eq 1 ]; then
    uvx --default-index "$UV_DEFAULT_INDEX" drawlib@0.3.9 serve docs/ "$@"
else
    uvx --default-index "$UV_DEFAULT_INDEX" drawlib@0.3.9 serve docs/ --skip-check "$@"
fi
