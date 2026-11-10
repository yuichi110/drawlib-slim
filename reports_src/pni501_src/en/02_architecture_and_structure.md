# 2. Architecture & Source Code Structure

Slim Framework `v4.15.3` organizes **72 PHP source files** (**3,149 LOC**, **72 classes/interfaces**, **311 callables**, average **43.7 LOC/file**) into a **5-Tier PSR-7 / PSR-15 Micro-Kernel & Concentric Middleware Pipeline** (**94/100**, Grade **S**). Every subsystem is decoupled through **17 explicit contract interfaces** in `Slim\Interfaces\`, enabling zero-configuration PSR-17 factory auto-discovery, LIFO PSR-15 middleware composition, Nikic FastRoute regex dispatching, and content-negotiated exception rendering.

```drawlib align=center code=fold file=arch_source_tree.png caption="Slim Framework v4.15.3 — Source Directory Tree & Subsystem LOC Inventory (72 PHP Files, 3,149 LOC)"
from drawlib.canvas import save, setup
from drawlib.fonts import FontMonoSpace, FontRoboto
from drawlib.icons import phosphor
from drawlib.smartarts import Panel, Table, TreeNode
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=146, height=84, dpi=150)

text(
    (73.0, 80.2),
    "Slim Framework v4.15.3 — Physical Namespace Layout & Subsystem Inventory (72 Files · 3,149 LOC)",
    style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=12.5),
)

# Left Panel: Physical Package Hierarchy (TreeNode anchored Top-Left)
left_panel = Panel(
    "Package Tree (Slim/)",
    "PSR-4",
    style=Styles.Neutral,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.0),
    description_style=Styles.Muted.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5),
    icon=phosphor.folder_open,
    icon_style=Styles.DarkBold,
    header_variant="filled",
    header_height=7.8,
)
left_panel.draw((4.0, 4.5), width=56.0, height=72.0, align="bottom_left")

TreeNode.register_drawing_item(
    name="pkg_dir",
    location="before",
    padding_width=3.8,
    function=phosphor.folder,
    style=Styles.Primary.patch(icon_color=Colors.Primary, icon_style="fill"),
    args={"width": 2.7},
)
TreeNode.register_drawing_item(
    name="php_mod",
    location="before",
    padding_width=3.8,
    function=phosphor.file_code,
    style=Styles.Dark.patch(icon_color=Colors.Dark),
    args={"width": 2.6},
)

root = TreeNode(
    "Slim/ (72 files · 3,149 LOC)",
    text_style=Styles.DarkBold.patch(text_font=FontMonoSpace.ROBOTO_MONO_BOLD, text_size=9.6),
    line_style=Styles.Muted.patch(line_width=1.1),
    line_horizontal_margin=2.2,
    line_horizontal_length=2.4,
    line_vertical_margin=4.05,
).set_drawing_item("pkg_dir")

mod_text = Styles.Dark.patch(text_font=FontMonoSpace.ROBOTO_MONO_REGULAR, text_size=9.5)
sub_text = Styles.DarkBold.patch(text_font=FontMonoSpace.ROBOTO_MONO_BOLD, text_size=9.5)

root.add("App.php (121 LOC)", text_style=mod_text).set_drawing_item("php_mod")
root.add("MiddlewareDispatcher.php (177L)", text_style=mod_text).set_drawing_item("php_mod")
root.add("CallableResolver.php (131 LOC)", text_style=mod_text).set_drawing_item("php_mod")
root.add("ResponseEmitter & Logger (108L)", text_style=mod_text).set_drawing_item("php_mod")

fac_dir = root.add("Factory/ (12 · 457 LOC)", text_style=sub_text).set_drawing_item("pkg_dir")
fac_dir.add("AppFactory.php & Psr17/* (10)", text_style=mod_text).set_drawing_item("php_mod")

rt_dir = root.add("Routing/ (11 · 913 LOC)", text_style=sub_text).set_drawing_item("pkg_dir")
rt_dir.add("Route, RouteCollector, FastRoute*", text_style=mod_text).set_drawing_item("php_mod")

root.add("Middleware/ (6 · 393 LOC)", text_style=sub_text).set_drawing_item("pkg_dir")
root.add("Handlers/ & Error/ (10 · 469L)", text_style=sub_text).set_drawing_item("pkg_dir")
root.add("Interfaces/ (17 · 229 LOC)", text_style=sub_text).set_drawing_item("pkg_dir")
root.add("Exception/ (11 · 152 LOC)", text_style=sub_text).set_drawing_item("pkg_dir")

root.draw(xy=(7.0, 66.5))

# Right Panel: Subsystem LOC & Architectural Tier Mapping (Table anchored Top-Left)
right_panel = Panel(
    "Subsystem Inventory by Tier",
    "LOC & Core Classes",
    style=Styles.White,
    header_style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.0),
    description_style=Styles.White.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5),
    icon=phosphor.table,
    icon_style=Styles.White,
    header_variant="filled",
    header_height=7.8,
)
right_panel.draw((63.0, 4.5), width=79.0, height=72.0, align="bottom_left")

tbl_body = Styles.Dark.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5)
tbl_code = Styles.DarkBold.patch(text_font=FontMonoSpace.ROBOTO_MONO_REGULAR, text_size=9.5)
tbl_hdr = Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=10.0)

tbl = Table(
    cell_style=Styles.White,
    text_style=tbl_body,
    header_cell_style=Styles.SecondaryNeutral,
    header_text_style=tbl_hdr,
    border_style=Styles.MutedThin,
)
tbl.set_style_cell_evenodd(
    even_color=Colors.Light,
    even_text_style=tbl_body,
    odd_color=Colors.White,
    odd_text_style=tbl_body,
)
tbl.set_style_cell_header(
    background_color=Colors.SecondaryNeutral,
    text_style=tbl_hdr,
)
tbl.set_style_cell(
    background_color=Colors.Light,
    text_style=tbl_code,
    rows=[1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    columns=[0],
)

inventory_rows = [
    ["Module / Namespace", "Tier", "LOC", "Key Types & Responsibility"],
    ["App.php & Emitter", "T5", "215", "App facade, PSR-15 handle & SAPI emit"],
    ["Factory/* (2)", "T5", "221", "AppFactory & ServerRequestCreator"],
    ["MiddlewareDispatcher", "T4", "177", "LIFO concentric PSR-15 onion kernel"],
    ["Middleware/* (6)", "T4", "393", "Routing, Error, BodyParsing, Buffer"],
    ["Handlers/ & Error/", "T4", "386", "ErrorHandler + HTML/JSON/XML render"],
    ["Routing/* (11)", "T3", "913", "RouteCollector, Route, FastRoute*"],
    ["Handlers/Strategies", "T3", "83", "RequestResponse, NamedArgs, Handler"],
    ["CallableResolver.php", "T2", "145", "PSR-11 DI & 'class:method' bridge"],
    ["Factory/Psr17/* (10)", "T2", "236", "Auto-discovery for 6 PSR-7 vendors"],
    ["Interfaces & Exc (28)", "T1", "381", "17 contracts & 11 HTTP exceptions"],
]

tbl.draw_flexible(
    xy=(65.5, 66.5),
    column_widths=[24.0, 6.0, 7.0, 37.0],
    row_heights=[5.8] + [5.4] * 10,
    data=inventory_rows,
    align="top_left",
)

save()
```

---

## 2.1 System Profile, PSR Dependency Stack & External Integrations

Slim Framework `v4.15.3` operates as a pure, standards-compliant **PHP library micro-framework** (`runtime_types = ["library"]`, PHP `~7.4.0 || ~8.0.0 .. ~8.5.0`) with `declare(strict_types=1)` across 100% of source files. Instead of bundling a monolithic HTTP message implementation or proprietary dependency injection container, Slim depends strictly on **6 official PHP-FIG PSR interface packages** plus `nikic/fast-route`:

| Runtime Dependency (`composer.json`) | Version Constraint | Architectural Role in Slim `v4.15.3` | Primary Consumer Classes |
| :--- | :--- | :--- | :--- |
| `psr/http-message` | `^1.1 \|\| ^2.0` | PSR-7 immutable `ServerRequestInterface`, `ResponseInterface`, `StreamInterface`, and `UriInterface`. | `App`, `ResponseEmitter`, `Middleware/*`, `Routing/*`, `Handlers/*` |
| `psr/http-factory` | `^1.1` | PSR-17 `ResponseFactoryInterface` and `StreamFactoryInterface` for zero-coupling response synthesis. | `AppFactory`, `RouteCollector`, `Route`, `ErrorHandler`, `Psr17/*` |
| `psr/http-server-handler` | `^1.0` | PSR-15 `RequestHandlerInterface` (`handle(ServerRequestInterface): ResponseInterface`). | `App`, `MiddlewareDispatcher`, `RouteRunner`, `Route`, `Strategies/RequestHandler` |
| `psr/http-server-middleware` | `^1.0` | PSR-15 `MiddlewareInterface` (`process(ServerRequestInterface, RequestHandlerInterface)`). | `MiddlewareDispatcher`, `RoutingMiddleware`, `ErrorMiddleware`, `BodyParsingMiddleware` |
| `psr/container` | `^1.0 \|\| ^2.0` | PSR-11 `ContainerInterface` (`has()`, `get()`) for resolving controllers, middlewares, and services. | `AppFactory`, `CallableResolver`, `MiddlewareDispatcher`, `RouteCollector` |
| `psr/log` | `^1.1 \|\| ^2.0 \|\| ^3.0` | PSR-3 `LoggerInterface` and `AbstractLogger` for structured exception reporting. | `ErrorMiddleware`, `ErrorHandler`, `Logger` |
| `nikic/fast-route` | `^1.3` | High-speed regex route compilation (`RouteParser\Std`, `DataGenerator\GroupCountBased`, `Dispatcher\GroupCountBased`). | `Dispatcher`, `FastRouteDispatcher`, `RouteParser` |

### External Integration Boundaries

1. **PSR-17 / PSR-7 Auto-Discovery Providers (`Slim\Factory\Psr17\Psr17FactoryProvider`)**: Automatically detects and wires any installed PSR-7/PSR-17 implementation in priority order: `Slim\Psr7` (`slim/psr7`), `Nyholm\Psr7` (`nyholm/psr7` + `nyholm/psr7-server`), `GuzzleHttp\Psr7` (`guzzlehttp/psr7`), `Laminas\Diactoros` (`laminas/laminas-diactoros`), `HttpSoft\Message` (`httpsoft/http-message`), and optional `Slim\Http` (`slim/http`) message decorators.
2. **PSR-11 Dependency Injection Containers**: `AppFactory::createFromContainer($container)`, `CallableResolver`, and `MiddlewareDispatcher` resolve route callables, `'class:method'` notation, and invokable middleware services from PHP-DI, League Container, Symfony DependencyInjection, or Laminas ServiceManager.
3. **PHP SAPI & Long-Running Worker Runtimes**: `ResponseEmitter` streams status lines, multi-value HTTP headers (`Set-Cookie` safe), and chunked bodies to standard PHP-FPM/CLI SAPIs, while `App::handle(ServerRequestInterface)` supports stateful worker loops (RoadRunner, Swoole, FrankenPHP) without global state leakage.

---

## 2.2 Five-Tier PSR Architecture & Thermal Risk Score Overlay

Slim enforces a strict top-down dependency hierarchy across **five architectural tiers** (`Tier 5` down to `Tier 1`). Figure 2.2 overlays PNI501's pre-sorted `module_hotspots` risk scores (`CallableResolver.php=0.14`, `MiddlewareDispatcher.php=0.12`, `RouteParser.php=0.12`, and `0.06` across `Route.php`, `ErrorHandler.php`, `RouteCollector.php`, `AppFactory.php`, and `BodyParsingMiddleware.php`) directly onto the 5-Tier UML component dependency graph.

```drawlib align=center code=fold file=arch_layer_thermal_dag.png caption="5-Tier PSR Component Dependency DAG & Module Hotspot Thermal Overlay (CallableResolver=0.14, MiddlewareDispatcher=0.12, RouteParser=0.12)"
from drawlib.canvas import save, setup
from drawlib.charts.heatmap import HeatmapOverlay
from drawlib.diagrams.class_diagram import ClassDiagram, ClassNode
from drawlib.fonts import FontMonoSpace, FontRoboto
from drawlib.lines import lines
from drawlib.shapes import rectangle
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=146, height=118, dpi=150)

text(
    (73.0, 113.5),
    "5-Tier Component Dependency DAG & Module Hotspot Thermal Overlay (Slim Framework v4.15.3)",
    style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=12.5),
)

# Horizontal tier swimlanes & left-hand tier badges (Z-Layer 1)
tier_specs = [
    (101.0, "Tier 5", "App & Bootstrap"),
    (81.0, "Tier 4", "PSR-15 & Error"),
    (61.0, "Tier 3", "FastRoute Engine"),
    (41.0, "Tier 2", "DI & PSR-17"),
    (21.0, "Tier 1", "Contracts & Exc"),
]
lane_style = Styles.Neutral.patch(
    shape_fill_color=Colors.Gray1.patch(alpha=0.45),
    shape_line_color=Colors.Gray3,
    shape_line_width=0.8,
    shape_r=1.5,
)
badge_style = Styles.SecondaryNeutral.patch(shape_r=1.5, shape_line_width=1.0)

for cy, t_num, t_sub in tier_specs:
    rectangle((87.5, cy), width=110.0, height=15.0, style=lane_style)
    rectangle((16.5, cy), width=22.0, height=12.4, style=badge_style)
    text(
        (16.5, cy + 2.3),
        t_num,
        style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=10.5),
    )
    text(
        (16.5, cy - 2.4),
        t_sub,
        style=Styles.Muted.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.5),
    )

# 5-Tier ClassDiagram (Z-Layer 2)
cd = ClassDiagram(
    width=146.0,
    height=118.0,
    node_style=Styles.Neutral.patch(
        shape_fill_color=Colors.White,
        shape_line_color=Colors.Gray6,
        text_color=Colors.Dark,
        text_font=FontMonoSpace.ROBOTO_MONO_REGULAR,
        text_size=9.5,
    ),
    header_style=Styles.PrimaryNeutral.patch(
        shape_line_color=Colors.Gray6,
        text_color=Colors.Dark,
        text_font=FontMonoSpace.ROBOTO_MONO_BOLD,
        text_size=9.8,
    ),
    edge_style=Styles.Muted.patch(line_width=1.1),
    edge_text_style=Styles.Dark.patch(text_size=9.5),
)

# Tier 5 (y=101)
n_app = cd.add(
    ClassNode("Slim\\App (121L)", width=32.0).add_method("run / handle", "req", "Response"),
    xy=(52.0, 101.0),
)
n_fac = cd.add(
    ClassNode("AppFactory (160L · 0.06)", width=35.0).add_method("create", "container", "App"),
    xy=(92.0, 101.0),
)
n_emit = cd.add(
    ClassNode("ResponseEmitter (94L)", width=30.0).add_method("emit", "resp", "void"),
    xy=(126.5, 101.0),
)

# Tier 4 (y=81)
n_mwd = cd.add(
    ClassNode("MiddlewareDispatcher (0.12)", width=36.0).add_method("addDeferred", "mw", "self"),
    xy=(52.0, 81.0),
)
n_err = cd.add(
    ClassNode("ErrorHandler (187L · 0.06)", width=34.0).add_method("__invoke", "req, ex", "Resp"),
    xy=(92.0, 81.0),
)
n_body = cd.add(
    ClassNode("BodyParsingMW (0.06)", width=30.0).add_method("process", "req, hdl", "Resp"),
    xy=(126.5, 81.0),
)

# Tier 3 (y=61)
n_rcol = cd.add(
    ClassNode("RouteCollector (0.06)", width=34.0).add_method("map / group", "pat", "Route"),
    xy=(52.0, 61.0),
)
n_route = cd.add(
    ClassNode("Slim\\Routing\\Route (0.06)", width=35.0).add_method("run", "req", "Response"),
    xy=(92.0, 61.0),
)
n_rpar = cd.add(
    ClassNode("RouteParser (73L · 0.12)", width=31.0).add_method("relativeUrlFor", "name", "str"),
    xy=(126.5, 61.0),
)

# Tier 2 (y=41)
n_cres = cd.add(
    ClassNode("CallableResolver (0.14)", width=36.0).add_method("resolve", "toResolve", "callable"),
    xy=(64.0, 41.0),
)
n_psr17 = cd.add(
    ClassNode("Psr17FactoryProvider (236L)", width=38.0).add_method("getFactories", "", "array"),
    xy=(114.0, 41.0),
)

# Tier 1 (y=21)
n_iface = cd.add(
    ClassNode("Slim\\Interfaces\\* (17)", width=38.0).add_method("DispatcherInterface", "", "Results"),
    xy=(64.0, 21.0),
)
n_exc = cd.add(
    ClassNode("Slim\\Exception\\* (11)", width=38.0).add_method("HttpException", "req", "400..501"),
    xy=(114.0, 21.0),
)

cd.draw(xy=(0.0, 0.0))

# Downward dependency arrows between tiers
dep_arrow = Styles.Dark.patch(line_color=Colors.Gray7, line_width=1.15)
for x0, y0, x1, y1 in [
    (52.0, 95.0, 52.0, 87.2),
    (92.0, 95.0, 58.0, 87.2),
    (92.0, 95.0, 114.0, 47.2),
    (52.0, 74.8, 52.0, 67.2),
    (52.0, 74.8, 92.0, 67.2),
    (92.0, 74.8, 114.0, 27.2),
    (52.0, 54.8, 64.0, 47.2),
    (92.0, 54.8, 64.0, 47.2),
    (126.5, 54.8, 64.0, 27.2),
    (64.0, 34.8, 64.0, 27.2),
    (114.0, 34.8, 64.0, 27.2),
]:
    lines([(x0, y0), (x1, y1)], arrow_head="->", style=dep_arrow)

# HeatmapOverlay with exact pre-sorted module_hotspots risk_score values (Z-Layer 3)
overlay = HeatmapOverlay(
    styles=[Styles.PrimaryNeutral, Styles.WarningFlat, Styles.DangerFlat],
    mode="smooth",
    min_value=0.0,
    max_value=0.20,
    max_alpha=0.42,
)
overlay.add_spot(n_cres, value=0.14, radius=14.0)
overlay.add_spot(n_mwd, value=0.12, radius=13.5)
overlay.add_spot(n_rpar, value=0.12, radius=13.0)
overlay.add_spot(n_route, value=0.06, radius=11.0)
overlay.add_spot(n_err, value=0.06, radius=11.0)
overlay.add_spot(n_rcol, value=0.06, radius=11.0)
overlay.add_spot(n_fac, value=0.06, radius=11.0)
overlay.add_spot(n_body, value=0.06, radius=11.0)
overlay.draw(xy=(0.0, 0.0))
overlay.draw_colorbar(
    xy=(50.0, 6.2),
    text_style=Styles.DarkBold.patch(text_size=9.8),
    length=48.0,
    thickness=2.2,
    label="PNI501 Module Hotspot Risk Score (0.00 – 0.20)",
)

save()
```

### Five-Tier Boundary & Hotspot Analysis

| Architectural Tier | Representative Source Paths | Allowed Dependencies | Boundary & Hotspot Assessment |
| :--- | :--- | :--- | :--- |
| **Tier 5: Application Facade, Bootstrap Factories & SAPI Emitter** | `Slim/App.php` (`121` LOC), `Slim/ResponseEmitter.php` (`94` LOC), `Slim/Factory/AppFactory.php` (`160` LOC, `risk=0.06`), `Slim/Factory/ServerRequestCreatorFactory.php` (`61` LOC) | `Tier 4`, `Tier 3`, `Tier 2`, `Tier 1` | **100% Clean**: `App` extends `RouteCollectorProxy` and implements `RequestHandlerInterface`, delegating cleanly downward. |
| **Tier 4: PSR-15 Middleware Stack & Content-Negotiated Error Subsystem** | `Slim/MiddlewareDispatcher.php` (`177` LOC, `risk=0.12`), `Slim/Middleware/*` (`6` files, `393` LOC; `BodyParsingMiddleware` `risk=0.06`), `Slim/Handlers/ErrorHandler.php` (`187` LOC, `risk=0.06`), `Slim/Error/Renderers/*` (`5` files, `199` LOC) | `Tier 3`, `Tier 2`, `Tier 1` | **Hotspot `0.12`**: `MiddlewareDispatcher::addDeferred` (`cognitive=26`) wraps deferred string/callable middlewares in an inline anonymous `RequestHandlerInterface`. |
| **Tier 3: FastRoute Routing Engine & Handler Invocation Strategies** | `Slim/Routing/Route.php` (`192` LOC, `risk=0.06`), `RouteCollector.php` (`174` LOC, `risk=0.06`), `RouteCollectorProxy.php` (`103` LOC), `RouteParser.php` (`73` LOC, `risk=0.12`), `FastRouteDispatcher.php` (`64` LOC), `RoutingResults.php` (`59` LOC), `Strategies/*` (`4` files, `83` LOC) | `Tier 2`, `Tier 1` | **Hotspot `0.12`**: `RouteParser::relativeUrlFor` (`cognitive=13`) computes relative path segments; `Route::__construct` accepts `9` collaborators. |
| **Tier 2: PSR-17 Provider Adapters & Container Callable Resolver** | `Slim/CallableResolver.php` (`131` LOC, `risk=0.14`), `Slim/Logger.php` (`14` LOC), `Slim/Factory/Psr17/*` (`10` files, `236` LOC) | `Tier 1` | **Hotspot `0.14`**: `CallableResolver` bridges PSR-11 containers and `'class:method'` strings (`$callablePattern` static regex + PHP 7.4 untyped `$toResolve`). |
| **Tier 1: Core Interfaces & HTTP Specialized Exception Hierarchy** | `Slim/Interfaces/*` (`17` files, `229` LOC), `Slim/Exception/*` (`11` files, `152` LOC: `400`, `401`, `403`, `404`, `405`, `410`, `429`, `500`, `501`) | `[]` *(Leaf Tier)* | **1 Cross-Layer Cycle**: `Slim\Interfaces\DispatcherInterface` imports concrete `Slim\Routing\RoutingResults` (`Tier 3`). |

---

## 2.3 Core Runtime Execution Flows & Concurrency Model

```drawlib align=center code=fold file=arch_execution_flows.png caption="Slim Framework v4.15.3 — Three Core Runtime Execution Pipelines (Bootstrap, LIFO PSR-15 Dispatch, Exception Rendering)"
from drawlib.canvas import save, setup
from drawlib.fonts import FontRoboto
from drawlib.icons import phosphor
from drawlib.smartarts import Panel, Roadmap
from drawlib.styles import Styles

setup(width=146, height=74, dpi=150)

frame = Panel(
    "Slim Framework v4.15.3 — Core Runtime Execution Lifecycles",
    "PSR-7 + PSR-15 + FastRoute",
    style=Styles.White,
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_font=FontRoboto.ROBOTO_BOLD, text_size=11.5),
    description_style=Styles.Muted.patch(text_font=FontRoboto.ROBOTO_REGULAR, text_size=9.8),
    icon=phosphor.pulse,
    icon_style=Styles.DarkBold,
    header_variant="filled",
    header_height=8.2,
)
frame.draw((4.0, 4.0), width=138.0, height=66.0, align="bottom_left")
inner_xy, inner_w, inner_h = frame.get_content_box(
    (4.0, 4.0),
    width=138.0,
    height=66.0,
    padding=(3.5, 3.0),
    align="bottom_left",
)

rm = Roadmap(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=10.8),
    description_style=Styles.Dark.patch(text_size=9.6),
    spine_style=Styles.PrimaryBold,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_size=10.2),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    curve_bend=0.0,
    card_shape="rounded_rect",
    spacing=2.6,
)

rm.add(
    "Flow 1: Zero-Configuration PSR-17 Auto-Discovery & App Bootstrap",
    "AppFactory::determineResponseFactory() scans 6 PSR-17 providers -> seeds MiddlewareDispatcher",
    badge_text="F1",
    icon=phosphor.rocket_launch,
    style=Styles.PrimaryNeutral,
)
rm.add(
    "Flow 2: Concentric PSR-15 Middleware Execution, FastRoute & Route Invocation",
    "ServerRequestCreator -> ErrorMW -> RoutingMW (FastRoute) -> RouteRunner -> Route::run()",
    badge_text="F2",
    icon=phosphor.arrows_clockwise,
    style=Styles.Neutral,
    badge_style=Styles.SecondaryFlat,
)
rm.add(
    "Flow 3: Exception Interception & Content-Negotiated Error Rendering",
    "ErrorMiddleware catches Throwable -> ErrorHandler logs via PSR-3 -> JSON/XML/HTML/Text",
    badge_text="F3",
    icon=phosphor.shield_warning,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.AccentFlat,
)

rm.draw(xy=inner_xy, width=inner_w, height=inner_h, align="bottom_left", scale=1.0)

save()
```

### Detailed Execution Flow Walkthrough

1. **Flow 1 — Zero-Configuration PSR-17 Auto-Discovery & App Bootstrap (`AppFactory::create` / `createFromContainer`)**:
   - `AppFactory::determineResponseFactory()` iterates through `Psr17FactoryProvider::$factories` (`SlimPsr17Factory`, `NyholmPsr17Factory`, `GuzzlePsr17Factory`, `LaminasDiactorosPsr17Factory`, `HttpSoftPsr17Factory`) until it locates an installed PSR-17 `ResponseFactoryInterface`.
   - `AppFactory` instantiates `CallableResolver`, `RouteCollector` (defaulting to the `RequestResponse` invocation strategy), `RouteResolver`, `RouteRunner`, and `MiddlewareDispatcher` seeded with `RouteRunner` as its innermost kernel.
   - Application bootstrap code registers routes (`$app->get()`, `$app->post()`, `$app->group()`) on `RouteCollectorProxy` and pushes PSR-15 middlewares (`$app->add()`, `$app->addBodyParsingMiddleware()`, `$app->addRoutingMiddleware()`, `$app->addErrorMiddleware()`) onto `MiddlewareDispatcher`'s LIFO stack.
2. **Flow 2 — Concentric PSR-15 Middleware Execution, FastRoute Matching & Route Invocation (`App::run` / `App::handle`)**:
   - When `$request` is `null` in `App::run()`, `ServerRequestCreatorFactory::create()->createServerRequestFromGlobals()` synthesizes an immutable PSR-7 `ServerRequestInterface` from PHP superglobals.
   - `MiddlewareDispatcher::handle($request)` traverses the LIFO middleware onion from outermost (typically `ErrorMiddleware`) inward through `RoutingMiddleware` and `BodyParsingMiddleware`.
   - `RoutingMiddleware::performRouting()` invokes `RouteResolver::computeRoutingResults()` -> `Dispatcher` -> `FastRouteDispatcher`, attaching `RouteContext::ROUTE`, `ROUTE_PARSER`, and `ROUTING_RESULTS` attributes to `$request` (or throwing `HttpNotFoundException` / `HttpMethodNotAllowedException`).
   - At the center of the application middleware stack, `RouteRunner::handle()` resolves `RouteGroup` middlewares and delegates to `Route::run()`, which executes route-specific middlewares before invoking the matched callable via `InvocationStrategyInterface` (`RequestResponse`, `RequestResponseArgs`, `RequestResponseNamedArgs`, or `RequestHandler`).
   - Finally, `ResponseEmitter::emit($response)` writes the HTTP status line, headers, and chunked body stream (`responseChunkSize = 4096`) to the PHP SAPI output buffer.
3. **Flow 3 — Exception Interception & Content-Negotiated Error Rendering (`ErrorMiddleware::process`)**:
   - `ErrorMiddleware::process()` catches any `Throwable` inside its `try/catch` boundary and delegates to `ErrorMiddleware::handleException($request, $exception)`.
   - `ErrorMiddleware` looks up a registered exact-match or subclass-match handler in `$this->handlers`, falling back to the default `ErrorHandler`.
   - `ErrorHandler::__invoke()` determines the HTTP status code (`400..501` from `HttpException` or `500` for generic `Throwable`), logs the error via PSR-3 `LoggerInterface` when `$logErrors` is enabled, and inspects the request `Accept` header via `determineRenderer()` to serialize the payload through `JsonErrorRenderer`, `XmlErrorRenderer`, `HtmlErrorRenderer`, or `PlainTextErrorRenderer` with CORS and `Allow` headers preserved.
