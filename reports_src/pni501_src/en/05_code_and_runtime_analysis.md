# 5. Deep Dive: Code Quality, Testing & Runtime

This chapter examines Slim Framework `v4.15.3` across two complementary verification planes: **deterministic PHP AST static analysis** (`72` source files, `3,149` LOC, `72` classes/interfaces, `311` callables; `php_ast_audit`: **89/100, Grade A**) and **air-gapped container runtime execution** on `php:8.2-cli-bookworm` + PCOV `1.0.12` (`container_runtime_audit`: **98/100, Grade S**; `php_test_audit`: **95/100, Grade S**).

```drawlib align=center code=fold file=ast_module_fitness_heatmap.png caption="Figure 5.1 — Core Slim Subsystem Fitness Matrix Across 5 Engineering Dimensions & Static AST Highlights"
from drawlib.canvas import save, setup
from drawlib.charts.heatmap import HeatmapChart
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=70, dpi=150)

# Left: Module x Quality Dimension Fitness Heatmap (Bottom-Left anchored)
heatmap = HeatmapChart(
    styles=[
        Styles.WarningNeutral,
        Styles.SecondaryNeutral,
        Styles.PrimaryNeutral,
        Styles.PrimaryFlat,
    ],
    x_categories=[
        "Strict Types",
        "Line Cov.",
        "Type Safety",
        "Maintain.",
        "Imports",
    ],
    axis_line_style=Styles.Muted,
    axis_text_style=Styles.DarkBold.patch(text_size=10.0),
    value_text_style=Styles.DarkBold.patch(text_size=10.0),
    width=91.0,
    height=49.0,
    cell_gap=0.7,
    cell_r=0.6,
    title="Subsystem Fitness Matrix Across 5 Engineering Dimensions (%)",
    title_style=Styles.BlackBold.patch(text_size=11.8),
    value_format="{:.1f}",
)
heatmap.add_row("Slim/App.php", [100.0, 100.0, 90.0, 96.0, 100.0])
heatmap.add_row("Factory/AppFactory.php", [100.0, 100.0, 100.0, 95.0, 100.0])
heatmap.add_row("MiddlewareDispatcher.php", [100.0, 100.0, 85.7, 74.0, 100.0])
heatmap.add_row("CallableResolver.php", [100.0, 100.0, 68.0, 86.0, 100.0])
heatmap.add_row("Routing/RouteCollector.php", [100.0, 93.2, 78.6, 92.0, 100.0])
heatmap.add_row("Routing/Route.php", [100.0, 100.0, 81.8, 88.0, 100.0])
heatmap.add_row("Handlers/ErrorHandler.php", [100.0, 100.0, 82.4, 94.0, 100.0])
heatmap.add_row("Middleware/BodyParsingMW", [100.0, 100.0, 90.0, 96.0, 100.0])

heatmap.draw(xy=(4.5, 16.0))
heatmap.draw_colorbar(
    xy=(30.0, 7.5),
    text_style=Styles.Dark.patch(text_size=10.0),
    length=44.0,
    thickness=2.2,
    label="Normalized Dimension Fitness (0–100%)",
)

# Right: Static AST Baseline KPI Panel
panel = Panel(
    "AST Static Highlights",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.code,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
panel.draw((98.5, 6.5), width=42.5, height=58.5)
inner_xy, inner_w, inner_h = panel.get_content_box(
    (98.5, 6.5), width=42.5, height=58.5, padding=(2.5, 2.5)
)

kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.38,
    spacing=2.4,
)
kpis.add("100%", "strict_types=1", "All 72 PHP files")
kpis.add("98.6%", "Import Hygiene", "71 / 72 PSR-12 clean")
kpis.add(
    "80.1%",
    "Native Typing",
    "PHPStan + Psalm gated",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.SecondaryBold.patch(text_size=14.0),
)
kpis.draw(xy=inner_xy, width=inner_w, height=inner_h, columns=1)

save()
```

---

## 5.1 PHP AST Static Quality, Typing & SIG Maintainability Analysis

Slim Framework `v4.15.3` is remarkably compact: its `72` production PHP files total just **`3,149` lines of code** (an average of **`43.7` LOC per file**) across `72` classes/interfaces and `311` callables.

| Static Quality & SIG Metric | Measured Value | Status | Engineering Interpretation |
| :--- | :-: | :-: | :--- |
| **`declare(strict_types=1)` Adoption** | **`100.0%`** (`72 / 72`) | **`PASS`** | Every production file under `Slim/` and test file under `tests/` enforces strict scalar type coercion. |
| **PSR-12 Import Hygiene (`import_hygiene_coverage_pct`)** | **`98.6%`** (`71 / 72`) | **`PASS`** | Zero wildcard imports, zero late imports; only `1` out-of-order `use RuntimeException;` in `Slim/Handlers/Strategies/RequestResponseNamedArgs.php:16`. |
| **Native Type Safety (`type_safety_coverage_pct`)** | **`80.1%`** (`249 / 311`) | `WARN` | `62` callables omit native parameter type hints on polymorphic `$middleware` / `$toResolve` / `$callable` parameters because PHP union types (`MiddlewareInterface\|callable\|string`) require PHP `8.0+` while `composer.json` supports PHP `~7.4.0`. |
| **Static Analyzer Annotations** | `6` suppressions | `WARN` | `3` `@phpstan-ignore-next-line` (`HttpSpecializedException.php:29`, `ErrorHandler.php:195`, `MiddlewareDispatcher.php:99`) and `3` `@psalm-suppress` (`CallableResolver.php:130`, `MiddlewareDispatcher.php:196`, `RoutingResults.php:94`). |
| **AST PHPDoc Coverage (`docstring_coverage_pct`)** | **`71.6%`** | `WARN` | `0` signature mismatches (`doc_signature_mismatches=0`) and `0` empty docstrings; `98` self-descriptive methods/interfaces omit redundant docblocks. |
| **SIG Complex Functions (`complex_functions_count`)** | **`3`** (`of 311`) | `WARN` | `MiddlewareDispatcher::addDeferred` (`cognitive=26`, `101` LOC), inline anonymous `RequestHandlerInterface::handle` (`cognitive=26`, `68` LOC), and `RouteParser::relativeUrlFor` (`cognitive=13`, `60` LOC). |
| **SIG Parameter Interfacing (`excessive_parameters_count`)** | **`1`** (`of 311`) | `WARN` | Only `Slim\Routing\Route::__construct` (`Slim/Routing/Route.php:120`, `9` parameters) exceeds the SIG 6-parameter threshold. |
| **Global State & Bug-Risk Idioms** | `1` static / `1` catch | **`PASS`** | `CallableResolver::$callablePattern` (`Slim/CallableResolver.php:34`, mutable `public static`) and `MiddlewareDispatcher.php:186` (empty `catch (RuntimeException)` fallback). |
| **12-Factor Operational Readiness (PRR)** | `0` env / `0` I/O | **`PASS`** | `missing_io_timeouts=0`, `scattered_env_access=0`; `Slim\Logger::log()` (`Slim/Logger.php:30`) uses `error_log(..., 4)` intentionally as the default PSR-3 fallback logger. |

### Deep Dive: `MiddlewareDispatcher` Complexity & Deferred Resolution

`Slim/MiddlewareDispatcher.php` (`177` LOC) implements Slim's LIFO concentric PSR-15 onion kernel. While `addMiddleware(MiddlewareInterface)` and `addCallable(callable)` are concise closures, `addDeferred(string $middleware)` (`lines 144–244`, `cognitive=26`) constructs an inline anonymous `RequestHandlerInterface` (`lines 173–240`, `cognitive=26`) to defer PSR-11 container lookup and `'class:method'` parsing until request handling time:
- When `$this->callableResolver instanceof AdvancedCallableResolverInterface`, it calls `$this->callableResolver->resolveMiddleware($this->middleware)` directly.
- Otherwise, it falls back to `$this->callableResolver->resolve($this->middleware)` inside a `try { ... } catch (RuntimeException $e) {}` block (`line 186`), catching and ignoring `RuntimeException` before checking `$this->container->has($callable)` or `class_exists($callable)`. Extracting this inline anonymous class into a dedicated `DeferredMiddlewareHandler` class is the top `[P1]` recommendation in [Chapter 3](03_remediation_roadmap.md).

---

## 5.2 Hermetic Container Runtime Verification (`php:8.2-cli-bookworm` + PCOV `1.0.12`)

PNI501 executed all 4 container runtime verification gates (`RV-01` through `RV-04`) inside an isolated Docker container built from `.pni/dockerfiles/Dockerfile` (`php:8.2-cli-bookworm`, Composer 2, and PECL PCOV `1.0.12`) with network access disabled (`--network=none`).

```drawlib align=center code=fold file=runtime_coverage_breakdown.png caption="Figure 5.2 — Hermetic PHPUnit + PCOV Line Coverage Across Core Slim Modules (Overall 99.4%: 1,049 / 1,055 Statements)"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.icons import phosphor
from drawlib.smartarts import KpiCards, Panel
from drawlib.styles import Styles

setup(width=146, height=70, dpi=150)

# Left: Runtime Verification KPI Panel
panel = Panel(
    "Hermetic Runtime (RV-01..04)",
    style=Styles.Neutral,
    header_style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=10.8),
    icon=phosphor.check_circle,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
panel.draw((4.5, 6.0), width=45.0, height=58.5)
l_xy, l_w, l_h = panel.get_content_box(
    (4.5, 6.0), width=45.0, height=58.5, padding=(2.5, 2.5)
)

kpis = KpiCards(
    style=Styles.White,
    metric_style=Styles.PrimaryBold.patch(text_size=14.0),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="left_pill",
    metric_layout="left_column",
    metric_width_ratio=0.38,
    spacing=2.4,
)
kpis.add("99.4%", "PCOV Line Cov.", "1,049 / 1,055 stmts")
kpis.add(
    "100%",
    "Offline PHPUnit",
    "441 tests · 0 failed",
    accent_style=Styles.SuccessFlat,
    metric_style=Styles.SuccessBold.patch(text_size=14.0),
)
kpis.add(
    "13 / 15",
    "Modules at 100%",
    "Only 6 stmts missed",
    accent_style=Styles.SecondaryFlat,
    metric_style=Styles.SecondaryBold.patch(text_size=14.0),
)
kpis.draw(xy=l_xy, width=l_w, height=l_h, columns=1)

# Right: BarChart of Measured Line Coverage across Lowest & Core Modules
chart = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=[
        "Logger\n(0/1)",
        "Route\nCollector",
        "MW\nDispatch",
        "App\nFactory",
        "Error\nHandler",
        "Route\n(63/63)",
        "Body\nParsing",
        "Callable\nResolver",
    ],
    width=88.0,
    height=48.0,
    title="Measured PCOV Statement Coverage (%) Across Slim Modules (Ascending)",
    title_style=Styles.BlackBold.patch(text_size=11.5),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.58,
    bar_r=0.8,
    axis_text_style=Styles.DarkBold.patch(text_size=9.5),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=9.6),
    value_format="{:.1f}",
)
chart.add_series(
    "PCOV Line Coverage (%)",
    [0.0, 93.2, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0],
    style=Styles.PrimaryFlat,
)
chart.configure_y_axis(min_value=0.0, max_value=112.0, tick_step=20.0, unit="%")
chart.draw(xy=(53.5, 13.5))

save()
```

### Runtime Verification Gates (`RV-01` – `RV-04`)

| Verification Gate | Status | Duration | Command & Measured Verification Evidence |
| :--- | :-: | :-: | :--- |
| **`RV-01` Harness Image Build** | **`PASSED`** | `0.66s` | `.pni/dockerfiles/Dockerfile` (`php:8.2-cli-bookworm` + Composer 2 + PCOV `1.0.12`, `exit_code=0`). |
| **`RV-02` Air-Gapped PHPUnit Suite** | **`PASSED`** | `8.56s` | `php -l` syntax check across all `72` `Slim/*.php` files + `phpunit -d pcov.enabled=1` under `--network=none`: **`441` test cases (`846` assertions / `1,323` total harness checks) passed**, **`0` failed**, **`0` errors**, **`0` skipped**. |
| **`RV-03` PCOV Clover Coverage** | **`PASSED`** | *(with `RV-02`)* | **`99.4%` line coverage** (`1,049 / 1,055` core statements covered; `1,052 / 1,058` total Clover lines), with **13 of 15 core modules at `100.0%`**. |
| **`RV-04` Composer Autoloader Smoke** | **`PASSED`** | `0.90s` | `php -r "require '/workspace/vendor/autoload.php'; ..."` (`exit_code=0`, `"Composer PSR-4 autoloader verified"`). |

### Lowest-Covered & Core Modules Breakdown (Ascending Order)

Across the entire Slim codebase, only **6 statements** are unexecuted during the PHPUnit run (`1` in `Slim/Logger.php` and `5` in `Slim/Routing/RouteCollector.php`):

| Module Path | Line Coverage | Covered / Total Stmts | Missing Lines | Root-Cause Engineering Explanation |
| :--- | :-: | :-: | :--- | :--- |
| `Slim/Logger.php` | **`0.0%`** | `0 / 1` | `[30]` | Single `error_log(sprintf('%s: %s', $level, $message), 4)` statement in fallback PSR-3 logger; `ErrorHandlerTest` injects a custom `TestLogger` mock rather than invoking the default `Slim\Logger::log()`. |
| `Slim/Routing/RouteCollector.php` | **`93.2%`** | `69 / 74` | `[198, 199, 200, 203, 275]` | Defensive `InvalidArgumentException` / `RuntimeException` guard branches during FastRoute cache file inclusion and route lookup edge cases. |
| `Slim/MiddlewareDispatcher.php` | **`100.0%`** | `81 / 81` | `[]` | 100% statement coverage across LIFO middleware wrapping, callable adapters, and deferred PSR-11 resolution. |
| `Slim/Factory/AppFactory.php` | **`100.0%`** | `77 / 77` | `[]` | 100% statement coverage across static app creation and PSR-17 factory auto-discovery. |
| `Slim/Handlers/ErrorHandler.php` | **`100.0%`** | `69 / 69` | `[]` | 100% statement coverage across HTTP status determination, CORS/Allow header preservation, and `Accept` content negotiation. |
| `Slim/Routing/Route.php` | **`100.0%`** | `63 / 63` | `[]` | 100% statement coverage across route argument preparation, group middleware chaining, and invocation strategy dispatch. |
| `Slim/Middleware/BodyParsingMiddleware.php` | **`100.0%`** | `60 / 60` | `[]` | 100% statement coverage across JSON, form-urlencoded, and XML media-type body parsers. |
| `Slim/CallableResolver.php` | **`100.0%`** | `58 / 58` | `[]` | 100% statement coverage across `'class:method'` regex extraction, PSR-11 container resolution, and invokable objects. |
| `Slim/App.php` | **`100.0%`** | `49 / 49` | `[]` | 100% statement coverage across `run()`, `handle()`, and middleware registration helpers. |
| `Slim/ResponseEmitter.php` | **`100.0%`** | `45 / 45` | `[]` | 100% statement coverage via `AdrianSuter\Autoload\Override` interception of `header()`, `headers_sent()`, and `connection_status()`. |
| `Slim/Error/Renderers/HtmlErrorRenderer.php` | **`100.0%`** | `44 / 44` | `[]` | 100% statement coverage across HTML exception title, description, and stack-trace rendering. |
| `Slim/Middleware/ErrorMiddleware.php` | **`100.0%`** | `39 / 39` | `[]` | 100% statement coverage across exact-type, subclass-type, and default `Throwable` interception. |
| `Slim/Routing/RouteParser.php` | **`100.0%`** | `35 / 35` | `[]` | 100% statement coverage across `urlFor()`, `relativeUrlFor()`, and `fullUrlFor()`. |
| `Slim/Routing/FastRouteDispatcher.php` | **`100.0%`** | `33 / 33` | `[]` | 100% statement coverage across static and variable regex route matching and RFC `Allow` method aggregation. |
| `Slim/Routing/RouteCollectorProxy.php` | **`100.0%`** | `29 / 29` | `[]` | 100% statement coverage across `get`, `post`, `put`, `patch`, `delete`, `options`, `any`, `group`, and `redirect`. |
