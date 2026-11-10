# Slim 4 Package & Namespace Overview

Complete API Reference Catalog for **Slim Framework `v4.15.3`** (`slim/slim`) — documenting all **72 public PHP files** (**55 classes** and **17 interfaces**) across 9 PSR-4 namespaces with strict type signatures, constructor/method parameter tables, and runnable PSR-7 / PSR-11 / PSR-15 / PSR-17 usage examples.

```drawlib align=center code=fold file=slim_package_map.png caption="Slim Framework v4.15.3 — 9-Namespace Architecture & Package Dependency Map (72 Symbols)"
from drawlib.canvas import save, setup
from drawlib.diagrams.architecture import ArchitectureDiagram, Node, NodeGroup, PhosphorIcon
from drawlib.styles import Styles

setup(width=148, height=82)

d = ArchitectureDiagram(
    node_style=Styles.Dark,
    node_text_style=Styles.DarkBold.patch(text_size=10.2),
    edge_style=Styles.Dark.patch(line_width=1.4),
    edge_text_style=Styles.Muted.patch(text_size=9.5),
    node_card_style=Styles.Neutral,
)

boot_grp = d.add(
    NodeGroup(
        "1. Bootstrap Tier (12)",
        width=38,
        height=72,
        style=Styles.PrimaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(5, 5),
)
n_factory = boot_grp.add(
    Node(
        "Slim\\Factory\n(2 Classes)",
        icon=PhosphorIcon.FACTORY,
        width=30,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(19, 48),
)
n_psr17 = boot_grp.add(
    Node(
        "Slim\\Factory\\Psr17\n(10 Classes)",
        icon=PhosphorIcon.PLUGS_CONNECTED,
        width=30,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(19, 18),
)

core_grp = d.add(
    NodeGroup(
        "2. Core & Routing Tier (22)",
        width=42,
        height=72,
        style=Styles.SecondaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(53, 5),
)
n_root = core_grp.add(
    Node(
        "Slim\\ (Core)\n(5 Classes)",
        icon=PhosphorIcon.CPU,
        width=32,
        height=15,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.2),
        card_style=Styles.PrimaryFlat,
    ),
    xy=(21, 53),
)
n_mw = core_grp.add(
    Node(
        "Slim\\Middleware\n(6 Classes)",
        icon=PhosphorIcon.STACK,
        width=32,
        height=15,
        card_style=Styles.Neutral,
    ),
    xy=(21, 33),
)
n_routing = core_grp.add(
    Node(
        "Slim\\Routing\n(11 Classes)",
        icon=PhosphorIcon.GIT_BRANCH,
        width=32,
        height=15,
        card_style=Styles.Neutral,
    ),
    xy=(21, 13),
)

err_grp = d.add(
    NodeGroup(
        "3. Handlers & Contracts (38)",
        width=38,
        height=72,
        style=Styles.Neutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(105, 5),
)
n_handlers = err_grp.add(
    Node(
        "Slim\\Handlers\n(5 Classes)",
        icon=PhosphorIcon.SLIDERS,
        width=30,
        height=13.5,
        card_style=Styles.PrimaryNeutral,
    ),
    xy=(19, 55),
)
n_renderers = err_grp.add(
    Node(
        "Slim\\Error\n(5 Classes)",
        icon=PhosphorIcon.FILE_CODE,
        width=30,
        height=13.5,
        card_style=Styles.Neutral,
    ),
    xy=(19, 39),
)
n_exc = err_grp.add(
    Node(
        "Slim\\Exception\n(11 Classes)",
        icon=PhosphorIcon.WARNING_OCTAGON,
        width=30,
        height=13.5,
        card_style=Styles.Neutral,
    ),
    xy=(19, 23),
)
n_ifaces = err_grp.add(
    Node(
        "Slim\\Interfaces\n(17 Contracts)",
        icon=PhosphorIcon.SHIELD_CHECK,
        width=30,
        height=13.5,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.0),
        card_style=Styles.AccentFlat,
    ),
    xy=(19, 8),
)

n_factory.connect(n_psr17, label="discovers")
n_factory.connect(n_root, label="creates")
n_root.connect(n_mw, label="LIFO")
n_mw.connect(n_routing, label="routes")
n_mw.connect(n_handlers, label="errors")
n_handlers.connect(n_renderers)
n_routing.connect(n_exc, label="4xx/5xx")
n_routing.connect(n_ifaces, label="contracts")

d.draw(xy=(0, 0))
save()
```

---

## Architecture & PSR Standards Compliance

Slim v4.15.3 is architected around **PHP-FIG (PSR) standards** with `declare(strict_types=1)` enforced across 100% of its 72 source files (`3,149` lines of code). Rather than bundling a monolithic HTTP message implementation or proprietary dependency injection container, Slim binds cleanly to any compliant PSR implementation:

| Standard | Composer Package | Version Constraint | Role in Slim v4.15.3 |
| :--- | :--- | :--- | :--- |
| **PHP Runtime** | `php`, `ext-json` | `~7.4.0 \|\| ~8.0.0 .. ~8.5.0` | Strict scalar type hints, return types, and JSON error/body serialization. |
| **PSR-3** | `psr/log` | `^1.1 \|\| ^2.0 \|\| ^3.0` | `LoggerInterface` injected into [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) and [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), with [`Slim\Logger`](01_app_and_factories.md#slim-logger) as fallback. |
| **PSR-7** | `psr/http-message` | `^1.1 \|\| ^2.0` | Immutable `ServerRequestInterface`, `ResponseInterface`, and `StreamInterface` flowing through every middleware and route. |
| **PSR-11** | `psr/container` | `^1.0 \|\| ^2.0` | Optional `ContainerInterface` resolved by [`AppFactory`](01_app_and_factories.md#slim-factory-appfactory), [`CallableResolver`](01_app_and_factories.md#slim-callableresolver), and [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher). |
| **PSR-15** | `psr/http-server-handler`, `psr/http-server-middleware` | `^1.0` | `RequestHandlerInterface` ([`App`](01_app_and_factories.md#slim-app), [`Route`](03_routing.md#slim-routing-route), [`RouteRunner`](03_routing.md#slim-routing-routerunner)) and `MiddlewareInterface` ([`Slim\Middleware\*`](04_middleware.md)). |
| **PSR-17** | `psr/http-factory` | `^1.1` | `ResponseFactoryInterface` and `StreamFactoryInterface` auto-discovered via [`Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider). |
| **Routing Engine** | `nikic/fast-route` | `^1.3` | Regular-expression chunked route compiler wrapped by [`Dispatcher`](03_routing.md#slim-routing-dispatcher) and [`FastRouteDispatcher`](03_routing.md#slim-routing-fastroutedispatcher). |

```drawlib align=center code=fold file=slim_psr_interoperability_pipeline.png caption="End-to-End Request Lifecycle & Catalog Module Mapping"
from drawlib.canvas import save, setup
from drawlib.smartarts import ChevronProcess, KpiCards
from drawlib.styles import Colors, Styles

setup(width=136, height=48)

proc = ChevronProcess(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Muted.patch(text_size=9.5),
    corner_angle=60.0,
    spacing=1.5,
    flat_left_end=True,
)
proc.add(
    "1. Bootstrap",
    description="AppFactory & PSR-17\n(Pages 01–02)",
    style=Styles.PrimaryNeutral,
)
proc.add(
    "2. Middleware",
    description="PSR-15 LIFO Stack\n(Page 04)",
    style=Styles.Neutral,
)
proc.add(
    "3. Routing",
    description="FastRoute & Route\n(Page 03)",
    style=Styles.SecondaryNeutral,
)
proc.add(
    "4. Invocation",
    description="Strategies & DI\n(Page 05)",
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=9.5),
)
proc.add(
    "5. Error / Emit",
    description="Renderers & 4xx/5xx\n(Pages 06–07)",
    style=Styles.Neutral,
)
proc.draw(xy=(6, 30), width=124, height=13)

white_card = Styles.Neutral.patch(shape_fill_color=Colors.White)
kpis = KpiCards(
    style=white_card,
    metric_style=Styles.DarkBold.patch(text_size=12.5),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="top_bar",
    metric_layout="top_stack",
    spacing=3.0,
)
kpis.add(
    "72 PHP Files",
    "100% Strict Types",
    "55 Classes · 17 Interfaces",
    style=Styles.PrimaryNeutral,
    metric_style=Styles.PrimaryBold.patch(text_size=12.5),
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "6 PSR-17 Bridges",
    "Zero-Config Discovery",
    "6 Vendor HTTP Adapters",
    accent_style=Styles.SecondaryFlat,
)
kpis.add(
    "6 Middlewares",
    "Concentric PSR-15",
    "Routing · Error · BodyParser",
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "17 Contracts",
    "Slim\\Interfaces\\*",
    "Segregated Tier Contracts",
    accent_style=Styles.AccentFlat,
)
kpis.draw(xy=(6, 4), width=124, height=21, columns=4)

save()
```

---

## `package` Slim\

**Root Application Kernel, Callable Resolution, LIFO Middleware Dispatcher, Response Emitter & Logger** — Detailed in [01. App & Factories](01_app_and_factories.md).

The root `Slim\` namespace houses the 5 foundational runtime classes that orchestrate the PSR-15 request handling pipeline, resolve string/container callables, and stream HTTP responses to the SAPI client:

| Symbol | Kind | Implements / Extends | Summary |
| :--- | :--- | :--- | :--- |
| [`Slim\App`](01_app_and_factories.md#slim-app) | `class` | extends [`RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), implements `RequestHandlerInterface` | Primary application entry point (`VERSION = '4.15.1'`). Registers routes/middleware, executes `handle()`, strips bodies on `HEAD` requests (RFC 2616), and emits responses in `run()`. |
| [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | `final class` | implements [`AdvancedCallableResolverInterface`](08_interfaces.md#slim-interfaces-advancedcallableresolverinterface) | Resolves closures, invokable objects, `[class, method]` arrays, and `'Class:method'` strings via PSR-11 container lookup or direct instantiation (`new $class($container)`). |
| [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | `class` | implements [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | Concentric LIFO (last-in, first-out) PSR-15 middleware stack wrapping the inner `RequestHandlerInterface` kernel (`RouteRunner`) with anonymous handler frames. |
| [`Slim\ResponseEmitter`](01_app_and_factories.md#slim-responseemitter) | `class` | — | Streams PSR-7 `ResponseInterface` headers (`Set-Cookie` multi-header safe), status line, and chunked body (`4096` bytes default) to standard output. |
| [`Slim\Logger`](01_app_and_factories.md#slim-logger) | `class` | extends `Psr\Log\AbstractLogger` | Minimal PSR-3 logger writing stringified messages to PHP's native `error_log()`. |

---

## `package` Slim\Factory

**Static Application & ServerRequest Bootstrap Factories** — Detailed in [01. App & Factories](01_app_and_factories.md).

The `Slim\Factory` namespace provides zero-boilerplate static factories that wire `Slim\App` and `ServerRequestCreatorInterface` instances using either explicit dependencies, a PSR-11 container, or automatic PSR-17 factory discovery:

| Symbol | Kind | Summary |
| :--- | :--- | :--- |
| [`Slim\Factory\AppFactory`](01_app_and_factories.md#slim-factory-appfactory) | `class` | Static builder offering `create()`, `createFromContainer()`, `determineResponseFactory()`, and static setters for pre-configuring container, factories, route collector, and `slim/http` decoration. |
| [`Slim\Factory\ServerRequestCreatorFactory`](01_app_and_factories.md#slim-factory-serverrequestcreatorfactory) | `class` | Static builder offering `create()` and `determineServerRequestCreator()` to construct a `ServerRequestInterface` from PHP superglobals (`$_SERVER`, `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES`). |

---

## `package` Slim\Factory\Psr17

**PSR-17 HTTP Factory Auto-Discovery Registry & Vendor Adapters** — Detailed in [02. PSR-17 Providers](02_psr17_providers.md).

The `Slim\Factory\Psr17` namespace contains 10 classes that decouple Slim from any single PSR-7/PSR-17 package by probing installed Composer libraries in priority order (`SlimPsr17Factory`, `HttpSoftPsr17Factory`, `NyholmPsr17Factory`, `LaminasDiactorosPsr17Factory`, `GuzzlePsr17Factory`) and optionally wrapping factories with `slim/http` decorators:

| Symbol | Kind | Implements / Extends | Backed Composer Package |
| :--- | :--- | :--- | :--- |
| [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) | `class` | implements [`Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface) | Registry maintaining the ordered list of `Psr17Factory` class names (`getFactories()`, `setFactories()`, `addFactory()`). |
| [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `abstract class` | implements [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) | Base adapter checking `class_exists()` and instantiating `ResponseFactoryInterface`, `StreamFactoryInterface`, and [`ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator). |
| [`Slim\Factory\Psr17\ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator) | `class` | implements [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Invokes a vendor creator object/class and static/instance method via `Closure::fromCallable()` to build a `ServerRequestInterface` from globals. |
| [`Slim\Factory\Psr17\SlimHttpServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-slimhttpserverrequestcreator) | `class` | implements [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Decorator wrapping an inner `ServerRequestCreatorInterface` with `Slim\Http\ServerRequest` (`slim/http`). |
| [`Slim\Factory\Psr17\SlimPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-slimpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `slim/psr7` (`Slim\Psr7\Factory\ResponseFactory`, `StreamFactory`, `ServerRequestFactory::createFromGlobals`). |
| [`Slim\Factory\Psr17\SlimHttpPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-slimhttppsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `slim/http` (`Slim\Http\Factory\DecoratedResponseFactory` wrapping `ResponseFactoryInterface` + `StreamFactoryInterface`). |
| [`Slim\Factory\Psr17\NyholmPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-nyholmpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `nyholm/psr7` & `nyholm/psr7-server` (`Nyholm\Psr7\Factory\Psr17Factory`, `Nyholm\Psr7Server\ServerRequestCreator::fromGlobals`). |
| [`Slim\Factory\Psr17\GuzzlePsr17Factory`](02_psr17_providers.md#slim-factory-psr17-guzzlepsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `guzzlehttp/psr7` (`GuzzleHttp\Psr7\HttpFactory`, `GuzzleHttp\Psr7\ServerRequest::fromGlobals`). |
| [`Slim\Factory\Psr17\LaminasDiactorosPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-laminasdiactorospsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `laminas/laminas-diactoros` (`Laminas\Diactoros\ResponseFactory`, `StreamFactory`, `ServerRequestFactory::fromGlobals`). |
| [`Slim\Factory\Psr17\HttpSoftPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-httpsoftpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `httpsoft/http-message` & `httpsoft/http-server-request` (`HttpSoft\Message\ResponseFactory`, `StreamFactory`, `ServerRequestCreator::createFromGlobals`). |

---

## `package` Slim\Routing

**Route Registration, Groups, URL Generation, FastRoute Dispatch & Execution** — Detailed in [03. Routing Subsystem](03_routing.md).

The `Slim\Routing` namespace comprises 11 classes that manage route definitions, nested route groups, URL/path generation (`RouteParser`), FastRoute regex compilation and caching, request attribute enrichment (`RouteContext`), and per-route middleware execution:

| Symbol | Kind | Implements / Extends | Summary |
| :--- | :--- | :--- | :--- |
| [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy) | `class` | implements [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | Fluent routing DSL (`get()`, `post()`, `put()`, `delete()`, `options()`, `patch()`, `any()`, `map()`, `group()`, `redirect()`) inherited by `Slim\App` and passed into group callbacks. |
| [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) | `class` | implements [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Central registry of `RouteInterface` and `RouteGroupInterface` instances, default invocation strategy, base path, and optional FastRoute cache file. |
| [`Slim\Routing\Route`](03_routing.md#slim-routing-route) | `class` | implements [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface), `RequestHandlerInterface` | Represents a single HTTP route with its own mini `MiddlewareDispatcher`, route arguments, invocation strategy, and group middleware chain. |
| [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) | `class` | implements [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Encapsulates a shared URI prefix pattern and group-level middlewares applied to all nested routes. |
| [`Slim\Routing\RouteContext`](03_routing.md#slim-routing-routecontext) | `final class` | — | Value object extracted from `ServerRequestInterface` via `RouteContext::fromRequest($request)` providing typed access to `Route`, `RouteParser`, `RoutingResults`, and `basePath`. |
| [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) | `class` | implements [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | Reverse URL generator computing `relativeUrlFor()`, `urlFor()`, and `fullUrlFor()` from named routes, placeholders, and query parameters. |
| [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) | `class` | implements [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | Bridges `RouteCollectorInterface` and `DispatcherInterface` to produce `RoutingResults` and look up matched `RouteInterface` objects. |
| [`Slim\Routing\RouteRunner`](03_routing.md#slim-routing-routerunner) | `class` | implements `RequestHandlerInterface` | Innermost kernel of `Slim\App`'s middleware stack; ensures routing has run (if `RoutingMiddleware` was omitted), populates `RouteContext::ROUTE`, and delegates to `Route::run()`. |
| [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) | `class` | implements [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | Adapter around FastRoute's `simpleDispatcher` / `cachedDispatcher` returning `RoutingResults` and allowed HTTP methods. |
| [`Slim\Routing\FastRouteDispatcher`](03_routing.md#slim-routing-fastroutedispatcher) | `class` | extends `FastRoute\Dispatcher\GroupCountBased` | Custom FastRoute dispatcher adding transparent `HEAD -> GET` fallback and deduplicated allowed-method inspection. |
| [`Slim\Routing\RoutingResults`](03_routing.md#slim-routing-routingresults) | `class` | — | Immutable dispatch outcome holding status (`NOT_FOUND = 0`, `FOUND = 1`, `METHOD_NOT_ALLOWED = 2`), route identifier (`routeX`), URL-decoded arguments, and allowed methods. |

---

## `package` Slim\Middleware

**Built-in PSR-15 Server Middlewares** — Detailed in [04. Built-in PSR-15 Middlewares](04_middleware.md).

The `Slim\Middleware` namespace provides 6 production-ready PSR-15 (`Psr\Http\Server\MiddlewareInterface`) implementations for routing, structured exception handling, request body deserialization, HTTP method tunneling, output buffering, and `Content-Length` calculation:

| Symbol | Kind | Implements | Summary |
| :--- | :--- | :--- | :--- |
| [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) | `class` | `MiddlewareInterface` | Executes route matching before downstream middlewares run, attaches `route`, `routeParser`, and `routingResults` request attributes, or throws `HttpNotFoundException` (404) / `HttpMethodNotAllowedException` (405). |
| [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) | `class` | `MiddlewareInterface` | Outermost `try / catch (Throwable)` boundary that maps exceptions to custom or default `ErrorHandlerInterface` instances (with optional subclass matching). |
| [`Slim\Middleware\BodyParsingMiddleware`](04_middleware.md#slim-middleware-bodyparsingmiddleware) | `class` | `MiddlewareInterface` | Parses `application/json`, `application/x-www-form-urlencoded`, and `application/xml` (`text/xml`) request streams into `$request->getParsedBody()`, with extensible `registerBodyParser()`. |
| [`Slim\Middleware\ContentLengthMiddleware`](04_middleware.md#slim-middleware-contentlengthmiddleware) | `class` | `MiddlewareInterface` | Measures `$response->getBody()->getSize()` after downstream handling and injects the `Content-Length` header if not already set. |
| [`Slim\Middleware\MethodOverrideMiddleware`](04_middleware.md#slim-middleware-methodoverridemiddleware) | `class` | `MiddlewareInterface` | Rewrites the HTTP method using `X-Http-Method-Override` header or `_METHOD` parsed body parameter on `POST` requests. |
| [`Slim\Middleware\OutputBufferingMiddleware`](04_middleware.md#slim-middleware-outputbufferingmiddleware) | `class` | `MiddlewareInterface` | Captures stray `echo` / `print` output via `ob_start()` and either `APPEND`s or `PREPEND`s it to the PSR-7 response stream. |

---

## `package` Slim\Handlers

**Default ErrorHandler & Route Invocation Strategies** — Detailed in [05. Error Handler & Route Strategies](05_handlers_and_strategies.md).

The `Slim\Handlers` and `Slim\Handlers\Strategies` namespaces contain the content-negotiating [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) and the 4 built-in route callback invocation strategies (`InvocationStrategyInterface`):

| Symbol | Kind | Implements | Callback Signature Dispatched |
| :--- | :--- | :--- | :--- |
| [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) | `class` | [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | Negotiates `Accept` content type (`json`, `xml`, `html`, `text/plain`), logs unhandled errors via PSR-3, adds `Allow` headers on `405`, and builds the error `ResponseInterface`. |
| [`Slim\Handlers\Strategies\RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | **Default strategy**: `function (ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface`. |
| [`Slim\Handlers\Strategies\RequestResponseArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponseargs) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Unpacks route parameters positionally: `function (ServerRequestInterface $request, ResponseInterface $response, string $arg1, ...): ResponseInterface`. |
| [`Slim\Handlers\Strategies\RequestResponseNamedArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponsenamedargs) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Passes route parameters as PHP 8+ named arguments: `function (ServerRequestInterface $request, ResponseInterface $response, string $id, ...): ResponseInterface`. |
| [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) | `class` | [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | PSR-15 style route handler (`function (ServerRequestInterface $request): ResponseInterface`), optionally injecting route args as request attributes. |

---

## `package` Slim\Error\Renderers

**Content-Negotiated Error Payload Renderers** — Detailed in [06. Error Renderers](06_error_renderers.md).

The `Slim\Error` and `Slim\Error\Renderers` namespaces format `Throwable` exceptions into `string` payloads (`application/json`, `text/html`, `application/xml`, `text/plain`) honoring the `$displayErrorDetails` flag and chained `$exception->getPrevious()` causes:

| Symbol | Kind | Implements / Extends | MIME Types Served (`ErrorHandler`) |
| :--- | :--- | :--- | :--- |
| [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `abstract class` | implements [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) | Base class resolving `HttpException` titles/descriptions vs generic 500 defaults (`$defaultErrorTitle`, `$defaultErrorDescription`). |
| [`Slim\Error\Renderers\JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `application/json`, `application/vnd.api+json` (`JSON_PRETTY_PRINT \| JSON_UNESCAPED_SLASHES`). |
| [`Slim\Error\Renderers\HtmlErrorRenderer`](06_error_renderers.md#slim-error-renderers-htmlerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `text/html`, `application/xhtml+xml` (with `htmlentities()` escaping). |
| [`Slim\Error\Renderers\XmlErrorRenderer`](06_error_renderers.md#slim-error-renderers-xmlerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `application/xml`, `text/xml` (`<![CDATA[...]]>` wrapped XML error document). |
| [`Slim\Error\Renderers\PlainTextErrorRenderer`](06_error_renderers.md#slim-error-renderers-plaintexterrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `text/plain` (and default log renderer for [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)). |

---

## `package` Slim\Exception

**Typed HTTP 4xx & 5xx Exception Hierarchy** — Detailed in [07. HTTP Exceptions](07_exceptions.md).

The `Slim\Exception` namespace defines 11 exception classes rooted at `RuntimeException` that carry structured HTTP status codes, titles, descriptions, and the triggering `ServerRequestInterface`:

| Symbol | Status Code | Default Message | Parent Class |
| :--- | :--- | :--- | :--- |
| [`Slim\Exception\HttpException`](07_exceptions.md#slim-exception-httpexception) | `500` | `''` | `RuntimeException` |
| [`Slim\Exception\HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) | *(abstract)* | *(inherited)* | [`HttpException`](07_exceptions.md#slim-exception-httpexception) |
| [`Slim\Exception\HttpBadRequestException`](07_exceptions.md#slim-exception-httpbadrequestexception) | `400` | `'Bad request.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpUnauthorizedException`](07_exceptions.md#slim-exception-httpunauthorizedexception) | `401` | `'Unauthorized.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpForbiddenException`](07_exceptions.md#slim-exception-httpforbiddenexception) | `403` | `'Forbidden.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) | `404` | `'Not found.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) | `405` | `'Method not allowed.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpGoneException`](07_exceptions.md#slim-exception-httpgoneexception) | `410` | `'Gone.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpTooManyRequestsException`](07_exceptions.md#slim-exception-httptoomanyrequestsexception) | `429` | `'Too many requests.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpInternalServerErrorException`](07_exceptions.md#slim-exception-httpinternalservererrorexception) | `500` | `'Internal server error.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpNotImplementedException`](07_exceptions.md#slim-exception-httpnotimplementedexception) | `501` | `'Not implemented.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |

---

## `package` Slim\Interfaces

**All 17 Architectural Contract Interfaces** — Detailed in [08. Contract Interfaces](08_interfaces.md).

Every subsystem in Slim 4 depends on interfaces under `Slim\Interfaces\*` rather than concrete classes, enabling drop-in replacement via `AppFactory` or a PSR-11 container:

| Contract Interface | Default Concrete Implementation(s) | Subsystem |
| :--- | :--- | :--- |
| [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | Callable & DI Resolution |
| [`AdvancedCallableResolverInterface`](08_interfaces.md#slim-interfaces-advancedcallableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | Route & Middleware Callable Resolution |
| [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | PSR-15 LIFO Stack |
| [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) | [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) (+ 6 subclasses) | PSR-17 Factory Discovery |
| [`Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface) | [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) | PSR-17 Provider Registry |
| [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | [`ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator), [`SlimHttpServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-slimhttpserverrequestcreator) | Globals Request Creation |
| [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app) | Routing DSL |
| [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) | Route Registry |
| [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | [`Slim\Routing\Route`](03_routing.md#slim-routing-route) | Route Entity |
| [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) | Route Group Prefix & Middleware |
| [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) | Reverse URL Generation |
| [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) | Route Resolution |
| [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) | FastRoute Bridge |
| [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse), [`RequestResponseArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponseargs), [`RequestResponseNamedArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponsenamedargs) | Route Callback Invocation |
| [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) | PSR-15 Route Invocation |
| [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) | Exception Handling |
| [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) | [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) (+ 4 renderers) | Content-Negotiated Rendering |
