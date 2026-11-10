# Routing (`Slim\Routing`)

The `Slim\Routing` namespace implements Slim 4's FastRoute-backed routing subsystem, covering route registration (`RouteCollectorProxy`, `RouteCollector`, `Route`, `RouteGroup`), URL generation (`RouteParser`), request-scoped routing state (`RouteContext`), and URI dispatching (`RouteResolver`, `Dispatcher`, `FastRouteDispatcher`, `RoutingResults`, `RouteRunner`).

```drawlib align=center code=fold file=routing_architecture.png caption="Slim 4 Routing Subsystem — Registration, Resolution, and Dispatch Architecture"
from drawlib.canvas import save, setup
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=86)

# Outer phase containers
rectangle(
    (46, 43),
    width=80,
    height=74,
    style=Styles.Neutral.patch(shape_r=3.0),
)
text((46, 75), "1. Route Registration & URL Generation", style=Styles.PrimaryBold.patch(text_size=12.0))

rectangle(
    (134, 43),
    width=80,
    height=74,
    style=Styles.PrimaryNeutral.patch(shape_r=3.0),
)
text((134, 75), "2. URI Dispatch & Route Execution", style=Styles.PrimaryBold.patch(text_size=12.0))

# Left phase nodes
rectangle(
    (46, 61),
    width=66,
    height=12,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((46, 63), "RouteCollectorProxy", style=Styles.BlackBold.patch(text_size=11.0))
text((46, 58.5), "get() / post() / group() / map()", style=Styles.Dark.patch(text_size=10.0))

rectangle(
    (46, 42),
    width=66,
    height=13,
    style=Styles.PrimaryFlat.patch(shape_r=2.0),
)
text((46, 44.5), "RouteCollector", style=Styles.WhiteBold.patch(text_size=11.5))
text((46, 39.5), "Stores Route[] & RouteGroup[]", style=Styles.White.patch(text_size=10.0))

rectangle(
    (27, 20),
    width=30,
    height=14,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((27, 22.5), "Route & Group", style=Styles.BlackBold.patch(text_size=10.5))
text((27, 17.5), "Pattern + Middleware", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (65, 20),
    width=30,
    height=14,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((65, 22.5), "RouteParser", style=Styles.BlackBold.patch(text_size=10.5))
text((65, 17.5), "urlFor() / fullUrlFor()", style=Styles.Dark.patch(text_size=9.5))

# Right phase nodes
rectangle(
    (134, 61),
    width=66,
    height=12,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((134, 63), "RouteResolver", style=Styles.BlackBold.patch(text_size=11.0))
text((134, 58.5), "computeRoutingResults(uri, method)", style=Styles.Dark.patch(text_size=10.0))

rectangle(
    (134, 42),
    width=66,
    height=13,
    style=Styles.AccentFlat.patch(shape_r=2.0),
)
text((134, 44.5), "Dispatcher & FastRouteDispatcher", style=Styles.WhiteBold.patch(text_size=11.0))
text((134, 39.5), "Static Map -> Regex -> HEAD/GET", style=Styles.White.patch(text_size=10.0))

rectangle(
    (114, 20),
    width=30,
    height=14,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((114, 22.5), "RoutingResults", style=Styles.BlackBold.patch(text_size=10.5))
text((114, 17.5), "FOUND / 404 / 405", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (154, 20),
    width=30,
    height=14,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((154, 22.5), "RouteRunner", style=Styles.BlackBold.patch(text_size=10.5))
text((154, 17.5), "RouteContext + run()", style=Styles.Dark.patch(text_size=9.5))

# Internal vertical arrows (Left)
line((46, 55), (46, 48.5), arrow_head="->", style=Styles.PrimaryBold)
line((34, 35.5), (27, 27), arrow_head="->", style=Styles.PrimaryBold)
line((58, 35.5), (65, 27), arrow_head="->", style=Styles.PrimaryBold)

# Internal vertical arrows (Right)
line((134, 55), (134, 48.5), arrow_head="->", style=Styles.PrimaryBold)
line((122, 35.5), (114, 27), arrow_head="->", style=Styles.PrimaryBold)
line((146, 35.5), (154, 27), arrow_head="->", style=Styles.PrimaryBold)
line((129, 20), (139, 20), arrow_head="->", style=Styles.PrimaryBold)

# Cross-phase bridge
line((79, 42), (101, 42), arrow_head="->", style=Styles.PrimaryBold)
text((90, 45.5), "Routes", style=Styles.PrimaryBold.patch(text_size=10.0))

save()
```

---

## `class` Slim\Routing\RouteCollectorProxy

- **Source**: `Slim/Routing/RouteCollectorProxy.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface)
- **Extended by**: [`Slim\App`](01_app_and_factories.md#slim-app)

`RouteCollectorProxy` provides the fluent HTTP verb routing API (`get()`, `post()`, `put()`, `patch()`, `delete()`, `options()`, `any()`, `map()`, `group()`, `redirect()`) shared by [`Slim\App`](01_app_and_factories.md#slim-app) and nested route groups. When instantiated for a route group, it prefixes all child routes and nested sub-groups with `$groupPattern` before delegating registration to the underlying [`RouteCollector`](#slim-routing-routecollector).

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteCollectorProxyInterface;
use Slim\Interfaces\RouteGroupInterface;
use Slim\Interfaces\RouteInterface;

/**
 * @template TContainerInterface of (ContainerInterface|null)
 * @template-implements RouteCollectorProxyInterface<TContainerInterface>
 */
class RouteCollectorProxy implements RouteCollectorProxyInterface
{
    protected ResponseFactoryInterface $responseFactory;
    protected CallableResolverInterface $callableResolver;
    protected ?ContainerInterface $container = null;
    protected RouteCollectorInterface $routeCollector;
    protected string $groupPattern;

    public function __construct(
        ResponseFactoryInterface $responseFactory,
        CallableResolverInterface $callableResolver,
        ?ContainerInterface $container = null,
        ?RouteCollectorInterface $routeCollector = null,
        string $groupPattern = ''
    );

    public function getResponseFactory(): ResponseFactoryInterface;
    public function getCallableResolver(): CallableResolverInterface;
    public function getContainer(): ?ContainerInterface;
    public function getRouteCollector(): RouteCollectorInterface;
    public function getBasePath(): string;
    public function setBasePath(string $basePath): RouteCollectorProxyInterface;

    public function get(string $pattern, $callable): RouteInterface;
    public function post(string $pattern, $callable): RouteInterface;
    public function put(string $pattern, $callable): RouteInterface;
    public function patch(string $pattern, $callable): RouteInterface;
    public function delete(string $pattern, $callable): RouteInterface;
    public function options(string $pattern, $callable): RouteInterface;
    public function any(string $pattern, $callable): RouteInterface;
    public function map(array $methods, string $pattern, $callable): RouteInterface;
    public function group(string $pattern, $callable): RouteGroupInterface;
    public function redirect(string $from, $to, int $status = 302): RouteInterface;
}
```

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `$responseFactory` | `ResponseFactoryInterface` | — | PSR-17 response factory used to instantiate responses in routes and redirects. |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | Resolves string, array, or closure route and group handlers. |
| `$container` | `?ContainerInterface` | `null` | Optional PSR-11 dependency injection container. |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `new RouteCollector(...)` | Underlying route collector storing registered routes and groups. |
| `$groupPattern` | `string` | `''` | Prefix pattern prepended to all routes and groups registered through this proxy. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?RouteCollectorInterface $routeCollector = null`, `string $groupPattern = ''` | `void` | Initializes the proxy and creates a default [`RouteCollector`](#slim-routing-routecollector) if none is provided. |
| `getResponseFactory` | *(none)* | `ResponseFactoryInterface` | Returns the configured PSR-17 response factory. |
| `getCallableResolver` | *(none)* | `CallableResolverInterface` | Returns the configured callable resolver. |
| `getContainer` | *(none)* | `?ContainerInterface` | Returns the PSR-11 container instance, or `null` if none was configured. |
| `getRouteCollector` | *(none)* | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Returns the underlying [`RouteCollector`](#slim-routing-routecollector). |
| `getBasePath` | *(none)* | `string` | Returns the application base path from the underlying route collector. |
| `setBasePath` | `string $basePath` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | Sets the application base path on the underlying route collector and returns `$this`. |
| `get` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `GET` route prefixed with `$this->groupPattern`. |
| `post` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `POST` route prefixed with `$this->groupPattern`. |
| `put` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `PUT` route prefixed with `$this->groupPattern`. |
| `patch` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `PATCH` route prefixed with `$this->groupPattern`. |
| `delete` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `DELETE` route prefixed with `$this->groupPattern`. |
| `options` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers an `OPTIONS` route prefixed with `$this->groupPattern`. |
| `any` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a route matching `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, and `OPTIONS`. |
| `map` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Prepends `$this->groupPattern` to `$pattern` and delegates route creation to `RouteCollector::map()`. |
| `group` | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Prepends `$this->groupPattern` to `$pattern` and delegates group creation to `RouteCollector::group()`. |
| `redirect` | `string $from`, `string\|UriInterface $to`, `int $status = 302` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Registers a `GET` route on `$from` that returns a response with a `Location` header pointing to `$to`. |

### Usage Example

```php
use Slim\Factory\AppFactory;
use Slim\Routing\RouteCollectorProxy;

$app = AppFactory::create();
$app->setBasePath('/v1');

$app->group('/users', function (RouteCollectorProxy $group) {
    $group->get('', [UserController::class, 'index'])->setName('users.index');
    $group->post('', [UserController::class, 'store'])->setName('users.store');
    $group->redirect('/legacy', '/v1/users', 301);
});
```

---

## `class` Slim\Routing\RouteCollector

- **Source**: `Slim/Routing/RouteCollector.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface)

`RouteCollector` is the central registry that creates and stores [`Route`](#slim-routing-route) and [`RouteGroup`](#slim-routing-routegroup) instances, manages the default [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) (defaulting to [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse)), maintains the FastRoute cache file path, and provides named/identifier route lookups.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use RuntimeException;
use Slim\Handlers\Strategies\RequestResponse;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\InvocationStrategyInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteCollectorProxyInterface;
use Slim\Interfaces\RouteGroupInterface;
use Slim\Interfaces\RouteInterface;
use Slim\Interfaces\RouteParserInterface;

/**
 * @template TContainerInterface of (ContainerInterface|null)
 */
class RouteCollector implements RouteCollectorInterface
{
    protected RouteParserInterface $routeParser;
    protected CallableResolverInterface $callableResolver;
    protected ?ContainerInterface $container = null;
    protected InvocationStrategyInterface $defaultInvocationStrategy;
    protected string $basePath = '';
    protected ?string $cacheFile = null;
    protected array $routes = [];
    protected array $routesByName = [];
    protected array $routeGroups = [];
    protected int $routeCounter = 0;
    protected ResponseFactoryInterface $responseFactory;

    public function __construct(
        ResponseFactoryInterface $responseFactory,
        CallableResolverInterface $callableResolver,
        ?ContainerInterface $container = null,
        ?InvocationStrategyInterface $defaultInvocationStrategy = null,
        ?RouteParserInterface $routeParser = null,
        ?string $cacheFile = null
    );

    public function getRouteParser(): RouteParserInterface;
    public function getDefaultInvocationStrategy(): InvocationStrategyInterface;
    public function setDefaultInvocationStrategy(InvocationStrategyInterface $strategy): RouteCollectorInterface;
    public function getCacheFile(): ?string;
    public function setCacheFile(string $cacheFile): RouteCollectorInterface;
    public function getBasePath(): string;
    public function setBasePath(string $basePath): RouteCollectorInterface;
    public function getRoutes(): array;
    public function removeNamedRoute(string $name): RouteCollectorInterface;
    public function getNamedRoute(string $name): RouteInterface;
    public function lookupRoute(string $identifier): RouteInterface;
    public function group(string $pattern, $callable): RouteGroupInterface;
    protected function createGroup(string $pattern, $callable): RouteGroupInterface;
    protected function createProxy(string $pattern): RouteCollectorProxyInterface;
    public function map(array $methods, string $pattern, $handler): RouteInterface;
    protected function createRoute(array $methods, string $pattern, $callable): RouteInterface;
}
```

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `$routeParser` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | `new RouteParser($this)` | Route parser used to generate relative and full URLs for named routes. |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | Callable resolver passed to created routes and groups. |
| `$container` | `?ContainerInterface` | `null` | Optional PSR-11 container passed to created routes and proxies. |
| `$defaultInvocationStrategy` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | `new RequestResponse()` | Default strategy used when invoking route callables. |
| `$basePath` | `string` | `''` | Base URL path prepended in `RouteParser::urlFor()` and `Dispatcher`. |
| `$cacheFile` | `?string` | `null` | File path for FastRoute dispatch table caching (`null` disables caching). |
| `$routes` | `array<string, RouteInterface>` | `[]` | Registered routes indexed by route identifier (`route0`, `route1`, ...). |
| `$routesByName` | `array<string, RouteInterface>` | `[]` | Lookup cache of named routes indexed by route name. |
| `$routeGroups` | `RouteGroupInterface[]` | `[]` | Active stack of enclosing route groups during `group()` collection. |
| `$routeCounter` | `int` | `0` | Monotonically increasing counter used to assign unique route identifiers. |
| `$responseFactory` | `ResponseFactoryInterface` | — | PSR-17 response factory passed to created routes and proxies. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?InvocationStrategyInterface $defaultInvocationStrategy = null`, `?RouteParserInterface $routeParser = null`, `?string $cacheFile = null` | `void` | Initializes the collector, defaulting to [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) and [`RouteParser`](#slim-routing-routeparser). |
| `getRouteParser` | *(none)* | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | Returns the [`RouteParser`](#slim-routing-routeparser) instance. |
| `getDefaultInvocationStrategy` | *(none)* | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Returns the default route invocation strategy. |
| `setDefaultInvocationStrategy` | `InvocationStrategyInterface $strategy` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Replaces the default invocation strategy for subsequently created routes. |
| `getCacheFile` | *(none)* | `?string` | Returns the FastRoute cache file path or `null` if disabled. |
| `setCacheFile` | `string $cacheFile` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Validates readability/writability and sets the FastRoute cache file path. Throws `RuntimeException` if invalid. |
| `getBasePath` | *(none)* | `string` | Returns the configured base path. |
| `setBasePath` | `string $basePath` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Sets the base path used in `urlFor()` and route dispatching. |
| `getRoutes` | *(none)* | `RouteInterface[]` | Returns all registered routes indexed by route identifier. |
| `removeNamedRoute` | `string $name` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | Removes a named route from both `$routesByName` and `$routes`. Throws `RuntimeException` if not found. |
| `getNamedRoute` | `string $name` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Finds and returns a route by its name, caching the result in `$routesByName`. Throws `RuntimeException` if not found. |
| `lookupRoute` | `string $identifier` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Looks up a route by its internal identifier (e.g. `'route0'`). Throws `RuntimeException` if missing. |
| `group` | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Pushes a new [`RouteGroup`](#slim-routing-routegroup) onto `$routeGroups`, invokes `collectRoutes()`, pops the group, and returns it. |
| `createGroup` *(protected)* | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Factory method creating a [`RouteGroup`](#slim-routing-routegroup) with a scoped [`RouteCollectorProxy`](#slim-routing-routecollectorproxy). |
| `createProxy` *(protected)* | `string $pattern` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | Factory method creating a [`RouteCollectorProxy`](#slim-routing-routecollectorproxy) for a group pattern. |
| `map` | `string[] $methods`, `string $pattern`, `callable\|array\|string $handler` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Creates a [`Route`](#slim-routing-route), indexes it by identifier and name, increments `$routeCounter`, and returns it. |
| `createRoute` *(protected)* | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Instantiates a [`Route`](#slim-routing-route) with current `$routeGroups` and `$routeCounter`. |

### Usage Example

```php
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponseArgs;

$app = AppFactory::create();
$routeCollector = $app->getRouteCollector();

// Unpack route placeholders as separate arguments in route callables
$routeCollector->setDefaultInvocationStrategy(new RequestResponseArgs());

// Enable FastRoute dispatch caching in production
$routeCollector->setCacheFile(__DIR__ . '/../var/cache/routes.cache.php');
```

---

## `class` Slim\Routing\Route

- **Source**: `Slim/Routing/Route.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface), `Psr\Http\Server\RequestHandlerInterface`

`Route` represents a single registered endpoint and acts as a PSR-15 `RequestHandlerInterface`. It holds the route's HTTP methods, URI pattern, callable handler, route arguments, parent [`RouteGroup`](#slim-routing-routegroup) chain, and its own dedicated [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher). When `run()` is called by [`RouteRunner`](#slim-routing-routerunner), `Route` lazily appends all enclosing group middleware (innermost group first, outermost group last) around its route-specific middleware before invoking `handle()`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\InvocationStrategyInterface;
use Slim\Interfaces\RouteGroupInterface;
use Slim\Interfaces\RouteInterface;
use Slim\MiddlewareDispatcher;

/**
 * @api
 * @template TContainerInterface of (ContainerInterface|null)
 */
class Route implements RouteInterface, RequestHandlerInterface
{
    protected array $methods = [];
    protected string $identifier;
    protected ?string $name = null;
    protected array $groups;
    protected InvocationStrategyInterface $invocationStrategy;
    protected array $arguments = [];
    protected array $savedArguments = [];
    protected ?ContainerInterface $container = null;
    protected MiddlewareDispatcher $middlewareDispatcher;
    protected $callable;
    protected CallableResolverInterface $callableResolver;
    protected ResponseFactoryInterface $responseFactory;
    protected string $pattern;
    protected bool $groupMiddlewareAppended = false;

    public function __construct(
        array $methods,
        string $pattern,
        $callable,
        ResponseFactoryInterface $responseFactory,
        CallableResolverInterface $callableResolver,
        ?ContainerInterface $container = null,
        ?InvocationStrategyInterface $invocationStrategy = null,
        array $groups = [],
        int $identifier = 0
    );

    public function getCallableResolver(): CallableResolverInterface;
    public function getInvocationStrategy(): InvocationStrategyInterface;
    public function setInvocationStrategy(InvocationStrategyInterface $invocationStrategy): RouteInterface;
    public function getMethods(): array;
    public function getPattern(): string;
    public function setPattern(string $pattern): RouteInterface;
    public function getCallable();
    public function setCallable($callable): RouteInterface;
    public function getName(): ?string;
    public function setName(string $name): RouteInterface;
    public function getIdentifier(): string;
    public function getArgument(string $name, ?string $default = null): ?string;
    public function getArguments(): array;
    public function setArguments(array $arguments, bool $includeInSavedArguments = true): RouteInterface;
    public function getGroups(): array;
    public function add($middleware): RouteInterface;
    public function addMiddleware(MiddlewareInterface $middleware): RouteInterface;
    public function prepare(array $arguments): RouteInterface;
    public function setArgument(string $name, string $value, bool $includeInSavedArguments = true): RouteInterface;
    public function run(ServerRequestInterface $request): ResponseInterface;
    protected function appendGroupMiddlewareToRoute(): void;
    public function handle(ServerRequestInterface $request): ResponseInterface;
}
```

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `$methods` | `string[]` | `[]` | HTTP methods supported by this route (e.g. `['GET', 'POST']`). |
| `$identifier` | `string` | `'route' . $identifier` | Unique route identifier (e.g. `'route0'`). |
| `$name` | `?string` | `null` | Optional user-assigned route name for reverse URL generation. |
| `$groups` | `RouteGroupInterface[]` | `[]` | Enclosing parent route groups ordered outermost to innermost. |
| `$invocationStrategy` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | `new RequestResponse()` | Strategy used to invoke the resolved route callable. |
| `$arguments` | `array<string, string>` | `[]` | Active route parameters extracted from the request URI or set manually. |
| `$savedArguments` | `array<string, string>` | `[]` | Baseline default route arguments preserved across `prepare()` calls. |
| `$container` | `?ContainerInterface` | `null` | Optional PSR-11 container. |
| `$middlewareDispatcher` | [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | — | Route-scoped middleware dispatcher wrapping `$this` as kernel. |
| `$callable` | `callable\|array{class-string, string}\|string` | — | Unresolved route handler definition. |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | Callable resolver used to resolve `$callable` and middleware. |
| `$responseFactory` | `ResponseFactoryInterface` | — | PSR-17 factory used to create the fresh `ResponseInterface` passed to the strategy. |
| `$pattern` | `string` | — | Full route URI pattern including any group prefixes. |
| `$groupMiddlewareAppended` | `bool` | `false` | Tracks whether parent group middleware have already been appended to `$middlewareDispatcher`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable`, `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?InvocationStrategyInterface $invocationStrategy = null`, `RouteGroupInterface[] $groups = []`, `int $identifier = 0` | `void` | Creates the route and initializes its internal [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher). |
| `getCallableResolver` | *(none)* | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | Returns the route's callable resolver. |
| `getInvocationStrategy` | *(none)* | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Returns the route's invocation strategy. |
| `setInvocationStrategy` | `InvocationStrategyInterface $invocationStrategy` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Overrides the invocation strategy for this specific route. |
| `getMethods` | *(none)* | `string[]` | Returns the array of supported HTTP methods. |
| `getPattern` | *(none)* | `string` | Returns the route pattern string. |
| `setPattern` | `string $pattern` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Updates the route pattern string. |
| `getCallable` | *(none)* | `callable\|array\|string` | Returns the route callable definition. |
| `setCallable` | `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Replaces the route callable definition. |
| `getName` | *(none)* | `?string` | Returns the route's name or `null` if unnamed. |
| `setName` | `string $name` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Assigns a unique name to the route for `RouteParser::urlFor()`. |
| `getIdentifier` | *(none)* | `string` | Returns the internal route identifier (e.g. `'route0'`). |
| `getArgument` | `string $name`, `?string $default = null` | `?string` | Retrieves a single route argument by name, or `$default` if not present. |
| `getArguments` | *(none)* | `array<string, string>` | Returns all route arguments. |
| `setArguments` | `array<string, string> $arguments`, `bool $includeInSavedArguments = true` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Replaces all route arguments (and updates `$savedArguments` when `$includeInSavedArguments` is `true`). |
| `getGroups` | *(none)* | `RouteGroupInterface[]` | Returns the parent route groups array. |
| `add` | `MiddlewareInterface\|string\|callable $middleware` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Adds a route-specific middleware to `$middlewareDispatcher`. |
| `addMiddleware` | `MiddlewareInterface $middleware` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Adds a typed PSR-15 `MiddlewareInterface` instance to `$middlewareDispatcher`. |
| `prepare` | `array<string, string> $arguments` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Merges newly matched request `$arguments` over `$savedArguments` (`array_replace($this->savedArguments, $arguments)`). |
| `setArgument` | `string $name`, `string $value`, `bool $includeInSavedArguments = true` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Sets a single named argument on the route. |
| `run` | `ServerRequestInterface $request` | `ResponseInterface` | Lazily appends parent group middleware if not yet appended, then dispatches `$middlewareDispatcher->handle($request)`. |
| `appendGroupMiddlewareToRoute` *(protected)* | *(none)* | `void` | Wraps the route's middleware dispatcher and appends middleware from `$groups` in reverse order (`array_reverse($this->groups)`). |
| `handle` | `ServerRequestInterface $request` | `ResponseInterface` | Resolves `$callable`, auto-switches to `RequestHandler` strategy if target is a `RequestHandlerInterface`, creates a fresh response, and invokes the strategy. |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Handlers\Strategies\RequestResponseArgs;

$app->get('/articles/{slug}', function (Request $request, Response $response, string $slug) {
    $response->getBody()->write("Article: {$slug}");
    return $response;
})
    ->setName('articles.show')
    ->setArgument('format', 'html')
    ->setInvocationStrategy(new RequestResponseArgs())
    ->add(new AuthMiddleware());
```

---

## `class` Slim\Routing\RouteGroup

- **Source**: `Slim/Routing/RouteGroup.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface)

`RouteGroup` encapsulates a shared URL pattern prefix and a group-level middleware stack. During route registration, `collectRoutes()` resolves the group callback and invokes it with a group-scoped [`RouteCollectorProxy`](#slim-routing-routecollectorproxy). When a child [`Route`](#slim-routing-route) is executed, `appendMiddlewareToDispatcher()` registers the group's middleware onto the route's [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher).

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Http\Server\MiddlewareInterface;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\RouteCollectorProxyInterface;
use Slim\Interfaces\RouteGroupInterface;
use Slim\MiddlewareDispatcher;

class RouteGroup implements RouteGroupInterface
{
    protected $callable;
    protected CallableResolverInterface $callableResolver;
    protected RouteCollectorProxyInterface $routeCollectorProxy;
    protected array $middleware = [];
    protected string $pattern;

    public function __construct(
        string $pattern,
        $callable,
        CallableResolverInterface $callableResolver,
        RouteCollectorProxyInterface $routeCollectorProxy
    );

    public function collectRoutes(): RouteGroupInterface;
    public function add($middleware): RouteGroupInterface;
    public function addMiddleware(MiddlewareInterface $middleware): RouteGroupInterface;
    public function appendMiddlewareToDispatcher(MiddlewareDispatcher $dispatcher): RouteGroupInterface;
    public function getPattern(): string;
}
```

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `$callable` | `callable\|string` | — | Callback or container/class callable that defines the group's routes. |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | Resolver used to resolve `$callable` during `collectRoutes()`. |
| `$routeCollectorProxy` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | — | Scoped proxy passed as the sole argument to `$callable`. |
| `$middleware` | `array<MiddlewareInterface\|string\|callable>` | `[]` | Middleware queued on this group to be appended to all child routes. |
| `$pattern` | `string` | — | Group URI prefix pattern (including parent group prefixes). |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `string $pattern`, `callable\|string $callable`, `CallableResolverInterface $callableResolver`, `RouteCollectorProxyInterface $routeCollectorProxy` | `void` | Initializes the route group with its pattern, definition callback, resolver, and proxy. |
| `collectRoutes` | *(none)* | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Resolves `$callable` (using `resolveRoute()` if `AdvancedCallableResolverInterface`) and invokes it with `$routeCollectorProxy`. |
| `add` | `MiddlewareInterface\|string\|callable $middleware` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Queues a middleware (PSR-15 instance, callable, or container key) on the group. |
| `addMiddleware` | `MiddlewareInterface $middleware` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Queues a typed PSR-15 `MiddlewareInterface` instance on the group. |
| `appendMiddlewareToDispatcher` | [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) `$dispatcher` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | Iterates through `$this->middleware` and calls `$dispatcher->add($middleware)` for each entry. |
| `getPattern` | *(none)* | `string` | Returns the group's URI pattern prefix. |

### Usage Example

```php
use Slim\Routing\RouteCollectorProxy;

$app->group('/admin', function (RouteCollectorProxy $group) {
    $group->get('/dashboard', [AdminController::class, 'dashboard']);
    $group->post('/settings', [AdminController::class, 'updateSettings']);
})
    ->add(new AuditLogMiddleware())
    ->addMiddleware(new AdminAuthMiddleware());
```

---

## `class` Slim\Routing\RouteContext

- **Source**: `Slim/Routing/RouteContext.php`
- **Namespace**: `Slim\Routing`
- **Modifiers**: `final class`

`RouteContext` is an immutable value object that extracts request-scoped routing artifacts (`Route`, `RouteParser`, `RoutingResults`, and `basePath`) from a `ServerRequestInterface`'s attributes after [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) or [`RouteRunner`](#slim-routing-routerunner) has executed.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Http\Message\ServerRequestInterface;
use RuntimeException;
use Slim\Interfaces\RouteInterface;
use Slim\Interfaces\RouteParserInterface;

/** @api */
final class RouteContext
{
    public const ROUTE = '__route__';
    public const ROUTE_PARSER = '__routeParser__';
    public const ROUTING_RESULTS = '__routingResults__';
    public const BASE_PATH = '__basePath__';

    public static function fromRequest(ServerRequestInterface $serverRequest): self;

    private ?RouteInterface $route;
    private RouteParserInterface $routeParser;
    private RoutingResults $routingResults;
    private ?string $basePath;

    private function __construct(
        ?RouteInterface $route,
        RouteParserInterface $routeParser,
        RoutingResults $routingResults,
        ?string $basePath = null
    );

    public function getRoute(): ?RouteInterface;
    public function getRouteParser(): RouteParserInterface;
    public function getRoutingResults(): RoutingResults;
    public function getBasePath(): string;
}
```

### Constants & Properties

| Constant / Property | Type / Value | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `ROUTE` | `'__route__'` | `public const` | Request attribute key storing the matched [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) instance. |
| `ROUTE_PARSER` | `'__routeParser__'` | `public const` | Request attribute key storing the [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) instance. |
| `ROUTING_RESULTS` | `'__routingResults__'` | `public const` | Request attribute key storing the [`RoutingResults`](#slim-routing-routingresults) instance. |
| `BASE_PATH` | `'__basePath__'` | `public const` | Request attribute key storing the application base path string. |
| `$route` | `?RouteInterface` | `private` | Matched route object, or `null` if routing did not match a route. |
| `$routeParser` | `RouteParserInterface` | `private` | Route parser associated with the request. |
| `$routingResults` | `RoutingResults` | `private` | Dispatch results containing status, identifier, and route arguments. |
| `$basePath` | `?string` | `private` | Application base path or `null` if not set on the request. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `fromRequest` *(static)* | `ServerRequestInterface $serverRequest` | `self` | Reads `ROUTE`, `ROUTE_PARSER`, `ROUTING_RESULTS`, and `BASE_PATH` attributes from `$serverRequest` and returns a `RouteContext`. Throws `RuntimeException` if routing has not been completed. |
| `__construct` *(private)* | `?RouteInterface $route`, `RouteParserInterface $routeParser`, `RoutingResults $routingResults`, `?string $basePath = null` | `void` | Private constructor called by `RouteContext::fromRequest()`. |
| `getRoute` | *(none)* | `?RouteInterface` | Returns the matched [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) or `null`. |
| `getRouteParser` | *(none)* | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | Returns the [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) instance. |
| `getRoutingResults` | *(none)* | [`RoutingResults`](#slim-routing-routingresults) | Returns the [`RoutingResults`](#slim-routing-routingresults) instance. |
| `getBasePath` | *(none)* | `string` | Returns the base path string. Throws `RuntimeException` if `$basePath` is `null`. |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Routing\RouteContext;

$app->get('/books/{id}', function (Request $request, Response $response) {
    $routeContext = RouteContext::fromRequest($request);
    $route = $routeContext->getRoute();
    $routeParser = $routeContext->getRouteParser();

    $bookId = $route?->getArgument('id');
    $selfUrl = $routeParser->urlFor('books.show', ['id' => (string) $bookId]);

    $response->getBody()->write("Book #{$bookId} ({$selfUrl})");
    return $response;
})->setName('books.show');
```

---

## `class` Slim\Routing\RouteParser

- **Source**: `Slim/Routing/RouteParser.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface)

`RouteParser` performs reverse routing (URL generation) for named routes using `FastRoute\RouteParser\Std`. It supports required and optional route placeholders (`[/{optional}]`), query string building, base-path prefixing, and full scheme + authority URI construction.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use FastRoute\RouteParser\Std;
use InvalidArgumentException;
use Psr\Http\Message\UriInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteParserInterface;

class RouteParser implements RouteParserInterface
{
    private RouteCollectorInterface $routeCollector;
    private Std $routeParser;

    public function __construct(RouteCollectorInterface $routeCollector);

    public function relativeUrlFor(string $routeName, array $data = [], array $queryParams = []): string;
    public function urlFor(string $routeName, array $data = [], array $queryParams = []): string;
    public function fullUrlFor(UriInterface $uri, string $routeName, array $data = [], array $queryParams = []): string;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `private` | Route collector used to look up named routes and retrieve the base path. |
| `$routeParser` | `FastRoute\RouteParser\Std` | `private` | FastRoute pattern parser that decomposes patterns into static and placeholder segments. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector` | `void` | Initializes the parser with the [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) and instantiates `FastRoute\RouteParser\Std`. |
| `relativeUrlFor` | `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | Builds the URL path for `$routeName` **without** the base path prefix, substituting `$data` placeholders and appending `$queryParams`. Throws `InvalidArgumentException` if a required segment is missing. |
| `urlFor` | `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | Calls `relativeUrlFor()` and prepends `$routeCollector->getBasePath()` if non-empty. |
| `fullUrlFor` | `UriInterface $uri`, `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | Prepends the scheme and authority from `$uri` (e.g. `https://example.com`) to the path returned by `urlFor()`. |

### Usage Example

```php
$app->get('/archive/{year}[/{month}]', $handler)->setName('archive');

$routeParser = $app->getRouteCollector()->getRouteParser();

// "/archive/2026"
$path1 = $routeParser->relativeUrlFor('archive', ['year' => '2026']);

// "/base/archive/2026/11?page=2" (assuming basePath = "/base")
$path2 = $routeParser->urlFor('archive', ['year' => '2026', 'month' => '11'], ['page' => 2]);

// "https://api.example.com/base/archive/2026/11"
$fullUrl = $routeParser->fullUrlFor($request->getUri(), 'archive', ['year' => '2026', 'month' => '11']);
```

---

## `class` Slim\Routing\RouteResolver

- **Source**: `Slim/Routing/RouteResolver.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface)

`RouteResolver` bridges [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) with [`Dispatcher`](#slim-routing-dispatcher) and [`RouteCollector`](#slim-routing-routecollector). It URL-decodes and normalizes the request URI path (`rawurldecode()` and leading `/` enforcement) before dispatching, and resolves matched route identifiers back into [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) instances.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use RuntimeException;
use Slim\Interfaces\DispatcherInterface;
use Slim\Interfaces\RouteCollectorInterface;
use Slim\Interfaces\RouteInterface;
use Slim\Interfaces\RouteResolverInterface;

class RouteResolver implements RouteResolverInterface
{
    protected RouteCollectorInterface $routeCollector;
    private DispatcherInterface $dispatcher;

    public function __construct(
        RouteCollectorInterface $routeCollector,
        ?DispatcherInterface $dispatcher = null
    );

    public function computeRoutingResults(string $uri, string $method): RoutingResults;
    public function resolveRoute(string $identifier): RouteInterface;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `protected` | Route collector used to look up matched route identifiers. |
| `$dispatcher` | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | `private` | Underlying dispatcher (defaults to `new Dispatcher($routeCollector)`). |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector`, `?DispatcherInterface $dispatcher = null` | `void` | Initializes the resolver with a route collector and optional custom [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface). |
| `computeRoutingResults` | `string $uri`, `string $method` | [`RoutingResults`](#slim-routing-routingresults) | Applies `rawurldecode($uri)`, ensures a leading `'/'`, and delegates to `$this->dispatcher->dispatch($method, $uri)`. |
| `resolveRoute` | `string $identifier` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | Delegates to `$this->routeCollector->lookupRoute($identifier)`. Throws `RuntimeException` if the route identifier is not found. |

### Usage Example

```php
use Slim\Routing\RoutingResults;

$routeResolver = $app->getRouteResolver();
$results = $routeResolver->computeRoutingResults('/users/42', 'GET');

if ($results->getRouteStatus() === RoutingResults::FOUND) {
    $route = $routeResolver->resolveRoute((string) $results->getRouteIdentifier());
}
```

---

## `class` Slim\Routing\RouteRunner

- **Source**: `Slim/Routing/RouteRunner.php`
- **Namespace**: `Slim\Routing`
- **Implements**: `Psr\Http\Server\RequestHandlerInterface`

`RouteRunner` is the innermost `RequestHandlerInterface` kernel at the center of [`Slim\App`](01_app_and_factories.md#slim-app)'s middleware stack. When reached, it checks whether [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) has already populated `RouteContext::ROUTING_RESULTS`; if not, `RouteRunner` instantiates `RoutingMiddleware` and performs routing on-the-fly. It then attaches `RouteContext::BASE_PATH` and executes `$route->run($request)`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Slim\Exception\HttpMethodNotAllowedException;
use Slim\Exception\HttpNotFoundException;
use Slim\Interfaces\RouteCollectorProxyInterface;
use Slim\Interfaces\RouteParserInterface;
use Slim\Interfaces\RouteResolverInterface;

class RouteRunner implements RequestHandlerInterface
{
    private RouteResolverInterface $routeResolver;
    private RouteParserInterface $routeParser;
    private ?RouteCollectorProxyInterface $routeCollectorProxy;

    public function __construct(
        RouteResolverInterface $routeResolver,
        RouteParserInterface $routeParser,
        ?RouteCollectorProxyInterface $routeCollectorProxy = null
    );

    public function handle(ServerRequestInterface $request): ResponseInterface;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$routeResolver` | [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | `private` | Used to perform fallback routing if `RoutingMiddleware` was not added to the middleware stack. |
| `$routeParser` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | `private` | Passed to fallback `RoutingMiddleware` when routing has not yet run. |
| `$routeCollectorProxy` | `?RouteCollectorProxyInterface` | `private` | Optional proxy (typically `App`) from which `getBasePath()` is read and stored in `RouteContext::BASE_PATH`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteResolverInterface $routeResolver`, `RouteParserInterface $routeParser`, `?RouteCollectorProxyInterface $routeCollectorProxy = null` | `void` | Initializes the runner with the route resolver, route parser, and optional route collector proxy. |
| `handle` | `ServerRequestInterface $request` | `ResponseInterface` | Ensures routing has been performed, sets the `RouteContext::BASE_PATH` attribute, retrieves the matched [`Route`](#slim-routing-route) from `RouteContext::ROUTE`, and returns `$route->run($request)`. Throws [`HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) or [`HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) if routing fails. |

### Usage Example

```php
use Slim\Routing\RouteRunner;

// Instantiated automatically inside App::__construct(), or manually for custom kernels:
$runner = new RouteRunner(
    $app->getRouteResolver(),
    $app->getRouteCollector()->getRouteParser(),
    $app
);
$response = $runner->handle($request);
```

---

## `class` Slim\Routing\Dispatcher

- **Source**: `Slim/Routing/Dispatcher.php`
- **Namespace**: `Slim\Routing`
- **Implements**: [`Slim\Interfaces\DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface)

`Dispatcher` lazily constructs and wraps a [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) (`FastRoute\simpleDispatcher` or `FastRoute\cachedDispatcher` when `RouteCollector::getCacheFile()` is set), feeds all registered routes from [`RouteCollector`](#slim-routing-routecollector) into FastRoute (prefixed with `getBasePath()`), and wraps raw FastRoute results into [`RoutingResults`](#slim-routing-routingresults) objects.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Slim\Interfaces\DispatcherInterface;
use Slim\Interfaces\RouteCollectorInterface;

class Dispatcher implements DispatcherInterface
{
    private RouteCollectorInterface $routeCollector;
    private ?FastRouteDispatcher $dispatcher = null;

    public function __construct(RouteCollectorInterface $routeCollector);

    protected function createDispatcher(): FastRouteDispatcher;
    public function dispatch(string $method, string $uri): RoutingResults;
    public function getAllowedMethods(string $uri): array;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `private` | Source of registered routes, base path, and cache file configuration. |
| `$dispatcher` | `?FastRouteDispatcher` | `private` | Lazily initialized [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) instance. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector` | `void` | Stores the [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) instance. |
| `createDispatcher` *(protected)* | *(none)* | [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) | Lazily builds and caches the `FastRouteDispatcher` using `FastRoute\cachedDispatcher()` (if cache file is set) or `FastRoute\simpleDispatcher()`. |
| `dispatch` | `string $method`, `string $uri` | [`RoutingResults`](#slim-routing-routingresults) | Dispatches `$method` and `$uri` via `FastRouteDispatcher` and returns a [`RoutingResults`](#slim-routing-routingresults) instance. |
| `getAllowedMethods` | `string $uri` | `string[]` | Returns the list of allowed HTTP methods for `$uri` via `FastRouteDispatcher::getAllowedMethods()`. |

### Usage Example

```php
use Slim\Routing\Dispatcher;
use Slim\Routing\RouteResolver;

$dispatcher = new Dispatcher($app->getRouteCollector());
$resolver = new RouteResolver($app->getRouteCollector(), $dispatcher);

$routingResults = $dispatcher->dispatch('GET', '/health');
```

---

## `class` Slim\Routing\FastRouteDispatcher

- **Source**: `Slim/Routing/FastRouteDispatcher.php`
- **Namespace**: `Slim\Routing`
- **Extends**: `FastRoute\Dispatcher\GroupCountBased`

`FastRouteDispatcher` extends Nikic's `FastRoute\Dispatcher\GroupCountBased` to implement Slim-specific HTTP method fallback semantics (such as automatic `HEAD` -> `GET` fallback and wildcard `*` route matching) and efficient per-URI allowed-method inspection.

```drawlib align=center code=fold file=routing_dispatch_flow.png caption="FastRouteDispatcher::dispatch() — Multi-Stage Matching and Fallback Pipeline"
from drawlib.canvas import save, setup
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=76)

# Stage 1: Exact Method Match
rectangle(
    (30, 56),
    width=44,
    height=18,
    style=Styles.PrimaryFlat.patch(shape_r=2.5),
)
text((30, 60.5), "1. Exact Method", style=Styles.WhiteBold.patch(text_size=11.0))
text((30, 55.0), "staticRouteMap[M]", style=Styles.White.patch(text_size=10.0))
text((30, 50.0), "variableRouteData[M]", style=Styles.White.patch(text_size=10.0))

# Stage 2: HEAD -> GET Fallback
rectangle(
    (90, 56),
    width=44,
    height=18,
    style=Styles.PrimaryNeutral.patch(shape_r=2.5),
)
text((90, 60.5), "2. HEAD Fallback", style=Styles.BlackBold.patch(text_size=11.0))
text((90, 55.0), "If method == 'HEAD'", style=Styles.Dark.patch(text_size=10.0))
text((90, 50.0), "retry with 'GET'", style=Styles.Dark.patch(text_size=10.0))

# Stage 3: Wildcard '*' Fallback
rectangle(
    (150, 56),
    width=44,
    height=18,
    style=Styles.SecondaryNeutral.patch(shape_r=2.5),
)
text((150, 60.5), "3. Wildcard '*'", style=Styles.BlackBold.patch(text_size=11.0))
text((150, 55.0), "routingResults('*', uri)", style=Styles.Dark.patch(text_size=10.0))
text((150, 50.0), "Fallback routes", style=Styles.Dark.patch(text_size=10.0))

# Outcome Nodes (Bottom row)
rectangle(
    (36, 18),
    width=48,
    height=16,
    style=Styles.AccentFlat.patch(shape_r=2.5),
)
text((36, 21.0), "FOUND (1)", style=Styles.WhiteBold.patch(text_size=11.5))
text((36, 15.0), "[1, routeId, vars]", style=Styles.White.patch(text_size=10.0))

rectangle(
    (96, 18),
    width=48,
    height=16,
    style=Styles.Neutral.patch(shape_r=2.5),
)
text((96, 21.0), "METHOD_NOT_ALLOWED (2)", style=Styles.BlackBold.patch(text_size=10.0))
text((96, 15.0), "getAllowedMethods() != []", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (152, 18),
    width=40,
    height=16,
    style=Styles.Neutral.patch(shape_r=2.5),
)
text((152, 21.0), "NOT_FOUND (0)", style=Styles.BlackBold.patch(text_size=10.5))
text((152, 15.0), "[0, null, []]", style=Styles.Dark.patch(text_size=10.0))

# Horizontal miss transitions
line((52, 56), (68, 56), arrow_head="->", style=Styles.PrimaryBold)
text((60, 59.5), "Miss", style=Styles.Primary.patch(text_size=10.0))

line((112, 56), (128, 56), arrow_head="->", style=Styles.PrimaryBold)
text((120, 59.5), "Miss", style=Styles.Primary.patch(text_size=10.0))

# Match & Fallback arrows to outcomes
line((30, 47), (30, 26), arrow_head="->", style=Styles.PrimaryBold)
text((20, 36.5), "Match", style=Styles.PrimaryBold.patch(text_size=10.0))

line((80, 47), (46, 26), arrow_head="->", style=Styles.PrimaryBold)
line((140, 47), (56, 26), arrow_head="->", style=Styles.PrimaryBold)

line((150, 47), (104, 26), arrow_head="->", style=Styles.PrimaryBold)
line((156, 47), (156, 26), arrow_head="->", style=Styles.PrimaryBold)
text((166, 36.5), "No URI", style=Styles.Dark.patch(text_size=10.0))

save()
```

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use FastRoute\Dispatcher\GroupCountBased;

class FastRouteDispatcher extends GroupCountBased
{
    private ?string $allowedMethodsUri = null;
    private array $allowedMethods = [];

    /**
     * @param string $httpMethod
     * @param string $uri
     * @return array{int, string|null, array<string, string>}
     */
    public function dispatch($httpMethod, $uri): array;

    /**
     * @return array{int, string|null, array<string, string>}
     */
    private function routingResults(string $httpMethod, string $uri): array;

    /**
     * @return string[]
     */
    public function getAllowedMethods(string $uri): array;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$allowedMethodsUri` | `?string` | `private` | Last URI inspected by `getAllowedMethods()` for single-entry memoization. |
| `$allowedMethods` | `string[]` | `private` | Cached list of allowed HTTP methods for `$allowedMethodsUri`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `dispatch` | `string $httpMethod`, `string $uri` | `array{int, string\|null, array<string, string>}` | Attempts exact `$httpMethod` match, then `'GET'` fallback (if `HEAD`), then `'*'` fallback, then checks `getAllowedMethods($uri)` to distinguish `METHOD_NOT_ALLOWED` from `NOT_FOUND`. |
| `routingResults` *(private)* | `string $httpMethod`, `string $uri` | `array{int, string\|null, array<string, string>}` | Checks `$this->staticRouteMap[$httpMethod][$uri]` first, then `$this->variableRouteData[$httpMethod]` via `dispatchVariableRoute()`. |
| `getAllowedMethods` | `string $uri` | `string[]` | Scans all HTTP methods in `$staticRouteMap` and `$variableRouteData` for `$uri`, deduplicates and caches the matching methods, and returns them as `string[]`. |

### Usage Example

```php
use FastRoute\DataGenerator\GroupCountBased;
use FastRoute\RouteParser\Std;
use Slim\Routing\FastRouteDispatcher;

$dispatcher = \FastRoute\simpleDispatcher(function ($r) {
    $r->addRoute(['GET', 'POST'], '/items/{id:\d+}', 'route0');
}, [
    'dataGenerator' => GroupCountBased::class,
    'dispatcher' => FastRouteDispatcher::class,
    'routeParser' => new Std(),
]);

// HEAD automatically falls back to the GET route:
[$status, $routeId, $vars] = $dispatcher->dispatch('HEAD', '/items/42');
```

---

## `class` Slim\Routing\RoutingResults

- **Source**: `Slim/Routing/RoutingResults.php`
- **Namespace**: `Slim\Routing`

`RoutingResults` encapsulates the outcome of dispatching an HTTP method and URI through [`Dispatcher`](#slim-routing-dispatcher). It stores the status code (`NOT_FOUND`, `FOUND`, or `METHOD_NOT_ALLOWED`), the matched route identifier, decoded route arguments, and provides lazy lookup of allowed HTTP methods via its reference to [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface).

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Routing;

use Slim\Interfaces\DispatcherInterface;

/** @api */
class RoutingResults
{
    public const NOT_FOUND = 0;
    public const FOUND = 1;
    public const METHOD_NOT_ALLOWED = 2;

    protected DispatcherInterface $dispatcher;
    protected string $method;
    protected string $uri;
    protected int $routeStatus;
    protected ?string $routeIdentifier = null;
    protected array $routeArguments;

    public function __construct(
        DispatcherInterface $dispatcher,
        string $method,
        string $uri,
        int $routeStatus,
        ?string $routeIdentifier = null,
        array $routeArguments = []
    );

    public function getDispatcher(): DispatcherInterface;
    public function getMethod(): string;
    public function getUri(): string;
    public function getRouteStatus(): int;
    public function getRouteIdentifier(): ?string;
    public function getRouteArguments(bool $urlDecode = true): array;
    public function getAllowedMethods(): array;
}
```

### Constants & Properties

| Constant / Property | Type / Value | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `NOT_FOUND` | `0` | `public const` | No route pattern matched the requested URI (`404 Not Found`). |
| `FOUND` | `1` | `public const` | Both URI pattern and HTTP method matched a registered route (`200 OK`). |
| `METHOD_NOT_ALLOWED` | `2` | `public const` | URI pattern matched one or more routes, but not for the requested HTTP method (`405 Method Not Allowed`). |
| `$dispatcher` | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | `protected` | Dispatcher used to query allowed HTTP methods for `405` responses or `OPTIONS` requests. |
| `$method` | `string` | `protected` | Dispatched HTTP method string. |
| `$uri` | `string` | `protected` | Dispatched URL-decoded URI path string. |
| `$routeStatus` | `int` | `protected` | Dispatch status (`RoutingResults::NOT_FOUND`, `FOUND`, or `METHOD_NOT_ALLOWED`). |
| `$routeIdentifier` | `?string` | `protected` | Matched internal route identifier (e.g. `'route0'`), or `null` when not found. |
| `$routeArguments` | `array<string, string>` | `protected` | Extracted placeholder key-value pairs from the URI path. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `DispatcherInterface $dispatcher`, `string $method`, `string $uri`, `int $routeStatus`, `?string $routeIdentifier = null`, `array<string, string> $routeArguments = []` | `void` | Initializes the routing results object with dispatch outcome details. |
| `getDispatcher` | *(none)* | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | Returns the associated [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface). |
| `getMethod` | *(none)* | `string` | Returns the HTTP request method that was dispatched. |
| `getUri` | *(none)* | `string` | Returns the decoded URI path that was dispatched. |
| `getRouteStatus` | *(none)* | `int` | Returns `RoutingResults::NOT_FOUND` (`0`), `FOUND` (`1`), or `METHOD_NOT_ALLOWED` (`2`). |
| `getRouteIdentifier` | *(none)* | `?string` | Returns the matched route identifier or `null`. |
| `getRouteArguments` | `bool $urlDecode = true` | `array<string, string>` | Returns the extracted route arguments (already URL-decoded by `RouteResolver`; `$urlDecode` is retained for backwards compatibility). |
| `getAllowedMethods` | *(none)* | `string[]` | Delegates to `$this->dispatcher->getAllowedMethods($this->uri)` to list all valid HTTP methods for the URI. |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Routing\RouteContext;
use Slim\Routing\RoutingResults;

// Inspecting RoutingResults inside a custom CORS preflight middleware
$routingResults = RouteContext::fromRequest($request)->getRoutingResults();

if ($routingResults->getRouteStatus() === RoutingResults::FOUND) {
    $allowedMethods = $routingResults->getAllowedMethods();
    $response = $response->withHeader('Allow', implode(', ', $allowedMethods));
}
```
