# 6. Deep Dive: Security, Supply Chain & API Surface

Slim Framework `v4.15.3` achieves a perfect **100/100 (Grade S)** in `security_vulnerability_audit` (`security` axis: **100/100**; `dependencies` axis: **96/100**). Trivy `0.69.3` supply-chain, secret, and IaC scanning combined with deterministic PHP AST static analysis confirms **zero CVEs across all 93 locked Composer packages** (`7` core runtime + `86` development packages), **zero hardcoded or committed secrets**, **zero container misconfigurations**, and **zero CWE-classified dangerous code sinks** across all `72` PHP source files (`3,149` LOC).

```drawlib align=center code=fold file=supply_chain_cve_comparison.png caption="Figure 6.1 — Trivy Vulnerability Isolation Across Slim Core Runtime (7 Pkgs), Composer Lockfile (93 Pkgs), and Ephemeral Test Harness OS"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=68, dpi=150)

# Left: Grouped BarChart comparing Application CVEs vs Non-Shipped Harness OS
chart = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=["CRITICAL", "HIGH", "MEDIUM", "LOW"],
    width=88.0,
    height=46.5,
    title="Trivy SCA Vulnerability Counts by Artifact Scope & Severity",
    title_style=Styles.BlackBold.patch(text_size=11.8),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.76,
    bar_r=0.8,
    axis_text_style=Styles.DarkBold.patch(text_size=10.0),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=9.5),
    value_format="{:.0f}",
)
chart.add_series("Core (7 pkgs)", [0, 0, 0, 0], style=Styles.PrimaryFlat)
chart.add_series("Lockfile (93 pkgs)", [0, 0, 0, 0], style=Styles.SuccessFlat)
chart.add_series("Shipped OS (None)", [0, 0, 0, 0], style=Styles.SecondaryNeutral)
chart.configure_y_axis(min_value=0.0, max_value=10.0, tick_step=2.0, label="Application & Shipped OS CVEs")
chart.draw(xy=(5.5, 15.0))
chart.draw_legend(
    xy=(7.0, 8.0),
    text_style=Styles.DarkBold.patch(text_size=9.6),
    orientation="horizontal",
    item_gap=2.8,
)

# Right: Boundary Isolation Summary Panel
panel = Panel(
    "Blast-Radius Isolation",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.package,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
panel.draw((96.5, 6.0), width=44.0, height=56.5)
r_xy, r_w, r_h = panel.get_content_box(
    (96.5, 6.0), width=44.0, height=56.5, padding=(2.5, 2.5)
)

kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=15.0),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.35,
    spacing=2.4,
)
kpis.add("0", "Core Runtime CVEs", "7 PSR & FastRoute pkgs")
kpis.add(
    "0",
    "Dev Lockfile CVEs",
    "93 total locked pkgs",
    accent_style=Styles.SuccessFlat,
    metric_style=Styles.SuccessBold.patch(text_size=15.0),
)
kpis.add(
    "CI-Only",
    "Test Harness OS",
    "3,114 Debian CI-only",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.DarkBold.patch(text_size=11.5),
)
kpis.draw(xy=r_xy, width=r_w, height=r_h, columns=1)

save()
```

---

## 6.1 Composer Supply-Chain Hygiene & Governance Baseline

Slim's `composer.json` and `composer.lock` architecture minimizes downstream supply-chain exposure by keeping the `composer require slim/slim` dependency tree limited strictly to **6 PHP-FIG PSR interface packages** plus `nikic/fast-route ^1.3`, while isolating all 6 PSR-7 concrete test providers (`slim/psr7`, `nyholm/psr7`, `guzzlehttp/psr7`, `laminas/laminas-diactoros`, `httpsoft/http-message`, `slim/http`) and static analyzers under `require-dev`.

| Supply-Chain & Security Gate | Measured Value | Verdict | Architectural & Compliance Evidence |
| :--- | :-: | :-: | :--- |
| **Deterministic Lockfile (`has_lockfile`)** | `True` (`composer.lock`) | **`PASS`** | Locks exact commit SHA and version metadata across all `93` runtime and dev packages. |
| **Core Runtime Dependencies (`dependencies_count`)** | **`7` packages** | **`PASS`** | `6` official `psr/*` contract packages + `nikic/fast-route: ^1.3`. |
| **Unpinned Specifiers (`unpinned_dependencies_count`)** | **`0`** | **`PASS`** | Every dependency uses explicit SemVer caret (`^`) or dual-major union (`^1.0 \|\| ^2.0`) constraints. |
| **Security Disclosure Policy (`has_security_policy`)** | `True` (`SECURITY.md`) | **`PASS`** | Documents responsible vulnerability reporting via GitHub Security Advisories / Tidelift. |
| **Committed / Hardcoded Secrets** | **`0` files / `0` literals** | **`PASS`** | Clean across both Trivy secret scanning (`secrets=[]`) and PHP AST literal inspection. |
| **Container IaC Misconfigurations** | **`0`** | **`PASS`** | `misconfigurations=[]` on `.pni/dockerfiles/Dockerfile` (with batch waiver `DS-0026`). |
| **AST Dangerous Sinks (`ast_dangerous_sinks_count`)** | **`0`** | **`PASS`** | Zero `eval`, `exec`, `shell_exec`, `system`, `passthru`, `unserialize`, or SQLi/XSS sinks. |
| **Standalone HTTP Endpoints (`api_endpoints_count`)** | **`0`** | **`PASS`** | Reusable `library` archetype; binds zero network sockets unless instantiated by consumer app. |

### Separation of Harness OS Packages vs. Library Dependencies

Trivy (`ghcr.io/aquasecurity/trivy:0.69.3`) scanned both the repository filesystem (`composer.lock`) and the resolved container image built from `.pni/dockerfiles/Dockerfile` (`php:8.2-cli-bookworm`):

| Vulnerability Boundary | CRITICAL | HIGH | MEDIUM | LOW | Total | Scoring & Consumer Impact |
| :--- | :-: | :-: | :-: | :-: | :-: | :--- |
| **1. Core Runtime Dependencies (`7` Composer pkgs)** | **`0`** | **`0`** | **`0`** | **`0`** | **`0`** | **Zero Impact**: `psr/*` and `nikic/fast-route` have `0` known advisories. |
| **2. Dev / Test Lockfile (`86` Composer pkgs)** | **`0`** | **`0`** | **`0`** | **`0`** | **`0`** | **Zero Impact**: All `93` locked Composer packages in `composer.lock` are 100% CVE-free. |
| **3. Shipped Project Container OS (`os_vuln_counts`)** | **`0`** | **`0`** | **`0`** | **`0`** | **`0`** | **Zero Impact**: Slim is a pure PHP library (`has_dockerfile=false`) and ships no container image. |
| **4. Ephemeral Test Harness OS (`harness_os_vuln_counts`)** | `6` | `265` | `1,698` | `1,128` | `3,114` | **Non-Shipped Harness Only**: Debian Bookworm system packages (`perl`, `openssl`, `curl`, `linux-libc-dev`) inside `.pni/dockerfiles/Dockerfile` used solely for offline `phpunit` execution; properly isolated from library scoring. |

---

## 6.2 SAST Security Verification & Built-In PSR-7 / Error / BodyParsing Defenses

```drawlib align=center code=fold file=security_sast_and_defenses.png caption="Figure 6.2 — PHP AST SAST Security Scorecard & Built-In Defensive Subsystems (PSR-7, HtmlErrorRenderer, BodyParsingMiddleware)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=68, dpi=150)

# Left Panel: SAST & Supply-Chain Security KPIs
left_panel = Panel(
    "SAST & Supply-Chain Gates",
    "100 / 100 (Grade S)",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Muted.patch(text_size=9.8),
    icon=phosphor.shield_check,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
left_panel.draw((5.0, 5.5), width=62.0, height=58.5)
l_xy, l_w, l_h = left_panel.get_content_box(
    (5.0, 5.5), width=62.0, height=58.5, padding=(2.8, 2.8)
)

sast_kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="top_bar",
    metric_layout="top_stack",
    spacing=2.6,
)
sast_kpis.add("0 Sinks", "PHP AST SAST", "No eval/shell/unserialize")
sast_kpis.add("0 Secrets", "Secret Hygiene", "Trivy + AST verified")
sast_kpis.add(
    "0 App CVEs",
    "93 Locked Pkgs",
    "Core & dev 100% clean",
    accent_style=Styles.SuccessFlat,
    metric_style=Styles.SuccessBold.patch(text_size=14.0),
)
sast_kpis.add(
    "0 Superglobals",
    "Core Routing / MW",
    "Immutable PSR-7 state",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.SecondaryBold.patch(text_size=14.0),
)
sast_kpis.draw(xy=l_xy, width=l_w, height=l_h, columns=2)

# Right Panel: Built-In Defensive Subsystems CardList
right_panel = Panel(
    "Built-In Security Defenses",
    "100% Stmt Cov.",
    style=Styles.PrimaryNeutral,
    header_style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=11.0),
    description_style=Styles.White.patch(text_size=9.8),
    icon=phosphor.lock_key,
    icon_style=Styles.WhiteBold,
    header_variant="filled",
    header_height=8.5,
)
right_panel.draw((70.5, 5.5), width=70.5, height=58.5)
r_xy, r_w, r_h = right_panel.get_content_box(
    (70.5, 5.5), width=70.5, height=58.5, padding=(2.8, 2.5)
)

sec_cards = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Muted.patch(text_size=9.5),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.2,
)
sec_cards.add(
    "HtmlErrorRenderer & XmlErrorRenderer",
    "Escapes exception text via htmlentities(ENT_HTML5)\n& wraps XML error payloads in safe CDATA sections",
    icon=phosphor.code,
    badge_style=Styles.PrimaryFlat,
    icon_style=Styles.WhiteBold,
)
sec_cards.add(
    "BodyParsingMiddleware XXE Protection",
    "Disables external XML entity loading on PHP < 8.0\n& isolates libxml internal errors during parsing",
    icon=phosphor.file_lock,
)
sec_cards.add(
    "PSR-7 Immutability & MethodOverride",
    "Zero superglobal (_GET/_POST) reads in routing;\nMethodOverride validates allowed HTTP verbs",
    icon=phosphor.arrows_left_right,
)
sec_cards.draw(xy=r_xy, width=r_w, height=r_h)

save()
```

### Architectural Security Analysis of Core Subsystems

1. **Context-Appropriate Output Encoding in `Error/Renderers/*` (`XSS` / `Injection` Prevention)**:
   - `Slim\Error\Renderers\HtmlErrorRenderer` (`Slim/Error/Renderers/HtmlErrorRenderer.php`, `100.0%` PCOV coverage) escapes every exception class name, message, file path, and stack trace via `htmlentities(..., ENT_COMPAT | ENT_HTML5, 'utf-8')` before interpolating into HTML error templates, and gates stack trace disclosure behind the explicit `$displayErrorDetails` boolean flag (default `false`).
   - `Slim\Error\Renderers\XmlErrorRenderer` wraps exception messages inside `<![CDATA[ ... ]]>` blocks while escaping embedded `]]>` sequences, and `JsonErrorRenderer` serializes structured arrays via `json_encode(..., JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES)`.
2. **XML External Entity (`XXE`) Hardening in `BodyParsingMiddleware`**:
   - `Slim\Middleware\BodyParsingMiddleware` (`Slim/Middleware/BodyParsingMiddleware.php`, `100.0%` PCOV coverage) guards XML request body parsing (`application/xml`, `text/xml`) by calling `libxml_disable_entity_loader(true)` on PHP `< 8.0` (where external entity loading is not disabled by default) and `libxml_use_internal_errors(true)` with `libxml_clear_errors()` before and after `simplexml_load_string($input)`, preventing XXE file disclosure and warning leakage.
3. **Immutable PSR-7 Request State & Superglobal Isolation**:
   - Core routing and middleware classes never read `$_GET`, `$_POST`, `$_SERVER`, or `$_COOKIE` directly. Superglobals are read exclusively once inside `ServerRequestCreatorFactory` when synthesizing the initial PSR-7 `ServerRequestInterface`.
   - `RoutingMiddleware` attaches matched `RouteContext` state (`__route__`, `__routeParser__`, `__routingResults__`, `__basePath__`) via immutable `$request->withAttribute(...)` clones, and `ResponseEmitter::emitHeaders()` preserves multiple `Set-Cookie` headers without overwriting prior cookie directives.
