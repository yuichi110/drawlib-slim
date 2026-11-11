#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Building PNI501 Diagnostic Report HTML (pni501_src/ -> docs/pni501/) ==="
"$SCRIPT_DIR/build_html.sh"

echo "=== Building PNI501 Diagnostic Report PDF (pni501_src/ -> docs/pni501/pni501.pdf) ==="
"$SCRIPT_DIR/build_pdf.sh"

echo "Build completed successfully!"
