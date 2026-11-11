#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

export UV_DEFAULT_INDEX="${UV_DEFAULT_INDEX:-https://pypi.org/simple}"

echo "=== [1/5] Building Slim 4 User Guide (user_guide_src/ -> docs/user_guide/) ==="
./user_guide_src/build.sh

echo "=== [2/5] Building Slim 4 API Reference Catalog (api_src/ -> docs/api/) ==="
./api_src/build.sh

echo "=== [3/5] Building Slim 4 Internal Architecture Guide (architecture_src/ -> docs/architecture/) ==="
./architecture_src/build.sh

echo "=== [4/5] Building PNI501 Diagnostic Report (pni501_src/ -> docs/pni501/) ==="
./pni501_src/build.sh

printf 'slim.drawlib.com' > docs/CNAME
touch docs/.nojekyll

echo "=== [5/5] Regenerating Unified Root Sitemap (docs/sitemap.xml) ==="
python3 - <<'PY'
from pathlib import Path

base_url = "https://slim.drawlib.com"
docs_dir = Path("docs")

urls = [f"{base_url}/"]
for portal in ("user_guide", "api", "architecture", "pni501"):
    portal_dir = docs_dir / portal
    if not portal_dir.exists():
        continue
    for html_file in sorted(portal_dir.rglob("*.html")):
        rel = html_file.relative_to(docs_dir).as_posix()
        if rel.endswith("/index.html"):
            url = f"{base_url}/{rel[:-len('index.html')]}"
        else:
            url = f"{base_url}/{rel}"
        if url not in urls:
            urls.append(url)

lines = [
    '<?xml version="1.0" encoding="UTF-8"?>',
    '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">',
]
for u in urls:
    lines.append(f"  <url><loc>{u}</loc></url>")
lines.append("</urlset>")
(docs_dir / "sitemap.xml").write_text("\n".join(lines) + "\n", encoding="utf-8")
print(f"Generated docs/sitemap.xml with {len(urls)} URLs.")
PY

echo "All 4 portals and root sitemap built successfully!"
