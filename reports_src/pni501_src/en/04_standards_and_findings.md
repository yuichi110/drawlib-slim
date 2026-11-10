# 4. Audit Standards, Rule Compliance & Findings

PNI501 evaluated Slim Framework `v4.15.3` across **6 deterministic audit steps** and **17 engineering compliance rules** spanning static PHP AST maintainability, PSR-12 import ordering, Composer supply-chain hygiene, PSR library interface design, PHPUnit test determinism, and hermetic `--network=none` container execution. Every audit step achieved Grade `A` or `S` (`89/100` to `100/100`), yielding **12 `PASS` rules**, **3 advisory `WARN` rules**, **0 `FAIL` rules**, **2 `NOT_APPLICABLE` framework rules** (`laravel`, `wordpress`), and **9 consolidated location findings** (`0 CRITICAL`, `0 HIGH`, `1 MEDIUM`, `8 LOW`).

```drawlib align=center code=fold file=audit_step_scores_bar.png caption="Figure 4.1 — Executed PNI501 Audit Step Scores (Weakest-First Ascending: 89 to 100) & 17-Rule Stacked Compliance Breakdown"
from drawlib.canvas import save, setup
from drawlib.charts.bar import BarChart
from drawlib.shapes import rectangle
from drawlib.styles import Colors, Styles

setup(width=158, height=76, dpi=150)

# Left framing card: Weakest-First Ascending Step Scores BarChart
rectangle(
    (47.0, 38.0),
    width=86.0,
    height=65.0,
    style=Styles.Neutral.patch(shape_r=2.0, shape_fill_color=Colors.White, shape_line_color=Colors.Gray3),
)

chart_left = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=[
        "php_ast_\naudit",
        "library_\nhygiene",
        "php_test_\naudit",
        "repo_\nstructure",
        "container_\nruntime",
        "security_\nvuln_audit",
    ],
    width=78.0,
    height=50.0,
    title="Audit Step Scores (/100, Weakest -> Strongest)",
    title_style=Styles.DarkBold.patch(text_size=11.0),
    orientation="vertical",
    bar_mode="group",
    bar_width_ratio=0.54,
    bar_r=0.9,
    axis_text_style=Styles.Dark.patch(text_size=9.5),
    grid_style=Styles.MutedThin,
    value_text_style=Styles.DarkBold.patch(text_size=9.8),
    value_format="{:.0f}",
)
chart_left.add_series("Step Score", [89.0, 94.0, 95.0, 96.0, 98.0, 100.0], style=Styles.PrimaryFlat)
chart_left.configure_y_axis(min_value=0.0, max_value=108.0, ticks=[0.0, 20.0, 40.0, 60.0, 80.0, 100.0])
chart_left.draw(xy=(8.0, 13.0), align="bottom_left")

# Right framing card: Stacked BarChart of Rule Outcomes per Audit Step
rectangle(
    (124.0, 38.0),
    width=62.0,
    height=65.0,
    style=Styles.Neutral.patch(shape_r=2.0, shape_fill_color=Colors.White, shape_line_color=Colors.Gray3),
)

chart_right = BarChart(
    axis_line_style=Styles.MutedDashed,
    categories=[
        "AST",
        "Lib",
        "Test",
        "Repo",
        "Run",
        "Sec",
    ],
    width=52.0,
    height=46.0,
    title="17 Rule Verdicts by Step (12P · 3W · 2N/A)",
    title_style=Styles.DarkBold.patch(text_size=10.8),
    orientation="vertical",
    bar_mode="stack",
    bar_width_ratio=0.56,
    bar_r=0.6,
    axis_text_style=Styles.Dark.patch(text_size=9.5),
    grid_style=Styles.MutedThin,
)
chart_right.add_series("PASS (12)", [5.0, 2.0, 1.0, 6.0, 2.0, 3.0], style=Styles.PrimaryFlat)
chart_right.add_series("WARN (3)", [2.0, 1.0, 0.0, 0.0, 0.0, 0.0], style=Styles.WarningFlat)
chart_right.add_series("N/A (2)", [2.0, 0.0, 0.0, 0.0, 0.0, 0.0], style=Styles.SecondaryNeutral)
chart_right.configure_y_axis(min_value=0.0, max_value=10.0, ticks=[0.0, 2.0, 4.0, 6.0, 8.0, 10.0])
chart_right.draw(xy=(98.0, 16.5), align="bottom_left")
chart_right.draw_legend(
    xy=(97.0, 8.5),
    text_style=Styles.DarkBold.patch(text_size=9.5),
    orientation="horizontal",
    item_gap=3.5,
)

save()
```

---

## 4.1 Executed Audit Step Breakdown (`Weakest -> Strongest`)

| Audit Step ID | Score & Grade | Rule Verdicts | Step Synthesis & Key Evidence |
| :--- | :-: | :-: | :--- |
| **`php_ast_audit`** | **`89 / 100` (A)** | `5 PASS`, `2 WARN`, `0 FAIL`, `2 N/A` | `72` source files (`3,149` LOC, `72` classes/interfaces, `311` callables); `100%` `declare(strict_types=1)`, `98.6%` PSR-12 import ordering (`1` out-of-order `use` in `RequestResponseNamedArgs.php:16`), `0` CWE sinks, `0` direct superglobal reads in routing/middleware. Advisories: `MiddlewareDispatcher::addDeferred` (`cognitive=26`), `DispatcherInterface <-> RoutingResults` 2-node cycle, `Route::__construct` (`9` params), and `62` PHP 7.4 polymorphic untyped parameters. |
| **`library_hygiene_audit`** | **`94 / 100` (S)** | `2 PASS`, `1 WARN`, `0 FAIL` | Exposes `17` explicit interfaces in `Slim\Interfaces\`, `0` import-time side effects, `0` `exit`/`die` statements, flexible SemVer `^` and `\|\|` bounds across all `7` runtime packages (`psr/container: ^1.0 \|\| ^2.0`, `psr/http-message: ^1.1 \|\| ^2.0`, `psr/log: ^1.1 \|\| ^2.0 \|\| ^3.0`), `0` scattered `getenv()`/`$_ENV` reads, and `71.6%` AST PHPDoc coverage (`0` signature mismatches). |
| **`php_test_audit`** | **`95 / 100` (S)** | `1 PASS`, `0 WARN`, `0 FAIL` | `35` PHPUnit test classes and `306` test methods under `tests/` mirroring `Slim/`. Runs 100% offline using in-memory PSR-7 streams (`PSR7ObjectProvider`), `AdrianSuter\Autoload\Override` for deterministic `header()`/`connection_status()`/`is_writable()` interception, and `executionOrder="random"` in `phpunit.xml.dist`. |
| **`repo_structure_audit`** | **`96 / 100` (S)** | `6 PASS`, `0 WARN`, `0 FAIL` | Exemplary Composer packaging (`composer.json` + deterministic `composer.lock` with `93` locked packages), `0` unpinned dependencies, triple static analysis (`PHPStan`, `Psalm`, `PHP_CodeSniffer` PSR-12), and full governance (`README.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `LICENSE-SLIM`). |
| **`container_runtime_audit`** | **`98 / 100` (S)** | `2 PASS`, `0 WARN`, `0 FAIL` | Hermetic container verification (`php:8.2-cli-bookworm` + Composer 2 + PCOV `1.0.12`) passed all 4 gates (`RV-01`..`RV-04`): image build (`0.66s`), `php -l` syntax check across `72` files, `--network=none` PHPUnit 11.5.57 (`441` cases / `1,323` executions, `0` failures), **99.4% PCOV line coverage** (`1,049 / 1,055` statements; `13/15` core modules at `100.0%`), and PSR-4 autoloader smoke check. |
| **`security_vulnerability_audit`** | **`100 / 100` (S)** | `3 PASS`, `0 WARN`, `0 FAIL` | Trivy `0.69.3` SCA, secret, and IaC scanning + PHP SAST confirm **`0` CVEs** across all `93` locked Composer packages (`core_app_vuln_counts=0`, `dev_app_vuln_counts=0`), **`0` secrets**, **`0` misconfigurations**, and **`0` CWE dangerous sinks**. |

---

## 4.2 Full 17-Rule Compliance Matrix (`FAIL -> WARN -> PASS -> NOT_APPLICABLE`)

Across all 17 evaluated PNI501 engineering standards, Slim Framework `v4.15.3` records **`0 FAIL`**, **`3 WARN`**, **`12 PASS`**, and **`2 NOT_APPLICABLE`** checks:

| Status | Rule ID | Evaluated By | Diagnostic Evidence & Verification Summary |
| :-: | :--- | :--- | :--- |
| **`[WARN]`** | `common/documentation` | `library_hygiene_audit` | `README.md` (`101` lines), `CHANGELOG.md`, `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, and `SECURITY.md` provide complete governance; `0` PHPDoc `@param` signature mismatches (`doc_signature_mismatches=0`) and `0` empty docstrings; `71.6%` overall AST PHPDoc coverage (`98` inherited/accessor methods omit explicit `/** ... */` blocks). |
| **`[WARN]`** | `common/maintainability` | `php_ast_audit` | `3,149` LOC across `72` files (avg `43.7` LOC/file), with `3` complex methods (`MiddlewareDispatcher::addDeferred` `cognitive=26`, inline anonymous `RequestHandlerInterface::handle` `cognitive=26`, `RouteParser::relativeUrlFor` `cognitive=13`) and `1` constructor exceeding 6 parameters (`Slim\Routing\Route::__construct`, `params=9`). |
| **`[WARN]`** | `php/typing` | `php_ast_audit` | `100%` of files declare `declare(strict_types=1)` and `80.1%` of callables are fully typed at the native PHP AST level; `62` callables omit native parameter type hints on polymorphic `$middleware` / `$toResolve` / `$callable` arguments (`callable\|string\|MiddlewareInterface`) due to PHP `7.4` union-type constraints, plus `6` unscoped `@phpstan`/`@psalm` annotations. |
| **`[PASS]`** | `common/architecture` | `php_ast_audit` | Clean 5-Tier PSR subsystem layering (`Interfaces/Exception` -> `CallableResolver/Psr17` -> `Routing/Strategies` -> `Middleware/Handlers/Error` -> `App/Factory/ResponseEmitter`) with only `1` localized bidirectional reference between `Slim\Interfaces\DispatcherInterface` and `Slim\Routing\RoutingResults`. |
| **`[PASS]`** | `common/git_workflow` | `repo_structure_audit` | `.gitignore`, `.gitattributes`, and `.editorconfig` enforce clean working-tree hygiene and consistent LF line endings. |
| **`[PASS]`** | `common/library_guidelines` | `library_hygiene_audit` | `17` contract interfaces in `Slim\Interfaces\`, `0` import-time side effects, `0` `exit`/`die` calls, `0` `scattered_env_access`, and flexible `^1.0 \|\| ^2.0` SemVer ranges across PSR packages. |
| **`[PASS]`** | `common/production_readiness` | `container_runtime_audit` | `0` external I/O calls without timeouts (`missing_io_timeouts=0`), structured PSR-3 `LoggerInterface` error propagation in `ErrorHandler`, and stateless PSR-15 `RequestHandlerInterface` execution compatible with PHP-FPM, RoadRunner, Swoole, and FrankenPHP. |
| **`[PASS]`** | `common/runtime_verification` | `container_runtime_audit` | `RV-01` harness build passed (`exit_code=0`, `0.66s`); `RV-02` offline `--network=none` PHPUnit suite passed (`0` failed, `0` errors); `RV-03` measured **99.4% line coverage** via `phpunit-pcov` (`1,049 / 1,055` statements); `RV-04` Composer PSR-4 autoloader smoke passed. |
| **`[PASS]`** | `common/security` | `repo_structure_audit` | `0` committed secret files (`committed_secret_files=[]`), explicit `SECURITY.md` disclosure policy, `0` hardcoded secrets (`hardcoded_secrets=0`), `0` dangerous sinks (`dangerous_sinks=0`), strict `htmlentities(..., ENT_COMPAT \| ENT_HTML5, 'utf-8')` escaping in `HtmlErrorRenderer`, and external XML entity disabling in `BodyParsingMiddleware`. |
| **`[PASS]`** | `common/security_vulnerability` | `security_vulnerability_audit` | `0` CWE injection or deserialization sinks across all `72` PHP source files; **`0` CVEs** across all runtime and dev Composer dependencies (`core_app_vuln_counts=0`, `dev_app_vuln_counts=0`), `0` secrets, and `0` container IaC misconfigurations. |
| **`[PASS]`** | `common/supply_chain` | `repo_structure_audit` | `composer.json` and `composer.lock` (`93` locked packages) present with `0` unpinned dependencies; runtime dependencies limited strictly to `6` PSR contract packages and `nikic/fast-route ^1.3`. |
| **`[PASS]`** | `php/code_quality` | `php_ast_audit` | `98.6%` PSR-12 import hygiene (`1` out-of-order `use RuntimeException` in `Slim/Handlers/Strategies/RequestResponseNamedArgs.php:16`), `0` direct superglobal reads in core routing/middleware, `1` mutable static property (`CallableResolver::$callablePattern`), and `1` fallback catch block (`MiddlewareDispatcher.php:186`). |
| **`[PASS]`** | `php/dependencies` | `repo_structure_audit` | Clean PSR-4 autoload mapping (`'Slim\\': 'Slim/'`, `'Slim\\Tests\\': 'tests/'`) with `0` procedural file autoloads and dual static analyzers (`phpstan/phpstan: ^1 \|\| ^2` and `vimeo/psalm: ^5 \|\| ^6`). |
| **`[PASS]`** | `php/modern_stack` | `repo_structure_audit` | Supports active PHP `8.2`, `8.3`, `8.4`, and `8.5` runtimes alongside backward compatibility constraints (`~7.4.0`..`~8.5.0`); `0` deprecated PHP functions; PSR-3 `LoggerInterface` used throughout `ErrorMiddleware` and `ErrorHandler`. |
| **`[PASS]`** | `php/testing` | `php_test_audit` | `306` PHPUnit test methods across `35` test files with `79.2%` direct AST symbol mapping (remaining files are declarative interfaces and marker HTTP exceptions) and 100% offline execution via in-memory PSR-7 streams and `AdrianSuter\Autoload\Override`. |
| **`[NOT_APPLICABLE]`** | `php/frameworks/laravel` | `php_ast_audit` | Repository is the upstream Slim Framework library, not a Laravel application. |
| **`[NOT_APPLICABLE]`** | `php/frameworks/wordpress` | `php_ast_audit` | Repository is the upstream Slim Framework library, not a WordPress plugin or theme. |

---

## 4.3 Consolidated Location Findings Index (`CRITICAL -> INFO`)

```drawlib align=center code=fold file=consolidated_findings_matrix.png caption="Figure 4.2 — Consolidated Location Findings Overview (9 Unique Locations: 0 CRITICAL · 0 HIGH · 1 MEDIUM · 8 LOW)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import Table
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=168, height=122, dpi=150)

phosphor.magnifying_glass((10.0, 116.2), width=4.2, style=Styles.PrimaryBold)
text(
    (84.0, 116.2),
    "Consolidated Location Findings Matrix (9 Unique Findings  ·  0 CRITICAL  ·  0 HIGH  ·  1 MEDIUM  ·  8 LOW)",
    style=Styles.DarkBold.patch(text_size=11.5),
)

table = Table(
    cell_style=Styles.White,
    text_style=Styles.Dark.patch(text_size=9.5),
    header_cell_style=Styles.PrimaryFlat,
    header_text_style=Styles.WhiteBold.patch(text_size=10.0),
    border_style=Styles.MutedThin,
    has_header=True,
)

table.set_style_cell_evenodd(
    even_color=Colors.Gray1,
    even_text_style=Styles.Dark.patch(text_size=9.5),
    odd_color=Colors.White,
    odd_text_style=Styles.Dark.patch(text_size=9.5),
)

table.set_style_cell_header(
    background_color=Colors.Dark,
    text_style=Styles.WhiteBold.patch(text_size=10.0),
)

table.set_style_cell(
    background_color=Colors.WarningNeutral,
    text_style=Styles.DarkBold.patch(text_size=9.5),
    rows=[1],
    columns=[0],
)
table.set_style_cell(
    background_color=Colors.SecondaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=9.5),
    rows=[2, 3, 4, 5, 6, 7, 8, 9],
    columns=[0],
)

table.set_style_border(
    top=Styles.Dark.patch(line_width=1.4),
    top2=Styles.Dark.patch(line_width=1.1),
    bottom=Styles.Dark.patch(line_width=1.4),
    left=Styles.MutedThin,
    right=Styles.MutedThin,
    between_columns=Styles.MutedThin,
    between_rows=Styles.MutedThin,
)

findings_rows = [
    ["Severity", "Location / Scope", "Rule ID", "Diagnostic Evidence", "Recommended Remediation"],
    [
        "[MEDIUM]\n#1",
        "Slim/Middleware\nDispatcher.php:144,186",
        "common/\nmaintainability",
        "addDeferred (101L, cog=26) embeds\nanon RequestHandler (68L, cog=26) &\nempty catch(RuntimeException) at L186",
        "Extract DeferredMiddlewareHandler\nclass & prefer AdvancedCallable\nResolverInterface::resolveMiddleware",
    ],
    [
        "[LOW]\n#2",
        "Slim/Interfaces/\nDispatcherInterface.php",
        "common/\narchitecture",
        "DispatcherInterface imports concrete\nRoutingResults while RoutingResults\nimports DispatcherInterface (2-node)",
        "Extract RoutingResultsInterface in\nSlim\\Interfaces\\ so contracts have\nzero imports from Slim\\Routing\\",
    ],
    [
        "[LOW]\n#3",
        "Slim/Error/Renderers/*\nSlim/Exception/*",
        "common/\ndocumentation",
        "Public ErrorRenderer::__invoke and\nHttpException getters/setters omit\nexplicit PHPDocs (71.6% coverage)",
        "Add @inheritdoc or concise PHPDoc\nsummaries on ErrorRenderer and\nHttpException public methods",
    ],
    [
        "[LOW]\n#4",
        "Slim/Logger.php:30\nRouteCollector.php",
        "common/runtime_\nverification",
        "PCOV reports 99.4% line coverage,\nleaving Logger::log() L30 (0/1) &\n5 RouteCollector lines uncovered",
        "Add tests/LoggerTest.php exercising\nSlim\\Logger::log() with an overridden\nerror_log() SAPI stub",
    ],
    [
        "[LOW]\n#5",
        "Slim/Callable\nResolver.php:34",
        "php/\ncode_quality",
        "Declares public static callablePattern\nas a mutable public static property\nrather than a class constant",
        "Convert to public const\nCALLABLE_PATTERN and allow pattern\ncustomization via constructor",
    ],
    [
        "[LOW]\n#6",
        "composer.json\n(require.php)",
        "php/\nmodern_stack",
        "Retains '~7.4.0 || ~8.0.0 || ~8.1.0'\nfor 4.x ecosystem compatibility,\nprecluding readonly/union syntax",
        "Keep 4.x floor for existing users\nwhile targeting PHP ^8.2 minimum in\nthe Slim 5.x major release branch",
    ],
    [
        "[LOW]\n#7",
        "Slim/CallableResolver\nMiddlewareDispatcher",
        "php/\ntyping",
        "62 methods omit native parameter\ntypes on middleware / toResolve\ndue to PHP 7.4 union-type limits",
        "Adopt native PHP 8.0+ union types\n(MiddlewareInterface|callable|string)\nonce PHP 7.4 support is dropped",
    ],
    [
        "[LOW]\n#8",
        "tests/AppTest.php\nErrorMiddlewareTest",
        "php/\ntesting",
        "20 test methods verify behavior\nexclusively via Prophecy spy calls\nwithout explicit assert*() calls",
        "Pair Prophecy shouldBeCalled()\npredictions with explicit return or\nstate assertions where applicable",
    ],
    [
        "[LOW]\n#9",
        "Slim/Routing/\nRoute.php:120",
        "common/\nmaintainability",
        "Route::__construct accepts 9 positional\nparameters, exceeding the SIG\n6-parameter interfacing threshold",
        "Group shared runtime collaborators\ninto an immutable RouteConfiguration\nvalue object in Slim 5.x",
    ],
]

table.draw_flexible(
    xy=(4.5, 110.0),
    column_widths=[16.5, 29.5, 21.5, 46.5, 45.0],
    row_heights=[7.2] + [10.6] * 9,
    data=findings_rows,
    align="top_left",
)

save()
```

---

## 4.4 Configured Scope & Accepted Design Waivers (`.pni/pni.toml`)

PNI501 inspected `.pni/pni.toml` for project-scoped rule waivers (`[[opt_out]]`). Exactly **1 design waiver** is configured for the ephemeral batch container test harness:

| Waiver Rule ID | Scoped Glob Pattern | Matched Findings | Engineering Justification |
| :--- | :--- | :-: | :--- |
| **`DS-0026`** | `[.pni/dockerfiles/**]` | `0` | Hermetic batch test container (`php:8.2-cli-bookworm`) executes `phpunit` and exits immediately upon completion; long-running daemon `HEALTHCHECK` directives are not applicable. |
