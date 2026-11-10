# 3. Recommended Remediation Roadmap

Slim Framework `v4.15.3` enters remediation planning from an exceptional **94/100 (Grade S)** baseline with **zero `P0` urgent blockers**, **zero `FAIL` compliance rules**, **zero `CRITICAL` or `HIGH` source-code findings**, and **zero supply-chain CVEs** across all 93 locked Composer packages. Rather than emergency defect patching, the 7-item engineering roadmap focuses on **1 `P1` high-value maintainability refactoring** in `MiddlewareDispatcher::addDeferred` followed by **6 `P2` architectural boundary, documentation, testing, and Slim 5.x typing modernization items**.

```drawlib align=center code=fold file=remediation_timeline_roadmap.png caption="Figure 3.1 — Phased Engineering Refinement Roadmap for Slim Framework v4.15.3 (0 P0 Blockers · 1 P1 High-Leverage · 6 P2 Polish)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.shapes import rectangle
from drawlib.smartarts import Roadmap
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=146, height=66, dpi=150)

# Header framing banner (neutral baseline)
rectangle(
    (73.0, 59.5),
    width=134.0,
    height=7.5,
    style=Styles.Neutral.patch(shape_r=1.8, shape_fill_color=Colors.Gray1, shape_line_color=Colors.Gray3),
)
phosphor.rocket_launch((11.0, 59.5), width=4.4, style=Styles.PrimaryBold)
text(
    (75.0, 59.5),
    "Slim Framework v4.15.3 Remediation Horizon  ·  0 P0 Blockers  |  1 P1 Refactoring  |  6 P2 Polish Items",
    style=Styles.DarkBold.patch(text_size=11.0),
)

# Phased Remediation Roadmap (Bottom-Left anchored at xy=(6.0, 5.0))
rm = Roadmap(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=11.0),
    description_style=Styles.Dark.patch(text_size=9.8),
    spine_style=Styles.DarkBold,
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.5),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    curve_bend=0.0,
    card_shape="rounded_rect",
    spacing=2.8,
)

rm.add(
    "P0: None Required (0 Blockers)",
    "Zero FAIL rules, zero CRITICAL/HIGH findings, 0 Composer CVEs, and 99.4% PCOV coverage (441 / 441 tests)",
    badge_text="P0",
    icon=phosphor.shield_check,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.5),
    icon_style=Styles.SecondaryBold,
)
rm.add(
    "P1: MiddlewareDispatcher::addDeferred Extraction (1 Action)",
    "#1 Extract inline anonymous RequestHandlerInterface (cognitive=26 -> <10) & remove silent catch fallback",
    badge_text="P1",
    icon=phosphor.wrench,
    style=Styles.PrimaryNeutral,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_size=10.5),
    icon_style=Styles.PrimaryBold,
)
rm.add(
    "P2: Interface Cycle, PHPDoc, Logger Test & Slim 5.x Typing Polish (6 Actions)",
    "#2 DispatcherInterface cycle · #3 PHPDocs · #4 PHP 8.2+ floor · #5 LoggerTest · #6 Prophecy · #7 Union types",
    badge_text="P2",
    icon=phosphor.sparkle,
    style=Styles.Neutral,
    badge_style=Styles.Neutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.5),
    icon_style=Styles.DarkBold,
)

rm.draw(xy=(6.0, 5.0), width=134.0, height=49.0, align="bottom_left", scale=1.0)

save()
```

---

## 3.1 Action Plan Traceability Matrix (`P0 -> P1 -> P2`)

Every remediation candidate identified by PNI501 maps deterministically to concrete file coordinates, expected engineering outcomes, and underlying compliance rules:

```drawlib align=center code=fold file=remediation_traceability_table.png caption="Figure 3.2 — Action Plan Traceability Matrix Mapping Priorities, Target Files, Expected Impact, and Audit Rules"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import Table
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=160, height=112, dpi=150)

phosphor.clipboard_text((10.0, 106.2), width=4.2, style=Styles.PrimaryBold)
text(
    (80.0, 106.2),
    "Remediation Action Plan Traceability Matrix (0 P0 Urgent  ·  1 P1 High-Leverage  ·  6 P2 Polish)",
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
    background_color=Colors.PrimaryNeutral,
    text_style=Styles.PrimaryBold.patch(text_size=9.5),
    rows=[1],
    columns=[0],
)
table.set_style_cell(
    background_color=Colors.SecondaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=9.5),
    rows=[2, 3, 4, 5, 6, 7],
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

traceability_rows = [
    ["Priority", "Action Title", "Target Files", "Expected Impact", "Related Rules"],
    [
        "[P1] #1\nmaintainability",
        "Refactor MiddlewareDispatcher::\naddDeferred inline anonymous\nhandler into helper class",
        "Slim/MiddlewareDispatcher.php\n(lines 144–244, line 186)",
        "Cuts cognitive complexity\n26 -> <10 & removes empty\ncatch(RuntimeException)",
        "common/\nmaintainability\nphp/code_quality",
    ],
    [
        "[P2] #2\narchitecture",
        "Decouple DispatcherInterface\nfrom concrete\nSlim\\Routing\\RoutingResults",
        "Slim/Interfaces/Dispatcher\nInterface.php\nSlim/Routing/RoutingResults.php",
        "Eliminates the sole 2-node\ncircular namespace dependency\nin the codebase",
        "common/\narchitecture",
    ],
    [
        "[P2] #3\ndocumentation",
        "Add @inheritdoc or PHPDoc\nsummaries to ErrorRenderer &\nHttpException public methods",
        "Slim/Error/Renderers/*\nSlim/Exception/HttpException\nSlim/Factory/AppFactory.php",
        "Increases AST PHPDoc\ncoverage from 71.6% to\n>90% with 0 mismatches",
        "common/\ndocumentation",
    ],
    [
        "[P2] #4\nmodernization",
        "Drop EOL PHP < 8.2 floor\nin next major version branch\n(Slim 5.x)",
        "composer.json\nSlim/* (Slim 5.x branch)",
        "Unlocks readonly properties,\nconstructor promotion & union\ntypes across Slim core",
        "php/\nmodern_stack",
    ],
    [
        "[P2] #5\ntesting",
        "Add unit test for\nSlim\\Logger::log() fallback\nPSR-3 logger",
        "tests/LoggerTest.php\nSlim/Logger.php:30",
        "Raises measured PCOV line\ncoverage from 99.4% to\n99.5%+ (14/15 modules 100%)",
        "common/runtime_\nverification",
    ],
    [
        "[P2] #6\ntesting",
        "Pair Prophecy spy predictions\nin AppTest & ErrorMiddlewareTest\nwith explicit assertions",
        "tests/AppTest.php\ntests/Middleware/\nErrorMiddlewareTest.php",
        "Eliminates reliance on\nimplicit Prophecy teardown\nchecks alone (20 tests)",
        "php/testing",
    ],
    [
        "[P2] #7\ntyping",
        "Add native union type hints &\nconst CALLABLE_PATTERN in\nCallableResolver & Dispatcher",
        "Slim/CallableResolver.php\nSlim/MiddlewareDispatcher.php\nSlim/Routing/Route*.php",
        "Raises native AST type\nsafety from 80.1% toward\n100% & removes static state",
        "php/typing\nphp/code_quality",
    ],
]

table.draw_flexible(
    xy=(4.5, 100.0),
    column_widths=[19.0, 38.5, 35.5, 34.0, 24.0],
    row_heights=[7.5, 12.8, 12.8, 12.8, 12.8, 12.8, 12.8, 12.8],
    data=traceability_rows,
    align="top_left",
)

save()
```

---

## 3.2 Detailed Engineering Specifications by Action Item

### 1. `[P1]` Refactor `MiddlewareDispatcher::addDeferred` Inline Anonymous Handler (`maintainability`)

- **Target Coordinates**: `Slim/MiddlewareDispatcher.php:144–244` (`MiddlewareDispatcher::addDeferred` and its nested anonymous `RequestHandlerInterface::handle` at lines `173–240`, plus the empty `catch (RuntimeException $e)` block at line `186`).
- **Diagnostic Root Cause**: `addDeferred()` wraps string or callable middleware definitions inside a `68`-line inline anonymous `RequestHandlerInterface` class (`cognitive=26`). When `$this->callableResolver` is not an `AdvancedCallableResolverInterface`, it attempts `$this->callableResolver->resolve($this->middleware)` inside a `try { ... } catch (RuntimeException $e) {}` block and silently ignores resolution failures before falling back to manual container/class instantiation.
- **Recommended Implementation**:
  1. Extract the deferred resolution handler into a dedicated internal class (`Slim\DeferredMiddlewareHandler implements RequestHandlerInterface`) or decompose resolution into a private `resolveDeferredMiddleware()` helper method.
  2. Delegate directly to `AdvancedCallableResolverInterface::resolveMiddleware()` when available, and replace the empty `catch (RuntimeException)` block with explicit container/class existence checks so genuine instantiation errors are never swallowed.
- **Expected Impact**: Reduces cognitive complexity in `Slim/MiddlewareDispatcher.php` from `26` to `<10` and eliminates the sole `bug_risk_idioms` finding.

### 2. `[P2]` Decouple `Slim\Interfaces\DispatcherInterface` from Concrete `Slim\Routing\RoutingResults` (`architecture`)

- **Target Coordinates**: `Slim/Interfaces/DispatcherInterface.php:10,27` and `Slim/Routing/RoutingResults.php:13,47`.
- **Diagnostic Root Cause**: `Slim\Interfaces\DispatcherInterface::dispatch(string $httpMethod, string $uri): RoutingResults` imports and returns concrete `Slim\Routing\RoutingResults` (`Tier 3`), while `RoutingResults::__construct(DispatcherInterface $dispatcher, ...)` imports `DispatcherInterface` (`Tier 1`). Additionally, `Slim\Interfaces\RouteGroupInterface` imports concrete `Slim\MiddlewareDispatcher`, and `Slim\Interfaces\RouteResolverInterface` imports `RoutingResults`.
- **Recommended Implementation**: Introduce `Slim\Interfaces\RoutingResultsInterface` (carrying `NOT_FOUND = 0`, `FOUND = 1`, `METHOD_NOT_ALLOWED = 2` and accessor contracts) so `Slim\Interfaces\` remains a 100% leaf-level contract package with zero upward imports into `Slim\Routing\`.

### 3. `[P2]` Add `@inheritdoc` or PHPDoc Summaries to `ErrorRenderer` and `HttpException` Methods (`documentation`)

- **Target Coordinates**: `Slim/Error/Renderers/HtmlErrorRenderer.php`, `JsonErrorRenderer.php`, `PlainTextErrorRenderer.php`, `XmlErrorRenderer.php`, `Slim/Exception/HttpException.php`, and setter methods on `Slim/Factory/AppFactory.php`.
- **Diagnostic Root Cause**: While `doc_signature_mismatches = 0` and `empty_docstrings = 0`, `98` inherited or self-explanatory accessor methods omit explicit `/** ... */` docblocks, resulting in `71.6%` AST PHPDoc coverage.
- **Recommended Implementation**: Add concise `/** @inheritdoc */` annotations on `ErrorRendererInterface::__invoke` implementations and one-line summaries on `HttpException` getters/setters and `AppFactory` static setters, lifting AST PHPDoc coverage above `90%`.

### 4. `[P2]` Drop EOL PHP `< 8.2` Compatibility Floor in `Slim 5.x` (`modernization`)

- **Target Coordinates**: `composer.json` (`require.php: "~7.4.0 || ~8.0.0 || ~8.1.0 || ~8.2.0 || ~8.3.0 || ~8.4.0 || ~8.5.0"`).
- **Recommended Implementation**: Preserve the PHP `7.4+` compatibility floor on the `4.x` maintenance branch for enterprise LTS consumers, while setting `"php": "^8.2"` in the `5.x` branch to unlock `readonly` properties, constructor property promotion, and native union/intersection types.

### 5. `[P2]` Add Unit Test for `Slim\Logger::log()` Fallback PSR-3 Logger (`testing`)

- **Target Coordinates**: `Slim/Logger.php:30` (`error_log(sprintf('%s: %s', $level, $message), 4);`) and `tests/LoggerTest.php`.
- **Diagnostic Root Cause**: PCOV Clover coverage reaches `99.4%` (`1,049 / 1,055` statements), with `Slim\Logger::log()` (`0/1` statements) and `5` defensive lines in `Slim\Routing\RouteCollector` (`69/74` statements, `93.2%`) accounting for all `6` uncovered lines in the entire framework.
- **Recommended Implementation**: Add `tests/LoggerTest.php` using `AdrianSuter\Autoload\Override` (already configured in `tests/bootstrap.php`) to intercept `Slim\error_log` and assert the formatted `"{$level}: {$message}"` payload and `message_type = 4` (`SAPI` log handler).

### 6. `[P2]` Pair Prophecy Spy Predictions with Explicit State Assertions (`testing`)

- **Target Coordinates**: `20` test methods across `tests/AppTest.php`, `tests/Middleware/ErrorMiddlewareTest.php`, `tests/Handlers/ErrorHandlerTest.php`, `tests/ResponseEmitterTest.php`, and `tests/Routing/RouteResolverTest.php`.
- **Recommended Implementation**: Pair `$prophecy->shouldBeCalled()` spy expectations with explicit `$this->assertSame()` / `$this->assertInstanceOf()` assertions on the returned `ResponseInterface` or `RoutingResults` object.

### 7. `[P2]` Adopt Native Union Types & `const CALLABLE_PATTERN` (`typing` / `code_quality`)

- **Target Coordinates**: `Slim/CallableResolver.php:34` (`public static $callablePattern`), plus `62` polymorphic methods across `Slim/CallableResolver.php`, `Slim/MiddlewareDispatcher.php`, `Slim/App.php`, and `Slim/Routing/RouteCollectorProxy.php`, and `Slim/Routing/Route.php:120` (`9`-parameter constructor).
- **Recommended Implementation**:
  1. Convert `CallableResolver::$callablePattern` to `public const CALLABLE_PATTERN = '!^([^\:]+)\:([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)$!';` (retaining a deprecated static property alias if needed in `4.x`).
  2. Replace PHPDoc-only `@param MiddlewareInterface|string|callable $middleware` annotations with native PHP 8.0+ union types (`MiddlewareInterface|string|callable` and `callable|array|string`) in `Slim 5.x`, and encapsulate `Route::__construct`'s 9 parameters using a `RouteConfiguration` value object.
