# PNI Software Health Diagnostic Report

**Slim Framework `v4.15.3`** (`slim/slim`) — Automated Static PHP AST, 5-Tier PSR-7/PSR-15 Namespace Dependency DAG, Hermetic PHPUnit + PCOV Container Runtime, and Supply-Chain Security Audit (`pni501` · Run `wf-1d820a74`).

```drawlib align=center code=fold file=pni_00_cover.png caption="Slim Framework v4.15.3 — PNI501 Overall Engineering & Architecture Health Scorecard (94/100 Grade S)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Colors, Styles

setup(width=146, height=58, dpi=150)

white_card = Styles.Neutral.patch(shape_fill_color=Colors.White)

outer = Panel(
    "Slim Framework v4.15.3 — Health Scorecard",
    "PNI501 (wf-1d820a74) · PHP ~7.4..~8.5 · 100% strict_types=1",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=12.0),
    description_style=Styles.Muted.patch(text_size=10.0),
    icon=phosphor.gauge,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=9.0,
)
outer.draw((4.5, 4.5), width=137.0, height=49.0, align="bottom_left")
inner_xy, inner_w, inner_h = outer.get_content_box(
    (4.5, 4.5),
    width=137.0,
    height=49.0,
    padding=(3.5, 3.0),
    align="bottom_left",
)

kpis = KpiCards(
    style=white_card,
    metric_style=Styles.DarkBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=11.2),
    description_style=Styles.Muted.patch(text_size=10.0),
    accent_style=Styles.PrimaryFlat,
    icon_style=Styles.PrimaryBold,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.30,
    spacing=3.5,
)

kpis.add(
    "94 / 100",
    "Overall Score (Grade S)",
    "72 PHP files · 3,149 LOC · PSR-7/11/15/17",
    style=Styles.PrimaryFlat,
    metric_style=Styles.WhiteBold.patch(text_size=14.0),
    text_style=Styles.WhiteBold.patch(text_size=11.2),
    description_style=Styles.White.patch(text_size=10.0),
    accent_style=Styles.WhiteFlat,
    icon=phosphor.check_circle,
    icon_style=Styles.WhiteBold,
)
kpis.add(
    "12 / 17",
    "Rule Compliance (0 FAIL)",
    "12 PASS · 3 WARN · 2 N/A (1M, 8L)",
    accent_style=Styles.PrimaryFlat,
    icon=phosphor.clipboard_text,
    icon_style=Styles.PrimaryBold,
)
kpis.add(
    "99.4%",
    "Hermetic PCOV Coverage",
    "1,049 / 1,055 stmts · 441 offline tests",
    accent_style=Styles.SuccessFlat,
    icon=phosphor.shield_check,
    icon_style=Styles.SuccessBold,
)
kpis.add(
    "0 CVEs",
    "0 App CVEs · 0 CWE Sinks",
    "93 Composer pkgs · 0 secrets · 0 IaC",
    accent_style=Styles.SuccessFlat,
    icon=phosphor.lock_key,
    icon_style=Styles.SuccessBold,
)

kpis.draw(inner_xy, width=inner_w, height=inner_h, columns=2, align="bottom_left")

save()
```

| Diagnostic Attribute | Verified Metadata & Audit Baseline |
| :--- | :--- |
| **Target Project** | `slim` (`Slim Framework v4.15.3`, package `slim/slim`, PHP `~7.4.0 \|\| ~8.0.0 .. ~8.5.0`, `100%` `declare(strict_types=1)`) |
| **Target Language & Profile** | `php` (`library` — Standards-compliant PSR-7, PSR-11, PSR-15 & PSR-17 HTTP micro-framework) |
| **Upstream License & Attribution** | MIT License (`LICENSE-SLIM`; Copyright © Josh Lockhart, Andrew Smith, Rob Allen, Pierre Bérubé, and Slim Framework contributors) |
| **Diagnostic Workflow** | `pni501` (Workflow Run ID `wf-1d820a74`, category `audit`) |
| **Evaluated At** | `2026-11-10T03:27:24.695841+00:00` |
| **Overall Score & Grade** | **94 / 100 (Grade S)** — `12 / 17` rules `PASS`, `3 WARN`, `0 FAIL`, `2 NOT_APPLICABLE` (`9` findings: `0` CRITICAL, `0` HIGH, `1` MEDIUM, `8` LOW) |
| **Analyzed Codebase Scope** | `72` PHP source files (`3,149` LOC, `72` classes/interfaces, `311` callables) & `35` PHPUnit test classes (`306` test methods, `441` data-provider cases / `1,323` hermetic container executions, `99.4%` PCOV line coverage) |

> [!NOTE]
> **Unofficial Engineering Showcase Notice (`drawlib-slim`)**: This diagnostic report is an independent, automated engineering and architecture assessment generated with [PNI501](https://pypi.org/project/pni501/) and [Drawlib](https://www.drawlib.com/) to showcase [Slim Framework 4](https://www.slimframework.com/)'s standards-driven PHP design. It is part of the 4-portal [drawlib-slim](https://github.com/yuichi110/drawlib-slim) showcase:
> - **Portal 1 — User Guide**: [https://slim.drawlib.com/](https://slim.drawlib.com/)
> - **Portal 2 — API Reference Catalog**: [https://slim.drawlib.com/api/](https://slim.drawlib.com/api/)
> - **Portal 3 — Internal Architecture Deep-Dive**: [https://slim.drawlib.com/architecture/](https://slim.drawlib.com/architecture/)
> - **Portal 4 — PNI501 Engineering & Architecture Diagnostic**: [https://slim.drawlib.com/reports/pni501/](https://slim.drawlib.com/reports/pni501/)
