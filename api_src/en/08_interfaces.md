# Contract Interfaces (`Slim\Interfaces\*`)

The `Slim\Interfaces` namespace (`17` interfaces across `17` files in `Slim/Interfaces/`) defines the complete architectural contract surface of Slim Framework `v4.15.3`. Every subsystem—PSR-17 factory auto-discovery, container-aware callable resolution, LIFO PSR-15 middleware dispatching, FastRoute regex routing, route invocation strategies, and content-negotiated error rendering—is decoupled behind a dedicated interface so applications can swap any default implementation via [`AppFactory`](01_app_and_factories.md#slim-app) or a PSR-11 DI container.

```drawlib align=center code=fold file=api_interfaces_domain_map.png caption="Slim\Interfaces Contract Taxonomy — 17 Interfaces Across Routing, PSR-17 Bootstrap, Middleware, Strategies, and Error Handling"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=90, dpi=150)

# Left Panel: Routing & FastRoute Dispatching Contracts (7 Interfaces)
p_left = Panel(
    "Routing & Dispatching Contracts (7)",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.git_branch,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_left.draw((4.0, 4.0), width=92.0, height=82.0)
lx, lw, lh = p_left.get_content_box((4.0, 4.0), width=92.0, height=82.0, padding=(3.5, 3.0))

cl_left = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.6,
    show_arrows=True,
    arrow_style=Styles.DarkBold.patch(line_arrow_head_scale=10, line_width=1.4),
)
cl_left.add(
    "RouteCollectorProxy & RouteCollector",
    "HTTP verb registration (get/post/map/group)",
    badge_text="R1",
    icon=phosphor.compass,
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
)
cl_left.add(
    "RouteInterface & RouteGroupInterface",
    "Per-route & group middleware stacks + run()",
    badge_text="R2",
    icon=phosphor.brackets_curly,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "RouteParserInterface",
    "Reverse URL generation (relativeUrlFor/urlFor)",
    badge_text="R3",
    icon=phosphor.link,
)
cl_left.add(
    "RouteResolver & DispatcherInterface",
    "FastRoute URI matching -> RoutingResults",
    badge_text="R4",
    icon=phosphor.lightning,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: PSR-17, Callable, Middleware & Error Contracts (10 Interfaces)
p_right = Panel(
    "PSR-17, Callable, Middleware & Error (10)",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.plugs_connected,
    icon_style=Styles.SecondaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_right.draw((100.0, 4.0), width=92.0, height=82.0)
rx, rw, rh = p_right.get_content_box((100.0, 4.0), width=92.0, height=82.0, padding=(3.5, 3.0))

cl_right = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
    icon_style=Styles.SecondaryBold,
    direction="vertical",
    spacing=2.6,
)
cl_right.add(
    "Psr17Factory, Provider & RequestCreator",
    "Auto-detect PSR-17 factories & globals creator",
    badge_text="P17",
    icon=phosphor.factory,
)
cl_right.add(
    "CallableResolver & AdvancedCallable",
    "Resolve 'Class:method' & DI service callables",
    badge_text="DI",
    icon=phosphor.code,
    style=Styles.PrimaryNeutral,
)
cl_right.add(
    "MiddlewareDispatcher & Strategies",
    "LIFO PSR-15 stack & 2 invocation contracts",
    badge_text="P15",
    icon=phosphor.stack,
    style=Styles.AccentFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
    icon_style=Styles.SecondaryBold,
)
cl_right.add(
    "ErrorHandler & ErrorRendererInterface",
    "Exception -> PSR-7 Response & MIME payload",
    badge_text="Err",
    icon=phosphor.shield_warning,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_right.draw(xy=rx, width=rw, height=rh)

save()
```

### Summary Matrix of All 17 `Slim\Interfaces\*` Contracts

| Interface | Source File | Extends | Default Implementation(s) |
| :--- | :--- | :--- | :--- |
| [`AdvancedCallableResolverInterface`](#slim-interfaces-advancedcallableresolverinterface) | `Slim/Interfaces/AdvancedCallableResolverInterface.php` | [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) |
| [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | `Slim/Interfaces/CallableResolverInterface.php` | — | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) |
| [`DispatcherInterface`](#slim-interfaces-dispatcherinterface) | `Slim/Interfaces/DispatcherInterface.php` | — | [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) |
| [`ErrorHandlerInterface`](#slim-interfaces-errorhandlerinterface) | `Slim/Interfaces/ErrorHandlerInterface.php` | — | [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) |
| [`ErrorRendererInterface`](#slim-interfaces-errorrendererinterface) | `Slim/Interfaces/ErrorRendererInterface.php` | — | [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer), [`JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer), `HtmlErrorRenderer`, `PlainTextErrorRenderer`, `XmlErrorRenderer` |
| [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | `Slim/Interfaces/InvocationStrategyInterface.php` | — | [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse), `RequestResponseArgs`, `RequestResponseNamedArgs`, [`RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) |
| [`MiddlewareDispatcherInterface`](#slim-interfaces-middlewaredispatcherinterface) | `Slim/Interfaces/MiddlewareDispatcherInterface.php` | `Psr\Http\Server\RequestHandlerInterface` | [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) |
| [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) | `Slim/Interfaces/Psr17FactoryInterface.php` | — | [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) (+ 6 concrete provider classes) |
| [`Psr17FactoryProviderInterface`](#slim-interfaces-psr17factoryproviderinterface) | `Slim/Interfaces/Psr17FactoryProviderInterface.php` | — | [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) |
| [`RequestHandlerInvocationStrategyInterface`](#slim-interfaces-requesthandlerinvocationstrategyinterface) | `Slim/Interfaces/RequestHandlerInvocationStrategyInterface.php` | [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) |
| [`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) | `Slim/Interfaces/RouteCollectorInterface.php` | — | [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) |
| [`RouteCollectorProxyInterface`](#slim-interfaces-routecollectorproxyinterface) | `Slim/Interfaces/RouteCollectorProxyInterface.php` | — | [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app) |
| [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | `Slim/Interfaces/RouteGroupInterface.php` | — | [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) |
| [`RouteInterface`](#slim-interfaces-routeinterface) | `Slim/Interfaces/RouteInterface.php` | — | [`Slim\Routing\Route`](03_routing.md#slim-routing-route) |
| [`RouteParserInterface`](#slim-interfaces-routeparserinterface) | `Slim/Interfaces/RouteParserInterface.php` | — | [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) |
| [`RouteResolverInterface`](#slim-interfaces-routeresolverinterface) | `Slim/Interfaces/RouteResolverInterface.php` | — | [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) |
| [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) | `Slim/Interfaces/ServerRequestCreatorInterface.php` | — | `Slim\Factory\Psr17\ServerRequestCreator`, `SlimHttpServerRequestCreator` |

```drawlib align=center code=fold file=api_interfaces_wiring_lifecycle.png caption="Contract Inheritance Pairs and Default Implementation Wiring in Slim\App"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=84, dpi=150)

# Left Panel: 3 Specialized Sub-Interface Extensions
p_left = Panel(
    "Contract Inheritance Extensions (3 Pairs)",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.git_fork,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_left.draw((4.0, 4.0), width=92.0, height=76.0)
lx, lw, lh = p_left.get_content_box((4.0, 4.0), width=92.0, height=76.0, padding=(3.5, 3.0))

cl_left = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.8,
)
cl_left.add(
    "MiddlewareDispatcherInterface",
    "Extends PSR-15 RequestHandlerInterface",
    badge_text="P15",
    icon=phosphor.stack,
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
)
cl_left.add(
    "AdvancedCallableResolverInterface",
    "Extends CallableResolverInterface (+2 methods)",
    badge_text="DI",
    icon=phosphor.plugs_connected,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "RequestHandlerInvocationStrategy",
    "Marker extending InvocationStrategyInterface",
    badge_text="Tag",
    icon=phosphor.tag,
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: Default Kernel Wiring in App::__construct()
p_right = Panel(
    "App::__construct() Default Contract Wiring",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.gear,
    icon_style=Styles.SecondaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_right.draw((100.0, 4.0), width=92.0, height=76.0)
rx, rw, rh = p_right.get_content_box((100.0, 4.0), width=92.0, height=76.0, padding=(3.5, 3.0))

cl_right = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.SecondaryNeutral,
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
    icon_style=Styles.SecondaryBold,
    direction="vertical",
    spacing=2.8,
    show_arrows=True,
    arrow_style=Styles.DarkBold.patch(line_arrow_head_scale=10, line_width=1.4),
)
cl_right.add(
    "CallableResolverInterface",
    "Defaults to new CallableResolver(container)",
    badge_text="W1",
    icon=phosphor.code,
)
cl_right.add(
    "RouteCollector & RouteResolverInterface",
    "Defaults to RouteCollector + RouteResolver",
    badge_text="W2",
    icon=phosphor.compass,
    style=Styles.SecondaryNeutral,
)
cl_right.add(
    "MiddlewareDispatcherInterface",
    "Seeded with RouteRunner -> wraps PSR-15 onion",
    badge_text="W3",
    icon=phosphor.play_circle,
    style=Styles.AccentFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
    icon_style=Styles.SecondaryBold,
)
cl_right.draw(xy=rx, width=rw, height=rh)

save()
```

---

## `interface` Slim\Interfaces\AdvancedCallableResolverInterface

- **Source File**: `Slim/Interfaces/AdvancedCallableResolverInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Extends**: [`Slim\Interfaces\CallableResolverInterface`](#slim-interfaces-callableresolverinterface)
- **Default Implementation**: [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver)
- **Consumed By**: [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher), [`Slim\Routing\Route`](03_routing.md#slim-routing-route), [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup), [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware), [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)

Extends [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) with context-specific resolution methods (`resolveRoute()` and `resolveMiddleware()`). When a single class name or container service ID is passed without a `:method` suffix, [`CallableResolver`](01_app_and_factories.md#slim-callableresolver) uses `resolveRoute()` to look for `handle()` (PSR-15 `RequestHandlerInterface`) and `resolveMiddleware()` to look for `process()` (PSR-15 `MiddlewareInterface`).

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

interface AdvancedCallableResolverInterface extends CallableResolverInterface
{
    /**
     * Resolve $toResolve into a callable
     *
     * @param callable|array{class-string, string}|string $toResolve
     */
    public function resolveRoute($toResolve): callable;

    /**
     * Resolve $toResolve into a callable
     *
     * @param callable|array{class-string, string}|string $toResolve
     */
    public function resolveMiddleware($toResolve): callable;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `resolveRoute()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | Resolves a route handler definition into a PHP `callable` (binding `RequestHandlerInterface::handle` when `$toResolve` resolves to a PSR-15 request handler instance). |
| `resolveMiddleware()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | Resolves a middleware definition into a PHP `callable` (binding `MiddlewareInterface::process` when `$toResolve` resolves to a PSR-15 middleware instance). |
| `resolve()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | Inherited from [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface). |

### Usage Example

```php
use Slim\CallableResolver;
use Slim\Interfaces\AdvancedCallableResolverInterface;

/** @var AdvancedCallableResolverInterface $resolver */
$resolver = new CallableResolver($container);

// Resolves a PSR-15 RequestHandlerInterface class string to [$instance, 'handle']:
$routeCallable = $resolver->resolveRoute(ShowUserAction::class);

// Resolves a PSR-15 MiddlewareInterface class string to [$instance, 'process']:
$middlewareCallable = $resolver->resolveMiddleware(AuthMiddleware::class);
```

---

## `interface` Slim\Interfaces\CallableResolverInterface

- **Source File**: `Slim/Interfaces/CallableResolverInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Extended By**: [`Slim\Interfaces\AdvancedCallableResolverInterface`](#slim-interfaces-advancedcallableresolverinterface)
- **Default Implementation**: [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver)

Defines the base contract for resolving string notations (`'Class:method'`, `'Class::method'`, or PSR-11 container service identifiers), `['Class', 'method']` tuples, or invokable classes into executable PHP `callable` instances.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

interface CallableResolverInterface
{
    /**
     * Resolve $toResolve into a callable
     *
     * @param callable|array{class-string, string}|string $toResolve
     */
    public function resolve($toResolve): callable;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `resolve()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | Resolves `$toResolve` into an executable `callable` or throws `\RuntimeException` if the target is not callable or cannot be instantiated. |

### Usage Example

```php
use Slim\CallableResolver;
use Slim\Interfaces\CallableResolverInterface;

/** @var CallableResolverInterface $resolver */
$resolver = new CallableResolver($container);

// Resolves Slim's 'Class:method' notation via container or `new HomeController()`:
$callable = $resolver->resolve('App\Controller\HomeController:index');
```

---

## `interface` Slim\Interfaces\DispatcherInterface

- **Source File**: `Slim/Interfaces/DispatcherInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher)
- **Consumed By**: [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver), `Slim\Routing\RoutingResults`

Defines the contract wrapping the underlying URL router (FastRoute's `FastRouteDispatcher`) to match an HTTP request method and URI path into a `Slim\Routing\RoutingResults` value object and inspect allowed HTTP methods for a given URI.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Slim\Routing\RoutingResults;

interface DispatcherInterface
{
    /**
     * Get routing results for a given request method and uri
     */
    public function dispatch(string $method, string $uri): RoutingResults;

    /**
     * Get allowed methods for a given uri
     *
     * @return string[]
     */
    public function getAllowedMethods(string $uri): array;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `dispatch()` | `string $method`, `string $uri` | `RoutingResults` | Matches `$method` and `$uri` against registered routes and returns a `RoutingResults` instance (`NOT_FOUND`, `FOUND`, or `METHOD_NOT_ALLOWED`). |
| `getAllowedMethods()` | `string $uri` | `string[]` | Returns the deduplicated list of HTTP methods supported for `$uri`. |

### Usage Example

```php
use Slim\Interfaces\DispatcherInterface;
use Slim\Routing\Dispatcher;
use Slim\Routing\RoutingResults;

/** @var DispatcherInterface $dispatcher */
$dispatcher = new Dispatcher($routeCollector);

$results = $dispatcher->dispatch('GET', '/users/42');
if ($results->getRouteStatus() === RoutingResults::FOUND) {
    $routeId = $results->getRouteIdentifier();
    $args = $results->getRouteArguments(); // ['id' => '42']
}
```

---

## `interface` Slim\Interfaces\ErrorHandlerInterface

- **Source File**: `Slim/Interfaces/ErrorHandlerInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)
- **Consumed By**: [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware)

Defines the invokable contract for exception handlers registered with [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware). Any custom error handler class implementing `ErrorHandlerInterface` receives the active PSR-7 request, the caught `\Throwable`, and three boolean diagnostic flags, and returns a PSR-7 `ResponseInterface`.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Throwable;

interface ErrorHandlerInterface
{
    public function __invoke(
        ServerRequestInterface $request,
        Throwable $exception,
        bool $displayErrorDetails,
        bool $logErrors,
        bool $logErrorDetails
    ): ResponseInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `ServerRequestInterface $request`, `Throwable $exception`, `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails` | `ResponseInterface` | Handles `$exception` (optionally logging when `$logErrors` is `true` and including trace details when `$displayErrorDetails` is `true`) and returns an HTTP error `ResponseInterface`. |

### Usage Example

```php
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\ErrorHandlerInterface;
use Throwable;

final class CustomJsonErrorHandler implements ErrorHandlerInterface
{
    private ResponseFactoryInterface $responseFactory;

    public function __construct(ResponseFactoryInterface $responseFactory)
    {
        $this->responseFactory = $responseFactory;
    }

    public function __invoke(
        ServerRequestInterface $request,
        Throwable $exception,
        bool $displayErrorDetails,
        bool $logErrors,
        bool $logErrorDetails
    ): ResponseInterface {
        $response = $this->responseFactory->createResponse(500);
        $payload = ['error' => $displayErrorDetails ? $exception->getMessage() : 'Server Error'];
        $response->getBody()->write(json_encode($payload, JSON_THROW_ON_ERROR));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
```

---

## `interface` Slim\Interfaces\ErrorRendererInterface

- **Source File**: `Slim/Interfaces/ErrorRendererInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementations**: [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer), [`Slim\Error\Renderers\JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer), `Slim\Error\Renderers\HtmlErrorRenderer`, `Slim\Error\Renderers\PlainTextErrorRenderer`, `Slim\Error\Renderers\XmlErrorRenderer`
- **Consumed By**: [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)

Defines the invokable contract for formatting a caught `\Throwable` into a serialized string body (HTML, JSON, XML, PlainText, or Problem Details) based on content negotiation inside [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler).

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Throwable;

interface ErrorRendererInterface
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Serializes `$exception` into a response body string, including full exception messages and stack traces only when `$displayErrorDetails` is `true`. |

### Usage Example

```php
use Slim\Interfaces\ErrorRendererInterface;
use Throwable;

final class ProblemDetailsJsonRenderer implements ErrorRendererInterface
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string
    {
        return json_encode([
            'type' => 'https://example.com/probs/error',
            'title' => $exception->getMessage(),
            'status' => $exception->getCode() ?: 500,
        ], JSON_THROW_ON_ERROR);
    }
}
```

---

## `interface` Slim\Interfaces\InvocationStrategyInterface

- **Source File**: `Slim/Interfaces/InvocationStrategyInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Extended By**: [`Slim\Interfaces\RequestHandlerInvocationStrategyInterface`](#slim-interfaces-requesthandlerinvocationstrategyinterface)
- **Default Implementations**: [`Slim\Handlers\Strategies\RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) *(default)*, `Slim\Handlers\Strategies\RequestResponseArgs`, `Slim\Handlers\Strategies\RequestResponseNamedArgs`, [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler)
- **Consumed By**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

Defines the strategy contract for invoking a matched route's callable with the PSR-7 `ServerRequestInterface`, `ResponseInterface`, and extracted FastRoute URI placeholder arguments (`array<string, string>`).

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;

/**
 * Defines a contract for invoking a route callable.
 */
interface InvocationStrategyInterface
{
    /**
     * Invoke a route callable.
     *
     * @param callable               $callable       The callable to invoke using the strategy.
     * @param ServerRequestInterface $request        The request object.
     * @param ResponseInterface      $response       The response object.
     * @param array<string, string>  $routeArguments The route's placeholder arguments
     *
     * @return ResponseInterface The response from the callable.
     */
    public function __invoke(
        callable $callable,
        ServerRequestInterface $request,
        ResponseInterface $response,
        array $routeArguments
    ): ResponseInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Invokes `$callable` using the strategy's parameter convention and returns the resulting PSR-7 `ResponseInterface`. |

### Usage Example

```php
use Slim\Handlers\Strategies\RequestResponseArgs;

// Switch the application's default route invocation strategy so route placeholders
// are unpacked as positional arguments: function ($request, $response, $id, $slug)
$routeCollector = $app->getRouteCollector();
$routeCollector->setDefaultInvocationStrategy(new RequestResponseArgs());
```

---

## `interface` Slim\Interfaces\MiddlewareDispatcherInterface

- **Source File**: `Slim/Interfaces/MiddlewareDispatcherInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Extends**: `Psr\Http\Server\RequestHandlerInterface`
- **Default Implementation**: [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher)
- **Consumed By**: [`Slim\App`](01_app_and_factories.md#slim-app), `Slim\Factory\AppFactory`, [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

Defines the contract for Slim's Last-In-First-Out (LIFO) concentric PSR-15 middleware stack. Because it extends `Psr\Http\Server\RequestHandlerInterface`, any `MiddlewareDispatcherInterface` implementation also provides `handle(ServerRequestInterface $request): ResponseInterface`.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/** @api */
interface MiddlewareDispatcherInterface extends RequestHandlerInterface
{
    /**
     * Add a new middleware to the stack
     *
     * Middleware are organized as a stack. That means middleware
     * that have been added before will be executed after the newly
     * added one (last in, first out).
     *
     * @param MiddlewareInterface|string|callable $middleware
     */
    public function add($middleware): self;

    /**
     * Add a new middleware to the stack
     *
     * Middleware are organized as a stack. That means middleware
     * that have been added before will be executed after the newly
     * added one (last in, first out).
     */
    public function addMiddleware(MiddlewareInterface $middleware): self;

    /**
     * Seed the middleware stack with the inner request handler
     */
    public function seedMiddlewareStack(RequestHandlerInterface $kernel): void;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `add()` | `MiddlewareInterface\|string\|callable $middleware` | `self` | Wraps a PSR-15 `MiddlewareInterface`, callable, or deferred class/container string onto the outer layer of the LIFO middleware stack. |
| `addMiddleware()` | `MiddlewareInterface $middleware` | `self` | Wraps a typed PSR-15 `MiddlewareInterface` instance onto the outer layer of the LIFO stack. |
| `seedMiddlewareStack()` | `RequestHandlerInterface $kernel` | `void` | Seeds the innermost core of the middleware stack with `$kernel` (e.g., `RouteRunner` or `Route`). |
| `handle()` | `ServerRequestInterface $request` | `ResponseInterface` | Inherited from `Psr\Http\Server\RequestHandlerInterface`; executes the outermost middleware tip. |

### Usage Example

```php
use Slim\Interfaces\MiddlewareDispatcherInterface;

/** @var MiddlewareDispatcherInterface $dispatcher */
$dispatcher = $app->getMiddlewareDispatcher();
$dispatcher->add(CorrelationIdMiddleware::class);
```

---

## `interface` Slim\Interfaces\Psr17FactoryInterface

- **Source File**: `Slim/Interfaces/Psr17FactoryInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Base Implementation**: [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) (extended by `SlimPsr17Factory`, `HttpSoftPsr17Factory`, `NyholmPsr17Factory`, `LaminasDiactorosPsr17Factory`, `GuzzlePsr17Factory`, `SlimHttpPsr17Factory`)
- **Consumed By**: `Slim\Factory\AppFactory`, `Slim\Factory\ServerRequestCreatorFactory`

Defines the static adapter contract used during zero-configuration bootstrap to probe whether a given PSR-7 / PSR-17 library is installed (`isResponseFactoryAvailable()`, `isStreamFactoryAvailable()`, `isServerRequestCreatorAvailable()`) and instantiate its `ResponseFactoryInterface`, `StreamFactoryInterface`, or [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface).

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\StreamFactoryInterface;
use RuntimeException;

interface Psr17FactoryInterface
{
    /**
     * @throws RuntimeException when the factory could not be instantiated
     */
    public static function getResponseFactory(): ResponseFactoryInterface;

    /**
     * @throws RuntimeException when the factory could not be instantiated
     */
    public static function getStreamFactory(): StreamFactoryInterface;

    /**
     * @throws RuntimeException when the factory could not be instantiated
     */
    public static function getServerRequestCreator(): ServerRequestCreatorInterface;

    /**
     * Is the PSR-17 ResponseFactory available
     */
    public static function isResponseFactoryAvailable(): bool;

    /**
     * Is the PSR-17 StreamFactory available
     */
    public static function isStreamFactoryAvailable(): bool;

    /**
     * Is the ServerRequest creator available
     */
    public static function isServerRequestCreatorAvailable(): bool;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getResponseFactory()` | *(none, static)* | `ResponseFactoryInterface` | Instantiates and returns the provider's PSR-17 `ResponseFactoryInterface` (or throws `\RuntimeException`). |
| `getStreamFactory()` | *(none, static)* | `StreamFactoryInterface` | Instantiates and returns the provider's PSR-17 `StreamFactoryInterface` (or throws `\RuntimeException`). |
| `getServerRequestCreator()` | *(none, static)* | [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) | Instantiates and returns the provider's [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) (or throws `\RuntimeException`). |
| `isResponseFactoryAvailable()` | *(none, static)* | `bool` | Returns `true` if the provider's response factory class is installed and autoloadable. |
| `isStreamFactoryAvailable()` | *(none, static)* | `bool` | Returns `true` if the provider's stream factory class is installed and autoloadable. |
| `isServerRequestCreatorAvailable()` | *(none, static)* | `bool` | Returns `true` if the provider's server request creator class and method are available. |

### Usage Example

```php
use Slim\Factory\Psr17\NyholmPsr17Factory;

if (NyholmPsr17Factory::isResponseFactoryAvailable()) {
    $responseFactory = NyholmPsr17Factory::getResponseFactory();
}
```

---

## `interface` Slim\Interfaces\Psr17FactoryProviderInterface

- **Source File**: `Slim/Interfaces/Psr17FactoryProviderInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider)
- **Consumed By**: `Slim\Factory\AppFactory`, `Slim\Factory\ServerRequestCreatorFactory`

Defines the registry contract for managing the ordered list of [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) class names probed during `AppFactory::determineResponseFactory()` and `ServerRequestCreatorFactory::determineServerRequestCreator()`.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

/** @api */
interface Psr17FactoryProviderInterface
{
    /**
     * @return string[]
     */
    public static function getFactories(): array;

    /**
     * @param string[] $factories
     */
    public static function setFactories(array $factories): void;

    public static function addFactory(string $factory): void;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getFactories()` | *(none, static)* | `string[]` | Returns the ordered array of [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) class strings. |
| `setFactories()` | `string[] $factories` *(static)* | `void` | Replaces the registered list of PSR-17 factory adapter class strings. |
| `addFactory()` | `string $factory` *(static)* | `void` | Prepends a custom [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) class string to the provider registry. |

### Usage Example

```php
use Slim\Factory\Psr17\Psr17FactoryProvider;

// Prepend a custom PSR-17 factory adapter to take highest auto-discovery priority:
Psr17FactoryProvider::addFactory(CustomPsr17Factory::class);
```

---

## `interface` Slim\Interfaces\RequestHandlerInvocationStrategyInterface

- **Source File**: `Slim/Interfaces/RequestHandlerInvocationStrategyInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Extends**: [`Slim\Interfaces\InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface)
- **Default Implementation**: [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler)

Marker sub-interface extending [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) for route invocation strategies that invoke PSR-15 `RequestHandlerInterface`-style callables (`callable(ServerRequestInterface): ResponseInterface`) directly.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

interface RequestHandlerInvocationStrategyInterface extends InvocationStrategyInterface
{
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Inherited from [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface). |

### Usage Example

```php
use Slim\Handlers\Strategies\RequestHandler;
use Slim\Interfaces\RequestHandlerInvocationStrategyInterface;

/** @var RequestHandlerInvocationStrategyInterface $strategy */
$strategy = new RequestHandler(true); // pass route arguments as request attributes
$app->getRouteCollector()->setDefaultInvocationStrategy($strategy);
```

---

## `interface` Slim\Interfaces\RouteCollectorInterface

- **Source File**: `Slim/Interfaces/RouteCollectorInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector)
- **Consumed By**: [`Slim\App`](01_app_and_factories.md#slim-app), [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher), [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser), [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver)

Defines the central route registry contract responsible for storing [`RouteInterface`](#slim-interfaces-routeinterface) and [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) definitions, managing the default [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface), configuring FastRoute's compiled PHP cache file, and looking up routes by name or internal identifier (`route0`, `route1`, ...).

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use InvalidArgumentException;
use RuntimeException;

/** @api */
interface RouteCollectorInterface
{
    /**
     * Get the route parser
     */
    public function getRouteParser(): RouteParserInterface;

    /**
     * Get default route invocation strategy
     */
    public function getDefaultInvocationStrategy(): InvocationStrategyInterface;

    /**
     * Set default route invocation strategy
     */
    public function setDefaultInvocationStrategy(InvocationStrategyInterface $strategy): RouteCollectorInterface;

    /**
     * Get path to FastRoute cache file
     */
    public function getCacheFile(): ?string;

    /**
     * Set path to FastRoute cache file
     *
     * @throws InvalidArgumentException
     * @throws RuntimeException
     */
    public function setCacheFile(string $cacheFile): RouteCollectorInterface;

    /**
     * Get the base path used in pathFor()
     */
    public function getBasePath(): string;

    /**
     * Set the base path used in pathFor()
     */
    public function setBasePath(string $basePath): RouteCollectorInterface;

    /**
     * Get route objects
     *
     * @return RouteInterface[]
     */
    public function getRoutes(): array;

    /**
     * Get named route object
     *
     * @param string $name Route name
     *
     * @throws RuntimeException   If named route does not exist
     */
    public function getNamedRoute(string $name): RouteInterface;

    /**
     * Remove named route
     *
     * @param string $name Route name
     *
     * @throws RuntimeException   If named route does not exist
     */
    public function removeNamedRoute(string $name): RouteCollectorInterface;

    /**
     * Lookup a route via the route's unique identifier
     *
     * @throws RuntimeException   If route of identifier does not exist
     */
    public function lookupRoute(string $identifier): RouteInterface;

    /**
     * Add route group
     * @param string|callable $callable
     */
    public function group(string $pattern, $callable): RouteGroupInterface;

    /**
     * Add route
     *
     * @param string[] $methods Array of HTTP methods
     * @param string $pattern The route pattern
     * @param callable|array{class-string, string}|string $handler The route callable
     */
    public function map(array $methods, string $pattern, $handler): RouteInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getRouteParser()` | *(none)* | [`RouteParserInterface`](#slim-interfaces-routeparserinterface) | Returns the associated route parser for reverse URL generation. |
| `getDefaultInvocationStrategy()` | *(none)* | [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | Returns the default invocation strategy (defaults to [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse)). |
| `setDefaultInvocationStrategy()` | `InvocationStrategyInterface $strategy` | `RouteCollectorInterface` | Sets the default invocation strategy for newly registered routes. |
| `getCacheFile()` | *(none)* | `?string` | Returns the path to the FastRoute dispatch cache file, or `null` if disabled. |
| `setCacheFile()` | `string $cacheFile` | `RouteCollectorInterface` | Sets the path to the FastRoute cache file (validating readability/writability). |
| `getBasePath()` | *(none)* | `string` | Returns the application base path prefix. |
| `setBasePath()` | `string $basePath` | `RouteCollectorInterface` | Sets the base path prefix used when registering and generating route URLs. |
| `getRoutes()` | *(none)* | `RouteInterface[]` | Returns all registered [`RouteInterface`](#slim-interfaces-routeinterface) objects keyed by route identifier. |
| `getNamedRoute()` | `string $name` | [`RouteInterface`](#slim-interfaces-routeinterface) | Looks up a route by its assigned name or throws `\RuntimeException`. |
| `removeNamedRoute()` | `string $name` | `RouteCollectorInterface` | Removes a named route from the collector or throws `\RuntimeException`. |
| `lookupRoute()` | `string $identifier` | [`RouteInterface`](#slim-interfaces-routeinterface) | Looks up a route by its internal identifier (e.g., `'route0'`) or throws `\RuntimeException`. |
| `group()` | `string $pattern`, `string\|callable $callable` | [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | Creates a route group prefixing all routes registered inside `$callable` with `$pattern`. |
| `map()` | `string[] $methods`, `string $pattern`, `callable\|array\|string $handler` | [`RouteInterface`](#slim-interfaces-routeinterface) | Registers a new route for `$methods` and `$pattern` and returns the created [`RouteInterface`](#slim-interfaces-routeinterface). |

### Usage Example

```php
$collector = $app->getRouteCollector();
$collector->setCacheFile(__DIR__ . '/../var/cache/fastroute.php');

$route = $collector->getNamedRoute('users.show');
```

---

## `interface` Slim\Interfaces\RouteCollectorProxyInterface

- **Source File**: `Slim/Interfaces/RouteCollectorProxyInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Template Annotation**: `@template TContainerInterface of (ContainerInterface|null)`
- **Default Implementations**: [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app)

Defines the fluent user-facing routing API shared by both [`Slim\App`](01_app_and_factories.md#slim-app) and nested route group callbacks (`$app->group('/v1', function (RouteCollectorProxyInterface $group) { ... })`). Provides convenience methods for all standard HTTP verbs (`get()`, `post()`, `put()`, `patch()`, `delete()`, `options()`, `any()`), `map()`, `group()`, and `redirect()`.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Container\ContainerInterface;
use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\UriInterface;

/**
 * @api
 * @template TContainerInterface of (ContainerInterface|null)
 */
interface RouteCollectorProxyInterface
{
    public function getResponseFactory(): ResponseFactoryInterface;

    public function getCallableResolver(): CallableResolverInterface;

    /**
     * @return TContainerInterface
     */
    public function getContainer(): ?ContainerInterface;

    public function getRouteCollector(): RouteCollectorInterface;

    /**
     * Get the RouteCollectorProxy's base path
     */
    public function getBasePath(): string;

    /**
     * Set the RouteCollectorProxy's base path
     * @return RouteCollectorProxyInterface<TContainerInterface>
     */
    public function setBasePath(string $basePath): RouteCollectorProxyInterface;

    /**
     * Add GET route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function get(string $pattern, $callable): RouteInterface;

    /**
     * Add POST route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function post(string $pattern, $callable): RouteInterface;

    /**
     * Add PUT route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function put(string $pattern, $callable): RouteInterface;

    /**
     * Add PATCH route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function patch(string $pattern, $callable): RouteInterface;

    /**
     * Add DELETE route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function delete(string $pattern, $callable): RouteInterface;

    /**
     * Add OPTIONS route
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function options(string $pattern, $callable): RouteInterface;

    /**
     * Add route for any HTTP method
     *
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function any(string $pattern, $callable): RouteInterface;

    /**
     * Add route with multiple methods
     *
     * @param string[] $methods Numeric array of HTTP method names
     * @param string $pattern The route URI pattern
     * @param callable|array{class-string, string}|string $callable The route callback routine
     */
    public function map(array $methods, string $pattern, $callable): RouteInterface;

    /**
     * Route Groups
     *
     * This method accepts a route pattern and a callback. All route
     * declarations in the callback will be prepended by the group(s)
     * that it is in.
     * @param string|callable $callable
     */
    public function group(string $pattern, $callable): RouteGroupInterface;

    /**
     * Add a route that sends an HTTP redirect
     *
     * @param string|UriInterface $to
     */
    public function redirect(string $from, $to, int $status = 302): RouteInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getResponseFactory()` | *(none)* | `ResponseFactoryInterface` | Returns the configured PSR-17 response factory. |
| `getCallableResolver()` | *(none)* | [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | Returns the callable resolver. |
| `getContainer()` | *(none)* | `?ContainerInterface` | Returns the PSR-11 container instance, or `null` if none is configured. |
| `getRouteCollector()` | *(none)* | [`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) | Returns the underlying route collector. |
| `getBasePath()` / `setBasePath()` | `string $basePath` | `string` / `RouteCollectorProxyInterface` | Gets or sets the base path on the underlying route collector. |
| `get()` / `post()` / `put()` / `patch()` / `delete()` / `options()` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | Registers a route for the corresponding single HTTP verb. |
| `any()` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | Registers a route matching `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, and `OPTIONS`. |
| `map()` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | Registers a route matching the specified HTTP methods array. |
| `group()` | `string $pattern`, `string\|callable $callable` | [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | Registers a route group sharing a common URI prefix and middleware stack. |
| `redirect()` | `string $from`, `string\|UriInterface $to`, `int $status = 302` | [`RouteInterface`](#slim-interfaces-routeinterface) | Registers a `GET` route that responds with an HTTP `Location` redirect (`302` by default). |

### Usage Example

```php
use Slim\Interfaces\RouteCollectorProxyInterface;

$app->group('/api/v1', function (RouteCollectorProxyInterface $group): void {
    $group->get('/users', ListUsersHandler::class)->setName('users.index');
    $group->post('/users', CreateUserHandler::class)->setName('users.create');
    $group->redirect('/legacy', '/api/v1/users', 301);
});
```

---

## `interface` Slim\Interfaces\RouteGroupInterface

- **Source File**: `Slim/Interfaces/RouteGroupInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup)
- **Consumed By**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

Defines the contract for a route group returned by `RouteCollectorProxyInterface::group()`. Allows attaching group-scoped PSR-15 middlewares via `add()` and `addMiddleware()`, and appending those middlewares to a matched route's [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) when the route executes.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Server\MiddlewareInterface;
use Slim\MiddlewareDispatcher;

/** @api */
interface RouteGroupInterface
{
    public function collectRoutes(): RouteGroupInterface;

    /**
     * Add middleware to the route group
     *
     * @param MiddlewareInterface|string|callable $middleware
     */
    public function add($middleware): RouteGroupInterface;

    /**
     * Add middleware to the route group
     */
    public function addMiddleware(MiddlewareInterface $middleware): RouteGroupInterface;

    /**
     * Append the group's middleware to the MiddlewareDispatcher
     * @param MiddlewareDispatcher<\Psr\Container\ContainerInterface|null> $dispatcher
     */
    public function appendMiddlewareToDispatcher(MiddlewareDispatcher $dispatcher): RouteGroupInterface;

    /**
     * Get the RouteGroup's pattern
     */
    public function getPattern(): string;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `collectRoutes()` | *(none)* | `RouteGroupInterface` | Resolves and executes the group callback against a scoped `RouteCollectorProxy` to register inner routes. |
| `add()` | `MiddlewareInterface\|string\|callable $middleware` | `RouteGroupInterface` | Adds a middleware (instance, callable, or class/service string) to the route group. |
| `addMiddleware()` | `MiddlewareInterface $middleware` | `RouteGroupInterface` | Adds a typed PSR-15 `MiddlewareInterface` instance to the route group. |
| `appendMiddlewareToDispatcher()` | `MiddlewareDispatcher $dispatcher` | `RouteGroupInterface` | Appends all middlewares registered on this group onto `$dispatcher`. |
| `getPattern()` | *(none)* | `string` | Returns the route group's URI prefix pattern. |

### Usage Example

```php
$app->group('/admin', function ($group): void {
    $group->get('/audit-logs', AuditLogAction::class);
})->add(AdminRoleMiddleware::class);
```

---

## `interface` Slim\Interfaces\RouteInterface

- **Source File**: `Slim/Interfaces/RouteInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\Route`](03_routing.md#slim-routing-route)
- **Consumed By**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), `Slim\Routing\RouteRunner`, `Slim\Routing\RouteContext`

Defines the contract for an individual route in Slim 4. Each `RouteInterface` encapsulates its allowed HTTP methods, URI pattern, route callable, route name, unique identifier, matched URI arguments, local [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface), and route-level PSR-15 middleware stack executed via `run(ServerRequestInterface $request)`.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;

/** @api */
interface RouteInterface
{
    /**
     * Get route invocation strategy
     */
    public function getInvocationStrategy(): InvocationStrategyInterface;

    /**
     * Set route invocation strategy
     */
    public function setInvocationStrategy(InvocationStrategyInterface $invocationStrategy): RouteInterface;

    /**
     * Get route methods
     *
     * @return string[]
     */
    public function getMethods(): array;

    /**
     * Get route pattern
     */
    public function getPattern(): string;

    /**
     * Set route pattern
     */
    public function setPattern(string $pattern): RouteInterface;

    /**
     * Get route callable
     *
     * @return callable|array{class-string, string}|string
     */
    public function getCallable();

    /**
     * Set route callable
     *
     * @param callable|array{class-string, string}|string $callable
     */
    public function setCallable($callable): RouteInterface;

    /**
     * Get route name
     */
    public function getName(): ?string;

    /**
     * Set route name
     *
     * @return static
     */
    public function setName(string $name): RouteInterface;

    /**
     * Get the route's unique identifier
     */
    public function getIdentifier(): string;

    /**
     * Retrieve a specific route argument
     */
    public function getArgument(string $name, ?string $default = null): ?string;

    /**
     * Get route arguments
     *
     * @return array<string, string>
     */
    public function getArguments(): array;

    /**
     * Set a route argument
     *
     * @deprecated 4.14.1 Use a middleware for custom route arguments now.
     */
    public function setArgument(string $name, string $value): RouteInterface;

    /**
     * Replace route arguments
     *
     * @param array<string, string> $arguments
     *
     * @deprecated 4.14.1 Use a middleware for custom route arguments now.
     */
    public function setArguments(array $arguments): self;

    /**
     * @param MiddlewareInterface|string|callable $middleware
     */
    public function add($middleware): self;

    public function addMiddleware(MiddlewareInterface $middleware): self;

    /**
     * Prepare the route for use
     *
     * @param array<string, string> $arguments
     */
    public function prepare(array $arguments): self;

    /**
     * Run route
     *
     * This method traverses the middleware stack, including the route's callable
     * and captures the resultant HTTP response object. It then sends the response
     * back to the Application.
     */
    public function run(ServerRequestInterface $request): ResponseInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getInvocationStrategy()` / `setInvocationStrategy()` | `InvocationStrategyInterface $invocationStrategy` | `InvocationStrategyInterface` / `RouteInterface` | Gets or overrides the invocation strategy for this specific route. |
| `getMethods()` | *(none)* | `string[]` | Returns the array of HTTP methods registered for this route. |
| `getPattern()` / `setPattern()` | `string $pattern` | `string` / `RouteInterface` | Gets or updates the route URI pattern. |
| `getCallable()` / `setCallable()` | `callable\|array\|string $callable` | `callable\|array\|string` / `RouteInterface` | Gets or replaces the route handler definition. |
| `getName()` / `setName()` | `string $name` | `?string` / `RouteInterface` | Gets or assigns the route name used by [`RouteParserInterface`](#slim-interfaces-routeparserinterface). |
| `getIdentifier()` | *(none)* | `string` | Returns the unique internal route identifier (e.g. `'route0'`). |
| `getArgument()` | `string $name`, `?string $default = null` | `?string` | Returns a single matched URI placeholder argument or `$default`. |
| `getArguments()` | *(none)* | `array<string, string>` | Returns all matched URI placeholder arguments. |
| `setArgument()` / `setArguments()` | `string $name, string $value` / `array $arguments` | `RouteInterface` / `self` | **Deprecated since `4.14.1`** (use PSR-7 request attributes in middleware instead). |
| `add()` / `addMiddleware()` | `MiddlewareInterface\|string\|callable $middleware` | `self` | Attaches a route-specific middleware to this route's local stack. |
| `prepare()` | `array<string, string> $arguments` | `self` | Populates matched route arguments for the current request cycle. |
| `run()` | `ServerRequestInterface $request` | `ResponseInterface` | Appends group middlewares (once) and dispatches the route's local middleware stack and handler callable. |

### Usage Example

```php
use Slim\Handlers\Strategies\RequestResponseArgs;

$app->get('/orders/{id:[0-9]+}', OrderController::class . ':show')
    ->setName('orders.show')
    ->setInvocationStrategy(new RequestResponseArgs())
    ->add(OrderOwnershipMiddleware::class);
```

---

## `interface` Slim\Interfaces\RouteParserInterface

- **Source File**: `Slim/Interfaces/RouteParserInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser)
- **Consumed By**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), `Slim\Routing\RouteContext`, [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware)

Defines the reverse URL generation contract for building relative paths (`relativeUrlFor()`), base-path-prefixed paths (`urlFor()`), and fully qualified URLs including scheme and authority (`fullUrlFor()`) from named routes.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use InvalidArgumentException;
use Psr\Http\Message\UriInterface;
use RuntimeException;

/** @api */
interface RouteParserInterface
{
    /**
     * Build the path for a named route excluding the base path
     *
     * @param string                                           $routeName   Route name
     * @param array<string, string>                            $data        Named argument replacement data
     * @param array<string, string | array<array-key, string>> $queryParams Optional query string parameters
     *
     * @throws RuntimeException         If named route does not exist
     * @throws InvalidArgumentException If required data not provided
     */
    public function relativeUrlFor(string $routeName, array $data = [], array $queryParams = []): string;

    /**
     * Build the path for a named route including the base path
     *
     * @param string                                           $routeName   Route name
     * @param array<string, string>                            $data        Named argument replacement data
     * @param array<string, string | array<array-key, string>> $queryParams Optional query string parameters
     *
     * @throws RuntimeException         If named route does not exist
     * @throws InvalidArgumentException If required data not provided
     */
    public function urlFor(string $routeName, array $data = [], array $queryParams = []): string;

    /**
     * Get fully qualified URL for named route
     *
     * @param UriInterface                                     $uri
     * @param string                                           $routeName   Route name
     * @param array<string, string>                            $data        Named argument replacement data
     * @param array<string, string | array<array-key, string>> $queryParams Optional query string parameters
     */
    public function fullUrlFor(UriInterface $uri, string $routeName, array $data = [], array $queryParams = []): string;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `relativeUrlFor()` | `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | Builds the URI path for `$routeName` with placeholder substitutions `$data` and optional `$queryParams`, **excluding** the base path. |
| `urlFor()` | `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | Builds the URI path for `$routeName` **including** the application `basePath`. |
| `fullUrlFor()` | `UriInterface $uri`, `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | Builds the absolute URL (`scheme://authority/path?query`) using the scheme and authority from `$uri`. |

### Usage Example

```php
use Slim\Routing\RouteContext;

$routeParser = RouteContext::fromRequest($request)->getRouteParser();

$relative = $routeParser->relativeUrlFor('orders.show', ['id' => '42']);
$path     = $routeParser->urlFor('orders.show', ['id' => '42'], ['expand' => 'items']);
$fullUrl  = $routeParser->fullUrlFor($request->getUri(), 'orders.show', ['id' => '42']);
```

---

## `interface` Slim\Interfaces\RouteResolverInterface

- **Source File**: `Slim/Interfaces/RouteResolverInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementation**: [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver)
- **Consumed By**: [`Slim\App`](01_app_and_factories.md#slim-app), [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware), `Slim\Routing\RouteRunner`

Defines the contract bridging [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) with [`DispatcherInterface`](#slim-interfaces-dispatcherinterface) and [`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) to compute `RoutingResults` for an incoming URI and resolve a matched route identifier into its [`RouteInterface`](#slim-interfaces-routeinterface) object.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Slim\Routing\RoutingResults;

interface RouteResolverInterface
{
    /**
     * @param string $uri Should be ServerRequestInterface::getUri()->getPath()
     */
    public function computeRoutingResults(string $uri, string $method): RoutingResults;

    public function resolveRoute(string $identifier): RouteInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `computeRoutingResults()` | `string $uri`, `string $method` | `RoutingResults` | URL-decodes `$uri` (`rawurldecode()`) and delegates to `DispatcherInterface::dispatch($method, $uri)`. |
| `resolveRoute()` | `string $identifier` | [`RouteInterface`](#slim-interfaces-routeinterface) | Looks up the [`RouteInterface`](#slim-interfaces-routeinterface) corresponding to `$identifier` via `RouteCollectorInterface::lookupRoute()`. |

### Usage Example

```php
$resolver = $app->getRouteResolver();
$results  = $resolver->computeRoutingResults('/users/42', 'GET');
$route    = $resolver->resolveRoute($results->getRouteIdentifier());
```

---

## `interface` Slim\Interfaces\ServerRequestCreatorInterface

- **Source File**: `Slim/Interfaces/ServerRequestCreatorInterface.php`
- **Namespace**: `Slim\Interfaces`
- **Default Implementations**: `Slim\Factory\Psr17\ServerRequestCreator`, `Slim\Factory\Psr17\SlimHttpServerRequestCreator`
- **Consumed By**: [`Slim\App::run()`](01_app_and_factories.md#slim-app), `Slim\Factory\ServerRequestCreatorFactory`

Defines the contract for synthesizing a PSR-7 `ServerRequestInterface` from PHP SAPI superglobals (`$_SERVER`, `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES`) when [`App::run()`](01_app_and_factories.md#slim-app) is called without an explicit request argument.

### PHP Interface Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

use Psr\Http\Message\ServerRequestInterface;

interface ServerRequestCreatorInterface
{
    public function createServerRequestFromGlobals(): ServerRequestInterface;
}
```

### Methods & Parameters

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `createServerRequestFromGlobals()` | *(none)* | `ServerRequestInterface` | Constructs and returns a populated PSR-7 `ServerRequestInterface` from the current PHP SAPI environment. |

### Usage Example

```php
use Slim\Factory\ServerRequestCreatorFactory;

$creator = ServerRequestCreatorFactory::create();
$request = $creator->createServerRequestFromGlobals();
$app->run($request);
```
