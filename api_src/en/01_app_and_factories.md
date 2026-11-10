# Core Application & Bootstrap Factories

Reference for the 7 core runtime and bootstrap classes in `Slim\` and `Slim\Factory\`: [`Slim\App`](#slim-app), [`Slim\Factory\AppFactory`](#slim-factory-appfactory), [`Slim\Factory\ServerRequestCreatorFactory`](#slim-factory-serverrequestcreatorfactory), [`Slim\CallableResolver`](#slim-callableresolver), [`Slim\MiddlewareDispatcher`](#slim-middlewaredispatcher), [`Slim\ResponseEmitter`](#slim-responseemitter), and [`Slim\Logger`](#slim-logger).

```drawlib align=center code=fold file=core_app_api_surface.png caption="Slim\\App & Slim\\Factory\\* — Core Kernel Composition & Collaborator Graph"
from drawlib.canvas import save, setup
from drawlib.diagrams.architecture import ArchitectureDiagram, Node, NodeGroup, PhosphorIcon
from drawlib.styles import Styles

setup(width=148, height=78)

d = ArchitectureDiagram(
    node_style=Styles.Dark,
    node_text_style=Styles.DarkBold.patch(text_size=10.2),
    edge_style=Styles.Dark.patch(line_width=1.4),
    edge_text_style=Styles.Muted.patch(text_size=9.5),
    node_card_style=Styles.Neutral,
)

fac_grp = d.add(
    NodeGroup(
        "Slim\\Factory (Static Bootstrap)",
        width=40,
        height=68,
        style=Styles.PrimaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.5, halign="left", valign="top"),
    ),
    xy=(4, 5),
)
app_fac = fac_grp.add(
    Node(
        "AppFactory\n::create()",
        icon=PhosphorIcon.FACTORY,
        width=32,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(20, 46),
)
req_fac = fac_grp.add(
    Node(
        "ServerRequestCreator\nFactory::create()",
        icon=PhosphorIcon.GLOBE,
        width=32,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(20, 18),
)

core_grp = d.add(
    NodeGroup(
        "Slim\\ (Application Kernel & Collaborators)",
        width=92,
        height=68,
        style=Styles.SecondaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.5, halign="left", valign="top"),
    ),
    xy=(52, 5),
)
app_node = core_grp.add(
    Node(
        "Slim\\App\n(RouteCollectorProxy)",
        icon=PhosphorIcon.CPU,
        width=32,
        height=17,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.2),
        card_style=Styles.PrimaryFlat,
    ),
    xy=(21, 46),
)
emitter_node = core_grp.add(
    Node(
        "ResponseEmitter\n::emit(response)",
        icon=PhosphorIcon.BROADCAST,
        width=32,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(21, 18),
)
mw_disp = core_grp.add(
    Node(
        "MiddlewareDispatcher\n(LIFO Stack)",
        icon=PhosphorIcon.STACK,
        width=34,
        height=14,
        card_style=Styles.PrimaryNeutral,
    ),
    xy=(69, 52),
)
resolver = core_grp.add(
    Node(
        "CallableResolver\n('Class:method' / DI)",
        icon=PhosphorIcon.PLUGS_CONNECTED,
        width=34,
        height=14,
        card_style=Styles.Neutral,
    ),
    xy=(69, 32),
)
logger = core_grp.add(
    Node(
        "Slim\\Logger\n(PSR-3 error_log)",
        icon=PhosphorIcon.TERMINAL_WINDOW,
        width=34,
        height=14,
        card_style=Styles.Neutral,
    ),
    xy=(69, 12),
)

app_fac.connect(app_node, label="wires")
req_fac.connect(app_node, label="Request")
app_node.connect(mw_disp, label="handle()")
app_node.connect(emitter_node, label="run()")
mw_disp.connect(resolver, label="resolves")
app_node.connect(logger, label="logs")

d.draw(xy=(0, 0))
save()
```

---

## `class` Slim\App

- **Source File**: `Slim/App.php`
- **Namespace**: `Slim`
- **Extends**: [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy) (which implements [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface))
- **Implements**: `Psr\Http\Server\RequestHandlerInterface`
- **Template Annotation**: `@template TContainerInterface of (ContainerInterface|null)`

`Slim\App` is the central application kernel in Slim 4. By extending [`RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), it exposes all route registration methods (`get()`, `post()`, `put()`, `delete()`, `options()`, `patch()`, `any()`, `map()`, `group()`, `redirect()`) directly on `$app`, while implementing PSR-15's `RequestHandlerInterface` so the entire application can be composed inside outer PSR-15 runners or invoked directly in tests via `$app->handle($request)`.

### PHP Class Signature (`Slim\App`)

```php
namespace Slim;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Psr\Log\LoggerInterface;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\MiddlewareDispatcherInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteResolverInterface;
use Slim\Middleware\BodyParsingMiddleware;
use Slim\Middleware\ErrorMiddleware;
use Slim\Middleware\RoutingMiddleware;
use Slim\Routing\RouteCollectorProxy;

class App extends RouteCollectorProxy implements RequestHandlerInterface
{
    public const VERSION = '4.15.1';

    protected RouteResolverInterface $routeResolver;
    protected MiddlewareDispatcherInterface $middlewareDispatcher;

    public function __construct(
        ResponseFactoryInterface $responseFactory,
        ?ContainerInterface $container = null,
        ?CallableResolverInterface $callableResolver = null,
        ?RouteCollectorInterface $routeCollector = null,
        ?RouteResolverInterface $routeResolver = null,
        ?MiddlewareDispatcherInterface $middlewareDispatcher = null
    );

    public function getRouteResolver(): RouteResolverInterface;
    public function getMiddlewareDispatcher(): MiddlewareDispatcherInterface;
    public function add($middleware): self;
    public function addMiddleware(MiddlewareInterface $middleware): self;
    public function addRoutingMiddleware(): RoutingMiddleware;
    public function addErrorMiddleware(
        bool $displayErrorDetails,
        bool $logErrors,
        bool $logErrorDetails,
        ?LoggerInterface $logger = null
    ): ErrorMiddleware;
    public function addBodyParsingMiddleware(array $bodyParsers = []): BodyParsingMiddleware;
    public function run(?ServerRequestInterface $request = null): void;
    public function handle(ServerRequestInterface $request): ResponseInterface;
}
```

### Constants & Properties (`Slim\App`)

| Member | Visibility & Type | Default / Value | Description |
| :--- | :--- | :--- | :--- |
| `VERSION` | `public const string` | `'4.15.1'` | Version constant defined in `Slim\App`. |
| `$routeResolver` | `protected RouteResolverInterface` | `new RouteResolver($this->routeCollector)` | Resolves URI/method routing results against the `RouteCollector`. |
| `$middlewareDispatcher` | `protected MiddlewareDispatcherInterface` | `new MiddlewareDispatcher($routeRunner, ...)` | LIFO middleware stack seeded with an internal [`RouteRunner`](03_routing.md#slim-routing-routerunner) kernel. |
| `$responseFactory` | `protected ResponseFactoryInterface` | *(Inherited from `RouteCollectorProxy`)* | PSR-17 factory used to create fresh `ResponseInterface` objects and empty `HEAD` streams. |
| `$callableResolver` | `protected CallableResolverInterface` | *(Inherited from `RouteCollectorProxy`)* | Resolves route and middleware callables. |
| `$container` | `protected ?ContainerInterface` | *(Inherited from `RouteCollectorProxy`)* | Optional PSR-11 dependency injection container. |
| `$routeCollector` | `protected RouteCollectorInterface` | *(Inherited from `RouteCollectorProxy`)* | Underlying route registry (`Slim\Routing\RouteCollector` by default). |

### Constructor & Methods (`Slim\App`)

| Method | Parameters | Return Type | Behavior & Notes |
| :--- | :--- | :--- | :--- |
| `__construct(...)` | `ResponseFactoryInterface $responseFactory`, `?ContainerInterface $container = null`, `?CallableResolverInterface $callableResolver = null`, `?RouteCollectorInterface $routeCollector = null`, `?RouteResolverInterface $routeResolver = null`, `?MiddlewareDispatcherInterface $middlewareDispatcher = null` | `void` | Initializes `RouteCollectorProxy`, creates default `CallableResolver`, `RouteResolver`, and `RouteRunner` if omitted, and seeds `$middlewareDispatcher` with `$routeRunner`. |
| `getRouteResolver()` | *(none)* | [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | Returns the active route resolver instance. |
| `getMiddlewareDispatcher()` | *(none)* | [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | Returns the application's LIFO middleware dispatcher. |
| `add($middleware)` | `MiddlewareInterface\|string\|callable $middleware` | `self` (`App<TContainerInterface>`) | Pushes a PSR-15 middleware instance, container/class string, or callable onto the outer layer of the LIFO middleware stack. |
| `addMiddleware($middleware)` | `MiddlewareInterface $middleware` | `self` (`App<TContainerInterface>`) | Pushes a typed `Psr\Http\Server\MiddlewareInterface` instance onto the middleware stack. |
| `addRoutingMiddleware()` | *(none)* | [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) | Instantiates `RoutingMiddleware($this->getRouteResolver(), $this->getRouteCollector()->getRouteParser())`, registers it via `$this->add()`, and returns it so you can position routing explicitly before middlewares that read `RouteContext`. |
| `addErrorMiddleware(...)` | `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails`, `?LoggerInterface $logger = null` | [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) | Instantiates `ErrorMiddleware`, registers it via `$this->add()` (should be added **last** so it executes **outermost**), and returns it for custom handler/renderer configuration. |
| `addBodyParsingMiddleware(...)` | `callable[] $bodyParsers = []` | [`BodyParsingMiddleware`](04_middleware.md#slim-middleware-bodyparsingmiddleware) | Instantiates `BodyParsingMiddleware($bodyParsers)`, registers it via `$this->add()`, and returns it. |
| `run($request)` | `?ServerRequestInterface $request = null` | `void` | Auto-creates `$request` from globals via `ServerRequestCreatorFactory::create()` if `null`, invokes `$this->handle($request)`, and emits the response via `new ResponseEmitter()`. |
| `handle($request)` | `ServerRequestInterface $request` | `ResponseInterface` | Executes `$this->middlewareDispatcher->handle($request)`. If `strtoupper($request->getMethod()) === 'HEAD'`, replaces the body with an empty stream (`$this->responseFactory->createResponse()->getBody()`) for RFC 2616 §9.4 compliance. |

*(Inherited routing proxy methods `get()`, `post()`, `put()`, `delete()`, `options()`, `patch()`, `any()`, `map()`, `group()`, `redirect()`, `getBasePath()`, `setBasePath()`, `getResponseFactory()`, `getCallableResolver()`, `getContainer()`, and `getRouteCollector()` are documented under [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy).)*

```drawlib align=center code=fold file=app_run_handle_sequence.png caption="Slim\\App::run() & handle() — Bootstrap, LIFO Dispatch, HEAD Stripping & Emission Sequence"
from drawlib.canvas import save, setup
from drawlib.diagrams.sequence import Participant, PhosphorIcon, SequenceDiagram
from drawlib.styles import Styles

setup(width=144, height=96)

sd = SequenceDiagram(
    node_style=Styles.Dark,
    node_text_style=Styles.DarkBold.patch(text_size=10.0),
    edge_style=Styles.Dark.patch(line_width=1.4),
    edge_text_style=Styles.Dark.patch(text_size=9.5),
    node_card_style=Styles.Neutral,
    col_width=34.0,
    step_y=6.5,
)

p_client = sd.add(Participant("index.php", icon=PhosphorIcon.FILE_CODE, width=24, card_style=Styles.PrimaryNeutral))
p_app = sd.add(
    Participant(
        "Slim\\App",
        icon=PhosphorIcon.CPU,
        width=24,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.0),
        card_style=Styles.PrimaryFlat,
    )
)
p_mw = sd.add(Participant("MiddlewareDispatcher", icon=PhosphorIcon.STACK, width=28, card_style=Styles.SecondaryNeutral))
p_emit = sd.add(Participant("ResponseEmitter", icon=PhosphorIcon.BROADCAST, width=26, card_style=Styles.Neutral))

p_client.request(p_app, "1. run(request = null)")
p_app.request(p_app, "2. createServerRequestFromGlobals()")
p_app.request(p_mw, "3. handle(ServerRequestInterface)")
p_mw.reply(p_app, "4. ResponseInterface (LIFO + RouteRunner)")
p_app.request(p_app, "5. If HEAD -> withBody(emptyStream)")
p_app.request(p_emit, "6. emit(response): headers, status, body")
p_emit.reply(p_client, "7. Stream HTTP Response to SAPI")

sd.draw(xy=(72, 48), align="center")
save()
```

### Usage Example (`Slim\App`)

```php
<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

$app = AppFactory::create();

// 1. Parse JSON / form / XML request bodies
$app->addBodyParsingMiddleware();

// 2. Explicit routing middleware (placed before custom middlewares that inspect RouteContext)
$app->addRoutingMiddleware();

// 3. Outermost error middleware (added last -> executed first in LIFO order)
$errorMiddleware = $app->addErrorMiddleware(true, true, true);

$app->get('/health', function (Request $request, Response $response): Response {
    $payload = json_encode(['status' => 'ok', 'slim' => $this::VERSION], JSON_THROW_ON_ERROR);
    $response->getBody()->write($payload);
    return $response->withHeader('Content-Type', 'application/json');
});

$app->run();
```

---

## `class` Slim\Factory\AppFactory

- **Source File**: `Slim/Factory/AppFactory.php`
- **Namespace**: `Slim\Factory`

`AppFactory` is a static builder class that constructs [`Slim\App`](#slim-app) instances without requiring manual instantiation of a `ResponseFactoryInterface`. When `AppFactory::create()` or `AppFactory::createFromContainer($container)` is called, it either uses a pre-configured `ResponseFactoryInterface`, resolves one from the PSR-11 container, or queries [`Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) to auto-detect an installed PSR-17 implementation (and automatically decorates it with `Slim\Http\Factory\DecoratedResponseFactory` if `slim/http` is installed and `$slimHttpDecoratorsAutomaticDetectionEnabled` is `true`).

### PHP Class Signature (`Slim\Factory\AppFactory`)

```php
namespace Slim\Factory;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\StreamFactoryInterface;
use RuntimeException;
use Slim\App;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\MiddlewareDispatcherInterface;
use Slim\Interfaces\Psr17FactoryProviderInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteResolverInterface;

class AppFactory
{
    protected static ?Psr17FactoryProviderInterface $psr17FactoryProvider = null;
    protected static ?ResponseFactoryInterface $responseFactory = null;
    protected static ?StreamFactoryInterface $streamFactory = null;
    protected static ?ContainerInterface $container = null;
    protected static ?CallableResolverInterface $callableResolver = null;
    protected static ?RouteCollectorInterface $routeCollector = null;
    protected static ?RouteResolverInterface $routeResolver = null;
    protected static ?MiddlewareDispatcherInterface $middlewareDispatcher = null;
    protected static bool $slimHttpDecoratorsAutomaticDetectionEnabled = true;

    public static function create(
        ?ResponseFactoryInterface $responseFactory = null,
        ?ContainerInterface $container = null,
        ?CallableResolverInterface $callableResolver = null,
        ?RouteCollectorInterface $routeCollector = null,
        ?RouteResolverInterface $routeResolver = null,
        ?MiddlewareDispatcherInterface $middlewareDispatcher = null
    ): App;

    public static function createFromContainer(ContainerInterface $container): App;
    public static function determineResponseFactory(): ResponseFactoryInterface;

    protected static function attemptResponseFactoryDecoration(
        ResponseFactoryInterface $responseFactory,
        StreamFactoryInterface $streamFactory
    ): ResponseFactoryInterface;

    public static function setPsr17FactoryProvider(Psr17FactoryProviderInterface $psr17FactoryProvider): void;
    public static function setResponseFactory(ResponseFactoryInterface $responseFactory): void;
    public static function setStreamFactory(StreamFactoryInterface $streamFactory): void;
    public static function setContainer(ContainerInterface $container): void;
    public static function setCallableResolver(CallableResolverInterface $callableResolver): void;
    public static function setRouteCollector(RouteCollectorInterface $routeCollector): void;
    public static function setRouteResolver(RouteResolverInterface $routeResolver): void;
    public static function setMiddlewareDispatcher(MiddlewareDispatcherInterface $middlewareDispatcher): void;
    public static function setSlimHttpDecoratorsAutomaticDetection(bool $enabled): void;
}
```

### Static Methods (`Slim\Factory\AppFactory`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `create(...)` | `?ResponseFactoryInterface $responseFactory = null`, `?ContainerInterface $container = null`, `?CallableResolverInterface $callableResolver = null`, `?RouteCollectorInterface $routeCollector = null`, `?RouteResolverInterface $routeResolver = null`, `?MiddlewareDispatcherInterface $middlewareDispatcher = null` | [`App`](#slim-app) | Creates a new `App` merging explicit arguments with static properties and calling `self::determineResponseFactory()`. |
| `createFromContainer($container)` | `ContainerInterface $container` | [`App`](#slim-app) | Inspects `$container->has(...)` for `ResponseFactoryInterface`, `CallableResolverInterface`, `RouteCollectorInterface`, `RouteResolverInterface`, and `MiddlewareDispatcherInterface` (falling back to `determineResponseFactory()` / `null`), then returns `new App(...)`. |
| `determineResponseFactory()` | *(none)* | `ResponseFactoryInterface` | Returns `static::$responseFactory` (decorated if `static::$streamFactory` is set), or loops over `Psr17FactoryProvider::getFactories()` to instantiate the first available `ResponseFactoryInterface`. Throws `RuntimeException` if none is found. |
| `attemptResponseFactoryDecoration(...)` *(protected)* | `ResponseFactoryInterface $responseFactory`, `StreamFactoryInterface $streamFactory` | `ResponseFactoryInterface` | Wraps `$responseFactory` and `$streamFactory` via [`SlimHttpPsr17Factory::createDecoratedResponseFactory()`](02_psr17_providers.md#slim-factory-psr17-slimhttppsr17factory) when `slim/http` is installed and auto-detection is enabled. |
| `setPsr17FactoryProvider($provider)` | `Psr17FactoryProviderInterface $psr17FactoryProvider` | `void` | Overrides the static `Psr17FactoryProviderInterface` used during auto-discovery. |
| `setResponseFactory($responseFactory)` | `ResponseFactoryInterface $responseFactory` | `void` | Sets the default static `ResponseFactoryInterface` for subsequent `create()` calls. |
| `setStreamFactory($streamFactory)` | `StreamFactoryInterface $streamFactory` | `void` | Sets the default static `StreamFactoryInterface` used when decorating with `slim/http`. |
| `setContainer($container)` | `ContainerInterface $container` | `void` | Sets the default static PSR-11 `ContainerInterface` for subsequent `create()` calls. |
| `setCallableResolver($callableResolver)` | `CallableResolverInterface $callableResolver` | `void` | Sets the default static `CallableResolverInterface`. |
| `setRouteCollector($routeCollector)` | `RouteCollectorInterface $routeCollector` | `void` | Sets the default static `RouteCollectorInterface`. |
| `setRouteResolver($routeResolver)` | `RouteResolverInterface $routeResolver` | `void` | Sets the default static `RouteResolverInterface`. |
| `setMiddlewareDispatcher($middlewareDispatcher)` | `MiddlewareDispatcherInterface $middlewareDispatcher` | `void` | Sets the default static `MiddlewareDispatcherInterface`. |
| `setSlimHttpDecoratorsAutomaticDetection($enabled)` | `bool $enabled` | `void` | Enables (`true`) or disables (`false`) automatic wrapping with `slim/http` response decorators. |

### Usage Example (`Slim\Factory\AppFactory`)

```php
<?php

declare(strict_types=1);

use DI\Container;
use Slim\Factory\AppFactory;

// Option A: Configure static container then call create()
$container = new Container();
AppFactory::setContainer($container);
AppFactory::setSlimHttpDecoratorsAutomaticDetection(false);
$app = AppFactory::create();

// Option B: Resolve core services directly from a PSR-11 container
$appFromDi = AppFactory::createFromContainer($container);
```

---

## `class` Slim\Factory\ServerRequestCreatorFactory

- **Source File**: `Slim/Factory/ServerRequestCreatorFactory.php`
- **Namespace**: `Slim\Factory`

`ServerRequestCreatorFactory` is the static counterpart to `AppFactory` for incoming HTTP requests. Called automatically by `App::run()` when no `ServerRequestInterface` is passed, it probes [`Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) to locate a vendor [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) capable of building a PSR-7 `ServerRequestInterface` from PHP superglobals, and optionally wraps it in [`SlimHttpServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-slimhttpserverrequestcreator) if `slim/http` is present.

### PHP Class Signature (`Slim\Factory\ServerRequestCreatorFactory`)

```php
namespace Slim\Factory;

use RuntimeException;
use Slim\Interfaces\Psr17FactoryProviderInterface;
use Slim\Interfaces\ServerRequestCreatorInterface;

class ServerRequestCreatorFactory
{
    protected static ?Psr17FactoryProviderInterface $psr17FactoryProvider = null;
    protected static ?ServerRequestCreatorInterface $serverRequestCreator = null;
    protected static bool $slimHttpDecoratorsAutomaticDetectionEnabled = true;

    public static function create(): ServerRequestCreatorInterface;
    public static function determineServerRequestCreator(): ServerRequestCreatorInterface;

    protected static function attemptServerRequestCreatorDecoration(
        ServerRequestCreatorInterface $serverRequestCreator
    ): ServerRequestCreatorInterface;

    public static function setPsr17FactoryProvider(Psr17FactoryProviderInterface $psr17FactoryProvider): void;
    public static function setServerRequestCreator(ServerRequestCreatorInterface $serverRequestCreator): void;
    public static function setSlimHttpDecoratorsAutomaticDetection(bool $enabled): void;
}
```

### Static Methods (`Slim\Factory\ServerRequestCreatorFactory`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `create()` | *(none)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Alias for `static::determineServerRequestCreator()`. |
| `determineServerRequestCreator()` | *(none)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Returns `static::$serverRequestCreator` if set, or iterates `Psr17FactoryProvider::getFactories()` and returns the first available `getServerRequestCreator()` (wrapped with `attemptServerRequestCreatorDecoration()`). Throws `RuntimeException` if none is available. |
| `attemptServerRequestCreatorDecoration(...)` *(protected)* | `ServerRequestCreatorInterface $serverRequestCreator` | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Wraps `$serverRequestCreator` in `new SlimHttpServerRequestCreator($serverRequestCreator)` if automatic detection is enabled and `Slim\Http\ServerRequest` exists. |
| `setPsr17FactoryProvider($provider)` | `Psr17FactoryProviderInterface $psr17FactoryProvider` | `void` | Overrides the `Psr17FactoryProviderInterface` registry. |
| `setServerRequestCreator($creator)` | `ServerRequestCreatorInterface $serverRequestCreator` | `void` | Explicitly sets a custom `ServerRequestCreatorInterface` instance. |
| `setSlimHttpDecoratorsAutomaticDetection($enabled)` | `bool $enabled` | `void` | Enables or disables automatic `Slim\Http\ServerRequest` decoration. |

### Usage Example (`Slim\Factory\ServerRequestCreatorFactory`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Factory\ServerRequestCreatorFactory;

// Create a PSR-7 ServerRequest from PHP globals manually before running the app
$creator = ServerRequestCreatorFactory::create();
$request = $creator->createServerRequestFromGlobals();

$app = AppFactory::create();
$response = $app->handle($request);
```

---

## `class` Slim\CallableResolver

- **Source File**: `Slim/CallableResolver.php`
- **Namespace**: `Slim`
- **Modifiers**: `final class`
- **Implements**: [`Slim\Interfaces\AdvancedCallableResolverInterface`](08_interfaces.md#slim-interfaces-advancedcallableresolverinterface) (which extends [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface))
- **Template Annotation**: `@template TContainerInterface of (ContainerInterface|null)`

`CallableResolver` translates Slim's flexible callable notations into executable PHP `callable`s. It supports:
1. Native PHP callables (`Closure`, function names, invokable objects, `[$object, 'method']`).
2. `[ClassName::class, 'method']` two-element arrays (normalized to `'ClassName:method'`).
3. Slim colon notation `'ClassName:method'` matched by `CallableResolver::$callablePattern` (`!^([^\:]+)\:([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)$!`).
4. Container service IDs or class names: resolved from `$this->container->get($class)` if registered in the PSR-11 container, or instantiated via `new $class($this->container)` otherwise.
5. Automatic default method selection: `resolveRoute()` defaults `RequestHandlerInterface` instances to `'handle'`, `resolveMiddleware()` defaults `MiddlewareInterface` instances to `'process'`, and `resolve()` defaults to `'__invoke'`.
6. Closure binding: if `$this->container` is present and the resolved callable is a `Closure`, it binds `$this` inside the closure via `$callable->bindTo($this->container)`.

### PHP Class Signature (`Slim\CallableResolver`)

```php
namespace Slim;

use Psr\Container\ContainerInterface;
use Slim\Interfaces\AdvancedCallableResolverInterface;

final class CallableResolver implements AdvancedCallableResolverInterface
{
    public static string $callablePattern = '!^([^\:]+)\:([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)$!';

    private ?ContainerInterface $container;

    public function __construct(?ContainerInterface $container = null);
    public function resolve($toResolve): callable;
    public function resolveRoute($toResolve): callable;
    public function resolveMiddleware($toResolve): callable;
}
```

### Properties & Methods (`Slim\CallableResolver`)

| Member / Method | Signature / Type | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `$callablePattern` | `public static string` | `string` | Regex pattern matching `'class:method'` strings (`!^([^\:]+)\:([a-zA-Z_\x7f-\xff][a-zA-Z0-9_\x7f-\xff]*)$!`). |
| `__construct($container)` | `?ContainerInterface $container = null` | `void` | Stores the optional PSR-11 container used for service resolution and `Closure::bindTo()`. |
| `resolve($toResolve)` | `string\|callable $toResolve` | `callable` | Resolves a generic callable, defaulting class strings without a method to `'__invoke'`. Throws `RuntimeException` if unresolvable. |
| `resolveRoute($toResolve)` | `string\|callable $toResolve` | `callable` | Resolves a route callable; if the target object implements `Psr\Http\Server\RequestHandlerInterface` and no method is specified, resolves `[$instance, 'handle']`. |
| `resolveMiddleware($toResolve)` | `string\|callable $toResolve` | `callable` | Resolves a middleware callable; if the target object implements `Psr\Http\Server\MiddlewareInterface` and no method is specified, resolves `[$instance, 'process']`. |

### Usage Example (`Slim\CallableResolver`)

```php
<?php

declare(strict_types=1);

use Slim\CallableResolver;

$resolver = new CallableResolver($container);

// Resolve 'Class:method' string, [Class::class, 'method'] array, or PSR-15 RequestHandlerInterface
$routeCallable = $resolver->resolveRoute('App\Action\UserListAction:index');
$handlerCallable = $resolver->resolveRoute(\App\Action\SingleActionHandler::class); // -> [$instance, 'handle']
$mwCallable = $resolver->resolveMiddleware(\App\Middleware\AuthMiddleware::class); // -> [$instance, 'process']
```

---

## `class` Slim\MiddlewareDispatcher

- **Source File**: `Slim/MiddlewareDispatcher.php`
- **Namespace**: `Slim`
- **Implements**: [`Slim\Interfaces\MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) (which extends `Psr\Http\Server\RequestHandlerInterface`)
- **Template Annotation**: `@template TContainerInterface of (ContainerInterface|null)`

`MiddlewareDispatcher` implements Slim 4's concentric **LIFO (Last-In, First-Out)** middleware stack. It wraps a core `RequestHandlerInterface $kernel` ([`RouteRunner`](03_routing.md#slim-routing-routerunner) at the application level, or [`Route`](03_routing.md#slim-routing-route) at the route level) in lightweight anonymous `RequestHandlerInterface` decorators. Every call to `add()`, `addMiddleware()`, `addDeferred()`, or `addCallable()` replaces `$this->tip` with a new outer handler pointing `$next` to the previous `$this->tip`.

### PHP Class Signature (`Slim\MiddlewareDispatcher`)

```php
namespace Slim;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\MiddlewareDispatcherInterface;

class MiddlewareDispatcher implements MiddlewareDispatcherInterface
{
    protected RequestHandlerInterface $tip;
    protected ?CallableResolverInterface $callableResolver;
    protected ?ContainerInterface $container;

    public function __construct(
        RequestHandlerInterface $kernel,
        ?CallableResolverInterface $callableResolver = null,
        ?ContainerInterface $container = null
    );

    public function seedMiddlewareStack(RequestHandlerInterface $kernel): void;
    public function handle(ServerRequestInterface $request): ResponseInterface;
    public function add($middleware): MiddlewareDispatcherInterface;
    public function addMiddleware(MiddlewareInterface $middleware): MiddlewareDispatcherInterface;
    public function addDeferred(string $middleware): self;
    public function addCallable(callable $middleware): self;
}
```

### Constructor & Methods (`Slim\MiddlewareDispatcher`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct(...)` | `RequestHandlerInterface $kernel`, `?CallableResolverInterface $callableResolver = null`, `?ContainerInterface $container = null` | `void` | Calls `seedMiddlewareStack($kernel)` and stores `$callableResolver` and `$container`. |
| `seedMiddlewareStack($kernel)` | `RequestHandlerInterface $kernel` | `void` | Sets `$this->tip = $kernel` as the innermost request handler of the stack. |
| `handle($request)` | `ServerRequestInterface $request` | `ResponseInterface` | Invokes `$this->tip->handle($request)` to traverse the middleware stack from outermost to innermost. |
| `add($middleware)` | `MiddlewareInterface\|string\|callable $middleware` | [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | Dispatches to `addMiddleware()` for `MiddlewareInterface`, `addDeferred()` for `string`, or `addCallable()` for `callable`. Throws `RuntimeException` otherwise. |
| `addMiddleware($middleware)` | `MiddlewareInterface $middleware` | [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | Wraps `$this->tip` in an anonymous `RequestHandlerInterface` that calls `$middleware->process($request, $this->next)`. |
| `addDeferred($middleware)` | `string $middleware` | `self` | Wraps `$this->tip` in a lazy anonymous `RequestHandlerInterface` that resolves `$middleware` via `AdvancedCallableResolverInterface::resolveMiddleware()` (or container / `class:method` fallback) only when `handle()` is actually invoked. |
| `addCallable($middleware)` | `callable $middleware` | `self` | Binds `Closure` middlewares to `$this->container` if present and wraps `$this->tip` in an anonymous `RequestHandlerInterface` invoking `($this->middleware)($request, $this->next)`. |

### Usage Example (`Slim\MiddlewareDispatcher`)

```php
<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;

// Adding middlewares to $app delegates to MiddlewareDispatcher::add()
// LIFO order: OuterMiddleware runs BEFORE InnerMiddleware
$app->add(function (Request $request, RequestHandler $handler): Response {
    $response = $handler->handle($request->withAttribute('inner', true));
    return $response->withHeader('X-Inner-Middleware', '1');
});

$app->add('App\Middleware\OuterAuthMiddleware'); // Deferred resolution on handle()
```

---

## `class` Slim\ResponseEmitter

- **Source File**: `Slim/ResponseEmitter.php`
- **Namespace**: `Slim`

`ResponseEmitter` streams a PSR-7 `ResponseInterface` to the PHP SAPI output buffer. It includes three important HTTP edge-case safeguards:
1. **Multi-Value `Set-Cookie` Preservation**: In `emitHeaders()`, all headers replace previous values on their first iteration (`$first = true`) *except* `set-cookie` (`strtolower($name) !== 'set-cookie'`), ensuring multiple `Set-Cookie` headers are never overwritten.
2. **Status Line Emitted *After* Headers**: `emitStatusLine()` is deliberately called *after* `emitHeaders()` to prevent PHP's built-in `header('Location: ...')` behavior from overriding an explicit custom redirect status code (e.g., `301`, `303`, `307`, `308`) with `302` ([Slim issue #1730](https://github.com/slimphp/Slim/issues/1730)).
3. **Empty Status & Chunked Streaming**: `isResponseEmpty()` suppresses body output on `204 No Content`, `205 Reset Content`, and `304 Not Modified` (or empty streams), while `emitBody()` streams bodies in `$responseChunkSize` (`4096`-byte) chunks and halts early if `connection_status() !== CONNECTION_NORMAL`.

### PHP Class Signature (`Slim\ResponseEmitter`)

```php
namespace Slim;

use Psr\Http\Message\ResponseInterface;

class ResponseEmitter
{
    private int $responseChunkSize;

    public function __construct(int $responseChunkSize = 4096);
    public function emit(ResponseInterface $response): void;
    public function isResponseEmpty(ResponseInterface $response): bool;
}
```

### Constructor & Methods (`Slim\ResponseEmitter`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct($responseChunkSize)` | `int $responseChunkSize = 4096` | `void` | Configures the maximum byte chunk size read per `StreamInterface::read()` iteration when emitting the response body. |
| `emit($response)` | `ResponseInterface $response` | `void` | Checks `isResponseEmpty($response)`, emits headers and status line if `headers_sent() === false`, and streams the body if non-empty. |
| `isResponseEmpty($response)` | `ResponseInterface $response` | `bool` | Returns `true` if the status code is in `[204, 205, 304]`, or if the response stream is empty (rewinding seekable streams and testing `$stream->read(1) === ''`, or `$stream->eof()` for non-seekable streams). |

### Usage Example (`Slim\ResponseEmitter`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Factory\ServerRequestCreatorFactory;
use Slim\ResponseEmitter;

$app = AppFactory::create();
$request = ServerRequestCreatorFactory::create()->createServerRequestFromGlobals();
$response = $app->handle($request);

// Emit with a custom 8 KB chunk size for large file/stream responses
$emitter = new ResponseEmitter(8192);
$emitter->emit($response);
```

---

## `class` Slim\Logger

- **Source File**: `Slim/Logger.php`
- **Namespace**: `Slim`
- **Extends**: `Psr\Log\AbstractLogger` (which implements `Psr\Log\LoggerInterface`)

`Slim\Logger` is the zero-configuration fallback PSR-3 logger instantiated by [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) when no custom `Psr\Log\LoggerInterface` is provided to `App::addErrorMiddleware()` or `ErrorMiddleware::__construct()`. It inherits `emergency()`, `alert()`, `critical()`, `error()`, `warning()`, `notice()`, `info()`, and `debug()` from `Psr\Log\AbstractLogger` and delegates all levels to `error_log((string) $message)`.

### PHP Class Signature (`Slim\Logger`)

```php
namespace Slim;

use Psr\Log\AbstractLogger;
use Psr\Log\InvalidArgumentException;
use Stringable;

class Logger extends AbstractLogger
{
    /**
     * @param mixed             $level
     * @param string|Stringable $message
     * @param array<mixed>      $context
     *
     * @throws InvalidArgumentException
     */
    public function log($level, $message, array $context = []): void;
}
```

### Methods (`Slim\Logger`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `log($level, $message, $context)` | `mixed $level`, `string\|Stringable $message`, `array<mixed> $context = []` | `void` | Writes `(string) $message` directly to PHP's `error_log()`. |

### Usage Example (`Slim\Logger`)

```php
<?php

declare(strict_types=1);

use Slim\Logger;

$logger = new Logger();
$logger->error('Unhandled exception in checkout pipeline');
```
