# Handlers & Invocation Strategies

The `Slim\Handlers` namespace provides the default [`ErrorHandler`](#slim-handlers-errorhandler) responsible for HTTP content negotiation, exception logging, and response generation, alongside the four route callback invocation strategies under `Slim\Handlers\Strategies`. Together, these classes govern how matched [`Route`](03_routing.md#slim-routing-route) callables are invoked and how uncaught `Throwable` instances are converted into PSR-7 responses by [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware).

```drawlib align=center code=fold file=p2_handlers_error_pipeline.png caption="Slim\Handlers\ErrorHandler Execution & Content Negotiation Pipeline"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=180, height=76)

# Outer container for ErrorHandler
rectangle(
    (90, 36),
    width=168,
    height=56,
    style=Styles.Neutral.patch(shape_r=3.0),
)
text(
    (90, 68.5),
    "Slim\\Handlers\\ErrorHandler::__invoke(request, exception, ...)",
    style=Styles.PrimaryBold.patch(text_size=12.5),
)

# Step 1: Input
rectangle(
    (24, 42),
    width=30,
    height=22,
    style=Styles.PrimaryFlat.patch(shape_r=2.0),
)
phosphor.warning_octagon((24, 47.5), width=6.0, style=Styles.White)
text((24, 40.5), "ErrorMiddleware", style=Styles.WhiteBold.patch(text_size=10.5))
text((24, 35.5), "Request + Throwable", style=Styles.White.patch(text_size=10.0))

# Step 2: Status & Content-Type Negotiation
rectangle(
    (68, 49),
    width=38,
    height=15,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((68, 52.0), "determineStatusCode()", style=Styles.PrimaryBold.patch(text_size=10.5))
text((68, 46.5), "OPTIONS:200 | Http:Code | 500", style=Styles.Dark.patch(text_size=10.0))

rectangle(
    (68, 25),
    width=38,
    height=15,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((68, 28.0), "determineContentType()", style=Styles.PrimaryBold.patch(text_size=10.5))
text((68, 22.5), "Accept Header / Forced MIME", style=Styles.Dark.patch(text_size=10.0))

# Step 3: Logger & Renderer Resolution
rectangle(
    (116, 49),
    width=36,
    height=15,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((116, 52.0), "writeToErrorLog()", style=Styles.SecondaryBold.patch(text_size=10.5))
text((116, 46.5), "PlainText -> PSR-3 Logger", style=Styles.Dark.patch(text_size=10.0))

rectangle(
    (116, 25),
    width=36,
    height=15,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((116, 28.0), "determineRenderer()", style=Styles.PrimaryBold.patch(text_size=10.5))
text((116, 22.5), "Resolve MIME Renderer", style=Styles.Dark.patch(text_size=10.0))

# Step 4: Output Response
rectangle(
    (157, 37),
    width=28,
    height=24,
    style=Styles.AccentFlat.patch(shape_r=2.0),
)
phosphor.file_code((157, 43.0), width=6.0, style=Styles.White)
text((157, 35.5), "respond()", style=Styles.WhiteBold.patch(text_size=11.0))
text((157, 30.0), "PSR-7 Response", style=Styles.White.patch(text_size=10.0))

# Connectors
line((39, 46), (49, 49), arrow_head="->", style=Styles.PrimaryBold)
line((39, 38), (49, 25), arrow_head="->", style=Styles.PrimaryBold)
line((87, 49), (98, 49), arrow_head="->", style=Styles.SecondaryBold)
line((87, 25), (98, 25), arrow_head="->", style=Styles.PrimaryBold)
line((134, 49), (143, 41), arrow_head="->", style=Styles.SecondaryBold)
line((134, 25), (143, 33), arrow_head="->", style=Styles.PrimaryBold)

save()
```

---

## Summary of Classes

| Class | Namespace | Implements | Primary Role |
| :--- | :--- | :--- | :--- |
| [`ErrorHandler`](#slim-handlers-errorhandler) | `Slim\Handlers` | [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | Negotiates `Accept` content type, logs exceptions via PSR-3, and renders HTTP error responses. |
| [`RequestResponse`](#slim-handlers-strategies-requestresponse) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Default strategy: attaches route params as request attributes and passes `($request, $response, array $args)`. |
| [`RequestResponseArgs`](#slim-handlers-strategies-requestresponseargs) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Unpacks route parameters positionally via `($request, $response, ...array_values($args))`. |
| [`RequestResponseNamedArgs`](#slim-handlers-strategies-requestresponsenamedargs) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | Unpacks route parameters as PHP 8+ named arguments via `($request, $response, ...$args)`. |
| [`RequestHandler`](#slim-handlers-strategies-requesthandler) | `Slim\Handlers\Strategies` | [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | Invokes PSR-15 request handler callables as `$callable($request)` with optional attribute injection. |

---

## `class` Slim\Handlers\ErrorHandler

- **Source**: `Slim/Handlers/ErrorHandler.php`
- **Namespace**: `Slim\Handlers`
- **Implements**: [`Slim\Interfaces\ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface)

`ErrorHandler` is Slim's default application error handler invoked by [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware). It determines the appropriate HTTP status code, negotiates the response media type against the request's `Accept` header (supporting JSON, XML, HTML, and Plain Text via [`Slim\Error\Renderers`](06_error_renderers.md)), optionally writes formatted diagnostics to a PSR-3 logger (defaulting to [`Slim\Logger`](01_app_and_factories.md#slim-logger)), and produces a PSR-7 `ResponseInterface`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Handlers;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Log\LoggerInterface;
use Slim\Error\Renderers\HtmlErrorRenderer;
use Slim\Error\Renderers\JsonErrorRenderer;
use Slim\Error\Renderers\PlainTextErrorRenderer;
use Slim\Error\Renderers\XmlErrorRenderer;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\ErrorHandlerInterface;
use Slim\Interfaces\ErrorRendererInterface;
use Throwable;

class ErrorHandler implements ErrorHandlerInterface
{
    protected string $defaultErrorRendererContentType = 'text/html';

    /** @var ErrorRendererInterface|string|callable */
    protected $defaultErrorRenderer = HtmlErrorRenderer::class;

    /** @var ErrorRendererInterface|string|callable */
    protected $logErrorRenderer = PlainTextErrorRenderer::class;

    /** @var array<string|callable> */
    protected array $errorRenderers = [
        'application/json' => JsonErrorRenderer::class,
        'application/xml' => XmlErrorRenderer::class,
        'text/xml' => XmlErrorRenderer::class,
        'text/html' => HtmlErrorRenderer::class,
        'text/plain' => PlainTextErrorRenderer::class,
    ];

    protected bool $displayErrorDetails = false;
    protected bool $logErrors;
    protected bool $logErrorDetails = false;
    protected ?string $contentType = null;
    protected bool $isContentTypeForced = false;
    protected ?string $method = null;
    protected ServerRequestInterface $request;
    protected Throwable $exception;
    protected int $statusCode;
    protected CallableResolverInterface $callableResolver;
    protected ResponseFactoryInterface $responseFactory;
    protected LoggerInterface $logger;

    public function __construct(
        CallableResolverInterface $callableResolver,
        ResponseFactoryInterface $responseFactory,
        ?LoggerInterface $logger = null
    );

    public function __invoke(
        ServerRequestInterface $request,
        Throwable $exception,
        bool $displayErrorDetails,
        bool $logErrors,
        bool $logErrorDetails
    ): ResponseInterface;

    public function forceContentType(?string $contentType): void;
    public function registerErrorRenderer(string $contentType, $errorRenderer): void;
    public function setDefaultErrorRenderer(string $contentType, $errorRenderer): void;
    public function setLogErrorRenderer($logErrorRenderer): void;

    protected function determineStatusCode(): int;
    protected function determineContentType(ServerRequestInterface $request): ?string;
    protected function determineRenderer(): callable;
    protected function writeToErrorLog(): void;
    protected function logError(string $error): void;
    protected function getDefaultLogger(): LoggerInterface;
    protected function respond(): ResponseInterface;
}
```

### Properties

| Property | Visibility | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `$defaultErrorRendererContentType` | `protected` | `string` | `'text/html'` | Fallback `Content-type` header value when content negotiation does not match a registered MIME type. |
| `$defaultErrorRenderer` | `protected` | `ErrorRendererInterface\|string\|callable` | `HtmlErrorRenderer::class` | Fallback renderer resolved via [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) when `$contentType` is `null` or unregistered. |
| `$logErrorRenderer` | `protected` | `ErrorRendererInterface\|string\|callable` | `PlainTextErrorRenderer::class` | Renderer used by `writeToErrorLog()` to format the exception string passed to `$logger->error()`. |
| `$errorRenderers` | `protected` | `array<string, ErrorRendererInterface\|string\|callable>` | 5 built-in mappings | Map of MIME content types (`application/json`, `application/xml`, `text/xml`, `text/html`, `text/plain`) to error renderer callables or class names. |
| `$displayErrorDetails` | `protected` | `bool` | `false` | Whether the HTTP response renderer should include exception type, code, message, file, line, and trace details. |
| `$logErrors` | `protected` | `bool` | Uninitialized | Set on `__invoke()`; controls whether `writeToErrorLog()` is executed. |
| `$logErrorDetails` | `protected` | `bool` | `false` | Set on `__invoke()`; passed as the `$displayErrorDetails` flag to `$logErrorRenderer`. |
| `$contentType` | `protected` | `?string` | `null` | Negotiated or forced MIME content type for the current error response. |
| `$isContentTypeForced` | `protected` | `bool` | `false` | When `true`, skips `determineContentType($request)` during `__invoke()` and retains the forced `$contentType`. |
| `$method` | `protected` | `?string` | `null` | HTTP method extracted from `$request->getMethod()` during `__invoke()`. |
| `$request` | `protected` | `ServerRequestInterface` | Uninitialized | Most recent PSR-7 server request captured during `__invoke()`. |
| `$exception` | `protected` | `Throwable` | Uninitialized | Caught exception or error captured during `__invoke()`. |
| `$statusCode` | `protected` | `int` | Uninitialized | Resolved HTTP status code (`200` for `OPTIONS`, `$exception->getCode()` for [`HttpException`](07_exceptions.md#slim-exception-httpexception), or `500`). |
| `$callableResolver` | `protected` | `CallableResolverInterface` | Constructor | Resolves string/container/class error renderers into invokable callables. |
| `$responseFactory` | `protected` | `ResponseFactoryInterface` | Constructor | Creates the base PSR-7 `ResponseInterface` in `respond()`. |
| `$logger` | `protected` | `LoggerInterface` | `new Logger()` | PSR-3 logger instance receiving formatted error strings in `logError()`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `CallableResolverInterface $callableResolver`, `ResponseFactoryInterface $responseFactory`, `?LoggerInterface $logger = null` | `void` | Initializes the handler; falls back to `getDefaultLogger()` ([`Slim\Logger`](01_app_and_factories.md#slim-logger)) if `$logger` is `null`. |
| `__invoke` | `ServerRequestInterface $request`, `Throwable $exception`, `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails` | `ResponseInterface` | Captures state, determines status code and content type (unless forced), optionally logs the error, and returns `respond()`. |
| `forceContentType` | `?string $contentType` | `void` | Forces a specific MIME type (e.g., `'application/json'`) for all responses; passing `null` restores `Accept` header negotiation. |
| `registerErrorRenderer` | `string $contentType`, `ErrorRendererInterface\|string\|callable $errorRenderer` | `void` | Registers or overrides an error renderer in `$errorRenderers[$contentType]`. |
| `setDefaultErrorRenderer` | `string $contentType`, `ErrorRendererInterface\|string\|callable $errorRenderer` | `void` | Sets both `$defaultErrorRendererContentType` and `$defaultErrorRenderer` used when negotiation returns no match. |
| `setLogErrorRenderer` | `ErrorRendererInterface\|string\|callable $logErrorRenderer` | `void` | Sets the renderer used by `writeToErrorLog()` to format log output. |
| `determineStatusCode` | *(none)* | `int` | Protected. Returns `200` if `$this->method === 'OPTIONS'`, `$this->exception->getCode()` if `instanceof HttpException`, else `500`. |
| `determineContentType` | `ServerRequestInterface $request` | `?string` | Protected. Intersects comma-separated `Accept` header values with `array_keys($this->errorRenderers)` (preferring non-`text/plain` when multiple match) and checks `/\+(json\|xml)/` vendor media types. |
| `determineRenderer` | *(none)* | `callable` | Protected. Selects `$this->errorRenderers[$this->contentType]` if registered, else `$this->defaultErrorRenderer`, and resolves it via `$this->callableResolver->resolve()`. |
| `writeToErrorLog` | *(none)* | `void` | Protected. Resolves `$this->logErrorRenderer`, formats `$this->exception` with `$this->logErrorDetails`, appends a tip if using `PlainTextErrorRenderer` with `!$this->displayErrorDetails`, and calls `logError()`. |
| `logError` | `string $error` | `void` | Protected. Delegates directly to `$this->logger->error($error)`. |
| `getDefaultLogger` | *(none)* | `LoggerInterface` | Protected. Instantiates and returns a new [`Slim\Logger`](01_app_and_factories.md#slim-logger). |
| `respond` | *(none)* | `ResponseInterface` | Protected. Creates the response with `$this->statusCode`, sets `Content-type`, adds the `Allow` header if `$exception instanceof HttpMethodNotAllowedException`, invokes the renderer, and writes the body. |

### Usage Example

```php
<?php

use Slim\Error\Renderers\JsonErrorRenderer;
use Slim\Factory\AppFactory;
use Slim\Handlers\ErrorHandler;

$app = AppFactory::create();

$errorHandler = new ErrorHandler(
    $app->getCallableResolver(),
    $app->getResponseFactory()
);

// Force JSON error payloads regardless of the client's Accept header
$errorHandler->forceContentType('application/json');
$errorHandler->setDefaultErrorRenderer('application/json', JsonErrorRenderer::class);

$errorMiddleware = $app->addErrorMiddleware(true, true, true);
$errorMiddleware->setDefaultErrorHandler($errorHandler);
```

---

## Route Callback Invocation Strategies

When a [`Route`](03_routing.md#slim-routing-route) matches an incoming request, it delegates callable execution to an [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface). You can set the strategy globally via `RouteCollector::setDefaultInvocationStrategy()` or per-route via `Route::setInvocationStrategy()`.

```drawlib align=center code=fold file=p2_handlers_invocation_strategies.png caption="Route Argument Dispatch Across Slim's Four Invocation Strategies"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Colors, Styles
from drawlib.text import text

setup(width=180, height=84)

# Left source node: Route::run()
rectangle(
    (26, 42),
    width=40,
    height=34,
    style=Styles.PrimaryFlat.patch(shape_r=2.5),
)
phosphor.git_branch((26, 52.0), width=6.5, style=Styles.White)
text((26, 44.0), "Slim\\Routing\\Route", style=Styles.WhiteBold.patch(text_size=11.5))
text((26, 38.0), "routeArguments =", style=Styles.White.patch(text_size=10.0))
text((26, 32.5), "['id' => '42', 'tab' => 'bio']", style=Styles.WhiteBold.patch(text_size=10.0))

# Strategy 1: RequestResponse (Default)
rectangle(
    (122, 72),
    width=102,
    height=15,
    style=Styles.AccentFlat.patch(shape_r=2.0),
)
text(
    (122, 75.0),
    "1. RequestResponse (Default)  [+ sets request attributes]",
    style=Styles.WhiteBold.patch(text_size=11.0),
)
text(
    (122, 69.0),
    "callable(request, response, ['id' => '42', 'tab' => 'bio'])",
    style=Styles.White.patch(text_size=10.5),
)

# Strategy 2: RequestResponseArgs
rectangle(
    (122, 52),
    width=102,
    height=15,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text(
    (122, 55.0),
    "2. RequestResponseArgs  [positional ...array_values(args)]",
    style=Styles.PrimaryBold.patch(text_size=11.0),
)
text(
    (122, 49.0),
    "callable(request, response, '42', 'bio')",
    style=Styles.Dark.patch(text_size=10.5),
)

# Strategy 3: RequestResponseNamedArgs
rectangle(
    (122, 32),
    width=102,
    height=15,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text(
    (122, 35.0),
    "3. RequestResponseNamedArgs  [PHP 8+ named ...args]",
    style=Styles.PrimaryBold.patch(text_size=11.0),
)
text(
    (122, 29.0),
    "callable(request, response, id: '42', tab: 'bio')",
    style=Styles.Dark.patch(text_size=10.5),
)

# Strategy 4: RequestHandler
rectangle(
    (122, 12),
    width=102,
    height=15,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text(
    (122, 15.0),
    "4. RequestHandler  [PSR-15 style, optional attributes]",
    style=Styles.SecondaryBold.patch(text_size=11.0),
)
text(
    (122, 9.0),
    "callable(request)  -> returns ResponseInterface",
    style=Styles.Dark.patch(text_size=10.5),
)

# Connectors
line((46, 52), (71, 72), arrow_head="->", style=Styles.AccentBold)
line((46, 45), (71, 52), arrow_head="->", style=Styles.PrimaryBold)
line((46, 39), (71, 32), arrow_head="->", style=Styles.PrimaryBold)
line((46, 32), (71, 12), arrow_head="->", style=Styles.SecondaryBold)

save()
```

---

## `class` Slim\Handlers\Strategies\RequestResponse

- **Source**: `Slim/Handlers/Strategies/RequestResponse.php`
- **Namespace**: `Slim\Handlers\Strategies`
- **Implements**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponse` is Slim 4's default route callback strategy initialized by [`RouteCollector`](03_routing.md#slim-routing-routecollector). Before invoking the route callable, it iterates over `$routeArguments` and attaches every placeholder key-value pair to the PSR-7 `ServerRequestInterface` via `$request->withAttribute($k, $v)`. It then invokes the callable with `($request, $response, $routeArguments)`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Handlers\Strategies;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\InvocationStrategyInterface;

class RequestResponse implements InvocationStrategyInterface
{
    /**
     * @param array<string, string> $routeArguments
     */
    public function __invoke(
        callable $callable,
        ServerRequestInterface $request,
        ResponseInterface $response,
        array $routeArguments
    ): ResponseInterface;
}
```

### Properties

`RequestResponse` defines no class properties.

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Copies each `$routeArguments` entry onto `$request` via `withAttribute($k, $v)` and returns `$callable($request, $response, $routeArguments)`. |

### Usage Example

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponse;

$app = AppFactory::create();
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestResponse());

$app->get('/users/{id}', function (Request $request, Response $response, array $args): Response {
    // Accessible via both $args['id'] and $request->getAttribute('id')
    $userId = $args['id'];
    $response->getBody()->write("User ID: {$userId}");
    return $response;
});
```

---

## `class` Slim\Handlers\Strategies\RequestResponseArgs

- **Source**: `Slim/Handlers/Strategies/RequestResponseArgs.php`
- **Namespace**: `Slim\Handlers\Strategies`
- **Implements**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponseArgs` unpacks route parameters positionally as individual arguments after `$request` and `$response` using `...array_values($routeArguments)`. Unlike [`RequestResponse`](#slim-handlers-strategies-requestresponse), it does **not** inject route parameters into `$request` attributes.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Handlers\Strategies;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\InvocationStrategyInterface;

class RequestResponseArgs implements InvocationStrategyInterface
{
    /**
     * @param array<string, string> $routeArguments
     */
    public function __invoke(
        callable $callable,
        ServerRequestInterface $request,
        ResponseInterface $response,
        array $routeArguments
    ): ResponseInterface;
}
```

### Properties

`RequestResponseArgs` defines no class properties.

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Invokes and returns `$callable($request, $response, ...array_values($routeArguments))`. |

### Usage Example

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponseArgs;

$app = AppFactory::create();
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestResponseArgs());

$app->get('/orgs/{orgId}/members/{memberId}', function (
    Request $request,
    Response $response,
    string $orgId,
    string $memberId
): Response {
    $response->getBody()->write("Org: {$orgId}, Member: {$memberId}");
    return $response;
});
```

---

## `class` Slim\Handlers\Strategies\RequestResponseNamedArgs

- **Source**: `Slim/Handlers/Strategies/RequestResponseNamedArgs.php`
- **Namespace**: `Slim\Handlers\Strategies`
- **Implements**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponseNamedArgs` spreads the associative `$routeArguments` array directly via `...$routeArguments`, leveraging PHP 8.0+ named arguments. Route placeholder names in the pattern (e.g., `{id}`, `{format}`) must match the callable's parameter names, independent of their parameter order after `$request` and `$response`. Like [`RequestResponseArgs`](#slim-handlers-strategies-requestresponseargs), it does **not** mutate `$request` attributes.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Handlers\Strategies;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\InvocationStrategyInterface;

class RequestResponseNamedArgs implements InvocationStrategyInterface
{
    /**
     * @param array<string, string> $routeArguments
     */
    public function __invoke(
        callable $callable,
        ServerRequestInterface $request,
        ResponseInterface $response,
        array $routeArguments
    ): ResponseInterface;
}
```

### Properties

`RequestResponseNamedArgs` defines no class properties.

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Invokes and returns `$callable($request, $response, ...$routeArguments)` using PHP named argument unpacking. |

### Usage Example

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponseNamedArgs;

$app = AppFactory::create();
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestResponseNamedArgs());

// Notice that $tab and $id can be declared in any order matching the placeholder names
$app->get('/users/{id}/tabs/{tab}', function (
    Request $request,
    Response $response,
    string $tab,
    string $id
): Response {
    $response->getBody()->write("User {$id} -> Tab {$tab}");
    return $response;
});
```

---

## `class` Slim\Handlers\Strategies\RequestHandler

- **Source**: `Slim/Handlers/Strategies/RequestHandler.php`
- **Namespace**: `Slim\Handlers\Strategies`
- **Implements**: [`Slim\Interfaces\RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) (extends [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface))

`RequestHandler` invokes route callables using the single-argument PSR-15 `RequestHandlerInterface` signature `$callable($request): ResponseInterface`, discarding the pre-created `$response` argument. When constructed with `$appendRouteArgumentsToRequestAttributes = true`, it copies all `$routeArguments` key-value pairs into `$request` attributes prior to calling `$callable($request)`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Handlers\Strategies;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\RequestHandlerInvocationStrategyInterface;

class RequestHandler implements RequestHandlerInvocationStrategyInterface
{
    protected bool $appendRouteArgumentsToRequestAttributes;

    public function __construct(bool $appendRouteArgumentsToRequestAttributes = false);

    /**
     * @param array<string, string> $routeArguments
     */
    public function __invoke(
        callable $callable,
        ServerRequestInterface $request,
        ResponseInterface $response,
        array $routeArguments
    ): ResponseInterface;
}
```

### Properties

| Property | Visibility | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `$appendRouteArgumentsToRequestAttributes` | `protected` | `bool` | `false` | When `true`, attaches each entry in `$routeArguments` to `$request` via `$request->withAttribute($k, $v)` before invoking `$callable($request)`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `bool $appendRouteArgumentsToRequestAttributes = false` | `void` | Configures whether route parameters are automatically appended to `$request` attributes. |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | Optionally injects `$routeArguments` into `$request` attributes and returns `$callable($request)`. |

### Usage Example

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestHandler;

$app = AppFactory::create();

// Enable attribute injection so PSR-15 style handlers can read route placeholders
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestHandler(true));

$app->get('/articles/{slug}', function (Request $request) use ($app): Response {
    $slug = $request->getAttribute('slug');
    $response = $app->getResponseFactory()->createResponse(200);
    $response->getBody()->write("Article: {$slug}");
    return $response;
});
```
