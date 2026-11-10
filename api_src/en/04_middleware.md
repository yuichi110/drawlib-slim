# Middleware (`Slim\Middleware`)

The `Slim\Middleware` namespace provides Slim 4's six built-in PSR-15 (`Psr\Http\Server\MiddlewareInterface`) components: [`RoutingMiddleware`](#slim-middleware-routingmiddleware), [`ErrorMiddleware`](#slim-middleware-errormiddleware), [`BodyParsingMiddleware`](#slim-middleware-bodyparsingmiddleware), [`ContentLengthMiddleware`](#slim-middleware-contentlengthmiddleware), [`MethodOverrideMiddleware`](#slim-middleware-methodoverridemiddleware), and [`OutputBufferingMiddleware`](#slim-middleware-outputbufferingmiddleware). Because Slim's [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) wraps middleware in a concentric LIFO (Last-In, First-Out) onion stack, the middleware added **last** executes **first** on inbound requests.

```drawlib align=center code=fold file=middleware_pipeline.png caption="Slim 4 Built-in PSR-15 Middleware Pipeline — Recommended Execution Order from Outer Boundary to Kernel"
from drawlib.canvas import save, setup
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=82)

# Outer frame label
text(
    (90, 75),
    "Inbound ServerRequestInterface  --->  Concentric PSR-15 Middleware Stack  --->  RouteRunner",
    style=Styles.PrimaryBold.patch(text_size=11.5),
)

# Top Row (Outer to Mid-Layer)
rectangle(
    (31, 53),
    width=46,
    height=18,
    style=Styles.AccentFlat.patch(shape_r=2.5),
)
text((31, 57.5), "1. ErrorMiddleware", style=Styles.WhiteBold.patch(text_size=11.0))
text((31, 52.0), "Outermost try / catch", style=Styles.White.patch(text_size=10.0))
text((31, 47.0), "Added LAST (app->add)", style=Styles.White.patch(text_size=9.5))

rectangle(
    (90, 53),
    width=46,
    height=18,
    style=Styles.Neutral.patch(shape_r=2.5),
)
text((90, 57.5), "2. ContentLength", style=Styles.BlackBold.patch(text_size=11.0))
text((90, 52.0), "& OutputBuffering", style=Styles.Dark.patch(text_size=10.0))
text((90, 47.0), "Stream capture & size", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (149, 53),
    width=46,
    height=18,
    style=Styles.PrimaryNeutral.patch(shape_r=2.5),
)
text((149, 57.5), "3. BodyParsing", style=Styles.BlackBold.patch(text_size=11.0))
text((149, 52.0), "JSON / XML / Form", style=Styles.Dark.patch(text_size=10.0))
text((149, 47.0), "withParsedBody()", style=Styles.Dark.patch(text_size=9.5))

# Bottom Row (Inner Layers to Kernel)
rectangle(
    (149, 20),
    width=46,
    height=18,
    style=Styles.SecondaryNeutral.patch(shape_r=2.5),
)
text((149, 24.5), "4. MethodOverride", style=Styles.BlackBold.patch(text_size=11.0))
text((149, 19.0), "Header or POST _METHOD", style=Styles.Dark.patch(text_size=10.0))
text((149, 14.0), "withMethod()", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (90, 20),
    width=46,
    height=18,
    style=Styles.PrimaryFlat.patch(shape_r=2.5),
)
text((90, 24.5), "5. RoutingMiddleware", style=Styles.WhiteBold.patch(text_size=11.0))
text((90, 19.0), "FastRoute match", style=Styles.White.patch(text_size=10.0))
text((90, 14.0), "Sets RouteContext", style=Styles.White.patch(text_size=9.5))

rectangle(
    (31, 20),
    width=46,
    height=18,
    style=Styles.Neutral.patch(shape_r=2.5),
)
text((31, 24.5), "6. RouteRunner", style=Styles.BlackBold.patch(text_size=11.0))
text((31, 19.0), "Group & Route MW", style=Styles.Dark.patch(text_size=10.0))
text((31, 14.0), "Route::run(request)", style=Styles.Dark.patch(text_size=9.5))

# Arrows connecting 1 -> 2 -> 3 -> 4 -> 5 -> 6
line((54, 53), (67, 53), arrow_head="->", style=Styles.PrimaryBold)
line((113, 53), (126, 53), arrow_head="->", style=Styles.PrimaryBold)
line((149, 44), (149, 29), arrow_head="->", style=Styles.PrimaryBold)
line((126, 20), (113, 20), arrow_head="->", style=Styles.PrimaryBold)
line((67, 20), (54, 20), arrow_head="->", style=Styles.PrimaryBold)

save()
```

---

## `class` Slim\Middleware\RoutingMiddleware

- **Source**: `Slim/Middleware/RoutingMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`RoutingMiddleware` executes FastRoute URI and HTTP method matching via [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) before downstream middleware or [`RouteRunner`](03_routing.md#slim-routing-routerunner) is reached. It populates [`RouteContext::ROUTE_PARSER`](03_routing.md#slim-routing-routecontext), [`RouteContext::ROUTING_RESULTS`](03_routing.md#slim-routing-routecontext), and [`RouteContext::ROUTE`](03_routing.md#slim-routing-routecontext) on the `ServerRequestInterface`, and throws [`HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) or [`HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) when routing fails.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use RuntimeException;
use Slim\Exception\HttpMethodNotAllowedException;
use Slim\Exception\HttpNotFoundException;
use Slim\Interfaces\RouteParserInterface;
use Slim\Interfaces\RouteResolverInterface;
use Slim\Routing\RoutingResults;

class RoutingMiddleware implements MiddlewareInterface
{
    protected RouteResolverInterface $routeResolver;
    protected RouteParserInterface $routeParser;

    public function __construct(
        RouteResolverInterface $routeResolver,
        RouteParserInterface $routeParser
    );

    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;

    public function performRouting(ServerRequestInterface $request): ServerRequestInterface;

    protected function resolveRoutingResultsFromRequest(
        ServerRequestInterface $request
    ): RoutingResults;
}
```

### Properties

| Property | Type | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `$routeResolver` | [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | `protected` | Computes [`RoutingResults`](03_routing.md#slim-routing-routingresults) and resolves matched route identifiers into [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) objects. |
| `$routeParser` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | `protected` | Attached to `$request` under the `RouteContext::ROUTE_PARSER` (`'__routeParser__'`) attribute. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteResolverInterface $routeResolver`, `RouteParserInterface $routeParser` | `void` | Initializes the middleware with a route resolver and route parser. |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | Calls `$this->performRouting($request)` and passes the enriched request to `$handler->handle($request)`. |
| `performRouting` | `ServerRequestInterface $request` | `ServerRequestInterface` | Sets `RouteContext::ROUTE_PARSER` and `RouteContext::ROUTING_RESULTS` attributes. On `RoutingResults::FOUND`, prepares the matched route with route arguments and attaches `RouteContext::ROUTE`. Throws [`HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) on `NOT_FOUND`, [`HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) (with allowed methods) on `METHOD_NOT_ALLOWED`, or `RuntimeException` otherwise. |
| `resolveRoutingResultsFromRequest` *(protected)* | `ServerRequestInterface $request` | [`RoutingResults`](03_routing.md#slim-routing-routingresults) | Calls `$this->routeResolver->computeRoutingResults($request->getUri()->getPath(), $request->getMethod())`. |

### Usage Example

```php
use Slim\Factory\AppFactory;

$app = AppFactory::create();

// Register RoutingMiddleware via the App helper before ErrorMiddleware:
$app->addRoutingMiddleware();

// Any middleware added BEFORE addRoutingMiddleware() (i.e. inner to it) can read RouteContext:
$app->addErrorMiddleware(true, true, true);
```

---

## `class` Slim\Middleware\ErrorMiddleware

- **Source**: `Slim/Middleware/ErrorMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`ErrorMiddleware` wraps downstream request execution in a `try / catch (Throwable $e)` block and delegates caught exceptions or PHP errors to a mapped [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) or custom error handler callable. When catching an [`HttpException`](07_exceptions.md#slim-exception-httpexception), it extracts the most recent `ServerRequestInterface` via `$exception->getRequest()` so routing attributes added inside the pipeline remain available to error renderers.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Psr\Log\LoggerInterface;
use Slim\Handlers\ErrorHandler;
use Slim\Interfaces\CallableResolverInterface;
use Slim\Interfaces\ErrorHandlerInterface;
use Throwable;

/** @api */
class ErrorMiddleware implements MiddlewareInterface
{
    protected CallableResolverInterface $callableResolver;
    protected ResponseFactoryInterface $responseFactory;
    protected bool $displayErrorDetails;
    protected bool $logErrors;
    protected bool $logErrorDetails;
    protected ?LoggerInterface $logger = null;
    protected array $handlers = [];
    protected array $subClassHandlers = [];
    protected $defaultErrorHandler;

    public function __construct(
        CallableResolverInterface $callableResolver,
        ResponseFactoryInterface $responseFactory,
        bool $displayErrorDetails,
        bool $logErrors,
        bool $logErrorDetails,
        ?LoggerInterface $logger = null
    );

    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;

    public function handleException(
        ServerRequestInterface $request,
        Throwable $exception
    ): ResponseInterface;

    public function getErrorHandler(string $type);
    public function getDefaultErrorHandler();
    public function setDefaultErrorHandler($handler): self;
    public function setErrorHandler(
        $typeOrTypes,
        $handler,
        bool $handleSubclasses = false
    ): self;
}
```

### Properties

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | Resolves string/container error handler definitions into invokable callables. |
| `$responseFactory` | `ResponseFactoryInterface` | — | Passed to the default [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) when lazily instantiated. |
| `$displayErrorDetails` | `bool` | — | Whether detailed exception messages and stack traces should be included in the response payload. |
| `$logErrors` | `bool` | — | Whether exceptions should be logged through the error handler's logger. |
| `$logErrorDetails` | `bool` | — | Whether full stack traces and previous exceptions should be included in error logs. |
| `$logger` | `?LoggerInterface` | `null` | Optional PSR-3 logger passed to the default [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler). |
| `$handlers` | `array<class-string, ErrorHandlerInterface\|callable\|string>` | `[]` | Exact exception class name -> handler map. |
| `$subClassHandlers` | `array<class-string, ErrorHandlerInterface\|callable\|string>` | `[]` | Base exception/interface name -> handler map matched via `is_subclass_of()`. |
| `$defaultErrorHandler` | `ErrorHandlerInterface\|callable\|string\|null` | `null` | Default fallback error handler (lazily initialized to [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)). |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `CallableResolverInterface $callableResolver`, `ResponseFactoryInterface $responseFactory`, `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails`, `?LoggerInterface $logger = null` | `void` | Configures error display, logging flags, and dependencies. |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | Executes `$handler->handle($request)` inside a `try` block and passes any thrown `Throwable` to `handleException()`. |
| `handleException` | `ServerRequestInterface $request`, `Throwable $exception` | `ResponseInterface` | Replaces `$request` with `$exception->getRequest()` if `$exception instanceof HttpException`, resolves the handler via `getErrorHandler(get_class($exception))`, and invokes it with `($request, $exception, $displayErrorDetails, $logErrors, $logErrorDetails)`. |
| `getErrorHandler` | `string $type` | `callable\|ErrorHandler` | Checks `$this->handlers[$type]`, then `$this->subClassHandlers[$type]`, then iterates `$this->subClassHandlers` with `is_subclass_of($type, $class)`, and finally falls back to `getDefaultErrorHandler()`. |
| `getDefaultErrorHandler` | *(none)* | `ErrorHandler\|callable` | Lazily creates a [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) if `$defaultErrorHandler === null`, then resolves and returns it via `$callableResolver->resolve()`. |
| `setDefaultErrorHandler` | `string\|callable\|ErrorHandlerInterface $handler` | `self` | Sets the default fallback error handler and returns `$this`. |
| `setErrorHandler` | `string\|string[] $typeOrTypes`, `string\|callable\|ErrorHandlerInterface $handler`, `bool $handleSubclasses = false` | `self` | Registers `$handler` for one or more exception class names in `$handlers` (or `$subClassHandlers` when `$handleSubclasses` is `true`). |

### Usage Example

```php
use DomainException;
use Slim\Exception\HttpNotFoundException;
use Slim\Factory\AppFactory;

$app = AppFactory::create();
$errorMiddleware = $app->addErrorMiddleware(false, true, true, $logger);

// Register a custom handler for DomainException and all its subclasses
$errorMiddleware->setErrorHandler(
    DomainException::class,
    CustomDomainErrorHandler::class,
    true
);

// Customize the default ErrorHandler (e.g. force JSON output)
$defaultHandler = $errorMiddleware->getDefaultErrorHandler();
$defaultHandler->forceContentType('application/json');
```

---

## `class` Slim\Middleware\BodyParsingMiddleware

- **Source**: `Slim/Middleware/BodyParsingMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`BodyParsingMiddleware` inspects the inbound request's `Content-Type` header when `$request->getParsedBody()` is empty, parses the raw request body stream using a media-type parser registry, and returns a new request instance via `$request->withParsedBody($parsedBody)`. Out of the box, it registers parsers for `application/json`, `application/x-www-form-urlencoded`, `application/xml`, and `text/xml`, and automatically resolves RFC 6839 structured syntax suffixes (`+json`, `+xml`).

```drawlib align=center code=fold file=error_and_body_middleware_flow.png caption="ErrorMiddleware Handler Resolution Order (Left) and BodyParsingMiddleware Media-Type Dispatch (Right)"
from drawlib.canvas import save, setup
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=84)

# Left Panel: ErrorMiddleware
rectangle(
    (46, 42),
    width=80,
    height=74,
    style=Styles.Neutral.patch(shape_r=3.0),
)
text((46, 73.5), "ErrorMiddleware::getErrorHandler()", style=Styles.PrimaryBold.patch(text_size=11.5))

rectangle(
    (46, 59),
    width=66,
    height=12,
    style=Styles.PrimaryFlat.patch(shape_r=2.0),
)
text((46, 61.5), "1. Exact Class Match", style=Styles.WhiteBold.patch(text_size=11.0))
text((46, 56.5), "handlers[type] direct lookup", style=Styles.White.patch(text_size=10.0))

rectangle(
    (46, 40),
    width=66,
    height=12,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((46, 42.5), "2. Subclass Match", style=Styles.BlackBold.patch(text_size=11.0))
text((46, 37.5), "is_subclass_of(type, class)", style=Styles.Dark.patch(text_size=10.0))

rectangle(
    (46, 21),
    width=66,
    height=12,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((46, 23.5), "3. Default ErrorHandler", style=Styles.BlackBold.patch(text_size=11.0))
text((46, 18.5), "getDefaultErrorHandler()", style=Styles.Dark.patch(text_size=10.0))

line((46, 53), (46, 46), arrow_head="->", style=Styles.PrimaryBold)
line((46, 34), (46, 27), arrow_head="->", style=Styles.PrimaryBold)

# Right Panel: BodyParsingMiddleware
rectangle(
    (134, 42),
    width=80,
    height=74,
    style=Styles.PrimaryNeutral.patch(shape_r=3.0),
)
text((134, 73.5), "BodyParsingMiddleware::parseBody()", style=Styles.PrimaryBold.patch(text_size=11.5))

rectangle(
    (134, 59),
    width=66,
    height=12,
    style=Styles.AccentFlat.patch(shape_r=2.0),
)
text((134, 61.5), "1. Exact Media Type", style=Styles.WhiteBold.patch(text_size=11.0))
text((134, 56.5), "json / form-urlencoded / xml", style=Styles.White.patch(text_size=10.0))

rectangle(
    (134, 40),
    width=66,
    height=12,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((134, 42.5), "2. RFC 6839 +Suffix Fallback", style=Styles.BlackBold.patch(text_size=11.0))
text((134, 37.5), "vnd.api+json -> application/json", style=Styles.Dark.patch(text_size=9.5))

rectangle(
    (134, 21),
    width=66,
    height=12,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((134, 23.5), "3. Validate & Attach", style=Styles.BlackBold.patch(text_size=11.0))
text((134, 18.5), "array | object | null -> Request", style=Styles.Dark.patch(text_size=10.0))

line((134, 53), (134, 46), arrow_head="->", style=Styles.PrimaryBold)
line((134, 34), (134, 27), arrow_head="->", style=Styles.PrimaryBold)

save()
```

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use RuntimeException;

/** @api */
class BodyParsingMiddleware implements MiddlewareInterface
{
    /** @var callable[] */
    protected array $bodyParsers;

    /**
     * @param callable[] $bodyParsers
     */
    public function __construct(array $bodyParsers = []);

    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;

    public function registerBodyParser(string $mediaType, callable $callable): self;
    public function hasBodyParser(string $mediaType): bool;
    public function getBodyParser(string $mediaType): callable;

    protected function registerDefaultBodyParsers(): void;
    protected function parseBody(ServerRequestInterface $request);
    protected function getMediaType(ServerRequestInterface $request): ?string;
    protected static function disableXmlEntityLoader(bool $disable): bool;
}
```

### Properties & Default Parsers

| Property / Media Type | Type / Parser Behavior | Description |
| :--- | :--- | :--- |
| `$bodyParsers` | `array<string, callable>` | Associative map of lowercase media type strings to parser callables `fn(string $input): array\|object\|null`. |
| `application/json` | `json_decode($input, true)` | Decodes JSON into an associative `array` (returns `null` if decoded result is not an array). |
| `application/x-www-form-urlencoded` | `parse_str($input, $data)` | Parses URL-encoded query strings into an associative `array`. |
| `application/xml`, `text/xml` | `simplexml_load_string($input)` | Safely parses XML with external entity loading disabled and internal error suppression; returns `SimpleXMLElement` or `null`. |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `array<string, callable> $bodyParsers = []` | `void` | Calls `registerDefaultBodyParsers()` and registers any custom `$bodyParsers` passed to the constructor. |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | If `$request->getParsedBody()` is `empty()`, parses the body via `parseBody($request)` and attaches it via `$request->withParsedBody($parsedBody)` before calling `$handler->handle($request)`. |
| `registerBodyParser` | `string $mediaType`, `callable $callable` | `self` | Registers or overrides a parser callable for `$mediaType` and returns `$this`. |
| `hasBodyParser` | `string $mediaType` | `bool` | Returns `true` if a parser is registered for `$mediaType`. |
| `getBodyParser` | `string $mediaType` | `callable` | Returns the registered parser callable for `$mediaType`. Throws `RuntimeException` if none exists. |
| `registerDefaultBodyParsers` *(protected)* | *(none)* | `void` | Registers the built-in JSON, form-urlencoded, `application/xml`, and `text/xml` parsers. |
| `parseBody` *(protected)* | `ServerRequestInterface $request` | `null\|array<mixed>\|object` | Extracts the media type, checks exact match or `'application/' . $suffix` fallback, invokes the parser with `(string) $request->getBody()`, and validates that the return value is `array`, `object`, or `null` (throwing `RuntimeException` otherwise). |
| `getMediaType` *(protected)* | `ServerRequestInterface $request` | `?string` | Reads the first `Content-Type` header, strips parameters after `;`, and returns the lowercase trimmed media type string or `null`. |
| `disableXmlEntityLoader` *(protected static)* | `bool $disable` | `bool` | No-op returning `true` on `LIBXML_VERSION >= 20900` (where external entities are disabled by default); calls `libxml_disable_entity_loader($disable)` on older libxml builds. |

### Usage Example

```php
use Slim\Factory\AppFactory;

$app = AppFactory::create();

// Register BodyParsingMiddleware via the App helper:
$bodyParsingMiddleware = $app->addBodyParsingMiddleware();

// Add a custom YAML body parser:
$bodyParsingMiddleware->registerBodyParser('application/x-yaml', function (string $input) {
    $parsed = yaml_parse($input);
    return is_array($parsed) ? $parsed : null;
});
```

---

## `class` Slim\Middleware\ContentLengthMiddleware

- **Source**: `Slim/Middleware/ContentLengthMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`ContentLengthMiddleware` is an outbound post-processing middleware that inspects the `ResponseInterface` returned by `$handler->handle($request)` and automatically attaches a `Content-Length` header if `$response->getBody()->getSize()` is non-null and no `Content-Length` header is already present.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/** @api */
class ContentLengthMiddleware implements MiddlewareInterface
{
    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;
}
```

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | Calls `$handler->handle($request)`, checks `$response->getBody()->getSize()`, and adds `Content-Length: (string) $size` if `$size !== null` and `!$response->hasHeader('Content-Length')`. |

### Usage Example

```php
use Slim\Factory\AppFactory;
use Slim\Middleware\ContentLengthMiddleware;

$app = AppFactory::create();

// Add near the outside of the middleware stack so all responses receive Content-Length:
$app->add(new ContentLengthMiddleware());
```

---

## `class` Slim\Middleware\MethodOverrideMiddleware

- **Source**: `Slim/Middleware/MethodOverrideMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`MethodOverrideMiddleware` allows HTML forms and restricted HTTP clients to tunnel `PUT`, `PATCH`, or `DELETE` requests over `POST` or custom headers. It checks the `X-Http-Method-Override` request header first; if absent and the request method is `POST`, it checks `$request->getParsedBody()['_METHOD']` and rewinds the request body stream if EOF was reached.

> [!IMPORTANT]
> When using the `POST` body `_METHOD` parameter with `application/x-www-form-urlencoded` or `application/json` payloads, `BodyParsingMiddleware` must execute **before** `MethodOverrideMiddleware`, and `MethodOverrideMiddleware` must execute **before** `RoutingMiddleware`. Because Slim's middleware stack is LIFO, register them in reverse order: `addRoutingMiddleware()`, then `add(MethodOverrideMiddleware)`, then `addBodyParsingMiddleware()`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

/** @api */
class MethodOverrideMiddleware implements MiddlewareInterface
{
    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;
}
```

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | Overrides `$request` method via `$request->withMethod(...)` when `X-Http-Method-Override` header is present or when a `POST` request's parsed body array contains a non-empty string `_METHOD`, then delegates to `$handler->handle($request)`. |

### Usage Example

```php
use Slim\Factory\AppFactory;
use Slim\Middleware\MethodOverrideMiddleware;

$app = AppFactory::create();

// LIFO registration order:
// 1. RoutingMiddleware runs 3rd (uses overridden method)
$app->addRoutingMiddleware();

// 2. MethodOverrideMiddleware runs 2nd (reads parsed body _METHOD or header)
$app->add(new MethodOverrideMiddleware());

// 3. BodyParsingMiddleware runs 1st (parses POST body)
$app->addBodyParsingMiddleware();
```

---

## `class` Slim\Middleware\OutputBufferingMiddleware

- **Source**: `Slim/Middleware/OutputBufferingMiddleware.php`
- **Namespace**: `Slim\Middleware`
- **Implements**: `Psr\Http\Server\MiddlewareInterface`

`OutputBufferingMiddleware` captures any stray PHP output (`echo`, `print`, `var_dump`) emitted during downstream middleware and route execution using `ob_start()` and `ob_get_clean()`, and either appends or prepends the captured buffer to the PSR-7 `ResponseInterface` body. If an exception is thrown downstream, it safely cleans the buffer with `ob_end_clean()` before rethrowing.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Middleware;

use InvalidArgumentException;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\StreamFactoryInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;
use Throwable;

/** @api */
class OutputBufferingMiddleware implements MiddlewareInterface
{
    public const APPEND = 'append';
    public const PREPEND = 'prepend';

    protected StreamFactoryInterface $streamFactory;
    protected string $style;

    public function __construct(
        StreamFactoryInterface $streamFactory,
        string $style = 'append'
    );

    public function process(
        ServerRequestInterface $request,
        RequestHandlerInterface $handler
    ): ResponseInterface;
}
```

### Constants & Properties

| Constant / Property | Type / Value | Visibility | Description |
| :--- | :--- | :--- | :--- |
| `APPEND` | `'append'` | `public const` | Writes captured output buffer contents to the end of the existing response body stream (`$response->getBody()->write($output)`). |
| `PREPEND` | `'prepend'` | `public const` | Creates a new stream via `$streamFactory->createStream()`, writes `$output . $response->getBody()`, and replaces the response body. |
| `$streamFactory` | `StreamFactoryInterface` | `protected` | PSR-17 stream factory used to create a new response stream when `$style === self::PREPEND`. |
| `$style` | `string` | `protected` | Active buffering mode (`'append'` or `'prepend'`). |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct` | `StreamFactoryInterface $streamFactory`, `string $style = 'append'` | `void` | Initializes the middleware with a PSR-17 `StreamFactoryInterface` and buffer style. Throws `InvalidArgumentException` if `$style` is neither `'append'` nor `'prepend'`. |
| `process` | `ServerRequestInterface $request`, `RequestHandlerInterface $handler` | `ResponseInterface` | Starts an output buffer (`ob_start()`), invokes `$handler->handle($request)`, collects buffered output (`ob_get_clean()`), and appends or prepends non-empty output onto `$response`. Cleans buffer (`ob_end_clean()`) and rethrows on any `Throwable`. |

### Usage Example

```php
use Slim\Factory\AppFactory;
use Slim\Middleware\OutputBufferingMiddleware;
use Slim\Psr7\Factory\StreamFactory;

$app = AppFactory::create();

$streamFactory = new StreamFactory();
$app->add(new OutputBufferingMiddleware($streamFactory, OutputBufferingMiddleware::APPEND));
```
