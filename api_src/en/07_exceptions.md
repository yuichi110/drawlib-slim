# HTTP Exceptions (`Slim\Exception\*`)

The `Slim\Exception` namespace (`11` classes across `11` files in `Slim/Exception/`) provides a strongly typed HTTP exception hierarchy rooted at PHP's SPL `RuntimeException`. Every exception encapsulates the originating PSR-7 `ServerRequestInterface` alongside human-readable `$title` and `$description` metadata consumed by [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware), [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), and [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer).

```drawlib align=center code=fold file=api_exceptions_hierarchy.png caption="Slim\Exception Class Hierarchy — RuntimeException to HttpException, HttpSpecializedException, and 9 Concrete HTTP Status Classes"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=90, dpi=150)

# Left Panel: Inheritance Spine (RuntimeException -> HttpException -> HttpSpecializedException)
p_left = Panel(
    "Inheritance Spine (Slim\\Exception\\*)",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.git_fork,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_left.draw((4.0, 4.0), width=92.0, height=82.0)
lx, lw, lh = p_left.get_content_box((4.0, 4.0), width=92.0, height=82.0, padding=(3.5, 3.0))

cl_spine = CardList(
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
cl_spine.add(
    "\\RuntimeException (PHP SPL)",
    "Base PHP exception implementing \\Throwable",
    badge_text="SPL",
    icon=phosphor.code,
)
cl_spine.add(
    "HttpException (Base Class)",
    "Holds request, title, description + setters",
    badge_text="Base",
    icon=phosphor.file_code,
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
)
cl_spine.add(
    "HttpSpecializedException (abstract)",
    "3-arg __construct(request, message, previous)",
    badge_text="Abs",
    icon=phosphor.git_merge,
    style=Styles.PrimaryNeutral,
)
cl_spine.add(
    "9 Concrete Status Subclasses",
    "Pre-bind code (400–501), message & title",
    badge_text="9x",
    icon=phosphor.stack,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_spine.draw(xy=lx, width=lw, height=lh)

# Right Panel: 9 Concrete HTTP Status Exception Classes
p_right = Panel(
    "9 Concrete Status Subclasses (400–501)",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.warning_octagon,
    icon_style=Styles.SecondaryBold,
    header_variant="filled",
    header_height=8.6,
)
p_right.draw((100.0, 4.0), width=92.0, height=82.0)
rx, rw, rh = p_right.get_content_box((100.0, 4.0), width=92.0, height=82.0, padding=(3.5, 3.0))

cl = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.6,
)
cl.add(
    "400 · 401 · 403 Client Auth & Input",
    "BadRequest (400) · Unauthorized · Forbidden",
    badge_text="4xx",
    icon=phosphor.shield_warning,
)
cl.add(
    "404 NotFound & 405 MethodNotAllowed",
    "Thrown by router; 405 stores allowedMethods",
    badge_text="404",
    icon=phosphor.signpost,
    style=Styles.AccentFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
    icon_style=Styles.SecondaryBold,
)
cl.add(
    "410 Gone & 429 TooManyRequests",
    "Removed resource (410) & rate limit (429)",
    badge_text="4xx",
    icon=phosphor.clock_countdown,
    style=Styles.PrimaryNeutral,
)
cl.add(
    "500 InternalError & 501 NotImplemented",
    "Server failure (500) & unimplemented (501)",
    badge_text="5xx",
    icon=phosphor.bug,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl.draw(xy=rx, width=rw, height=rh)

save()
```

### Summary Matrix of `Slim\Exception\*` Classes

| Class | Source File | HTTP `$code` | Default `$message` | Default `$title` | Extra State / Methods |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [`HttpException`](#slim-exception-httpexception) | `Slim/Exception/HttpException.php` | `0` (param) | `''` (param) | `''` | `$request`, `$title`, `$description` getters/setters |
| [`HttpSpecializedException`](#slim-exception-httpspecializedexception) | `Slim/Exception/HttpSpecializedException.php` | *(abstract)* | *(abstract)* | *(inherited)* | 3-arg `__construct($request, ?$message, ?$previous)` |
| [`HttpBadRequestException`](#slim-exception-httpbadrequestexception) | `Slim/Exception/HttpBadRequestException.php` | `400` | `'Bad request.'` | `'400 Bad Request'` | — |
| [`HttpUnauthorizedException`](#slim-exception-httpunauthorizedexception) | `Slim/Exception/HttpUnauthorizedException.php` | `401` | `'Unauthorized.'` | `'401 Unauthorized'` | — |
| [`HttpForbiddenException`](#slim-exception-httpforbiddenexception) | `Slim/Exception/HttpForbiddenException.php` | `403` | `'Forbidden.'` | `'403 Forbidden'` | — |
| [`HttpNotFoundException`](#slim-exception-httpnotfoundexception) | `Slim/Exception/HttpNotFoundException.php` | `404` | `'Not found.'` | `'404 Not Found'` | Thrown by [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) |
| [`HttpMethodNotAllowedException`](#slim-exception-httpmethodnotallowedexception) | `Slim/Exception/HttpMethodNotAllowedException.php` | `405` | `'Method not allowed.'` | `'405 Method Not Allowed'` | `$allowedMethods`, `getAllowedMethods()`, `setAllowedMethods()` |
| [`HttpGoneException`](#slim-exception-httpgoneexception) | `Slim/Exception/HttpGoneException.php` | `410` | `'Gone.'` | `'410 Gone'` | — |
| [`HttpTooManyRequestsException`](#slim-exception-httptoomanyrequestsexception) | `Slim/Exception/HttpTooManyRequestsException.php` | `429` | `'Too many requests.'` | `'429 Too Many Requests'` | — |
| [`HttpInternalServerErrorException`](#slim-exception-httpinternalservererrorexception) | `Slim/Exception/HttpInternalServerErrorException.php` | `500` | `'Internal server error.'` | `'500 Internal Server Error'` | — |
| [`HttpNotImplementedException`](#slim-exception-httpnotimplementedexception) | `Slim/Exception/HttpNotImplementedException.php` | `501` | `'Not implemented.'` | `'501 Not Implemented'` | — |

```drawlib align=center code=fold file=api_exceptions_propagation_flow.png caption="HTTP Exception Propagation — Throw Sites, ErrorMiddleware Catch Boundary, and ErrorRenderer Metadata Extraction"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=84, dpi=150)

# Left Panel: Exception Origin & Throw Sites
p_left = Panel(
    "Phase 1 · Exception Origin & Throw Sites",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.lightning,
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
    show_arrows=True,
    arrow_style=Styles.DarkBold.patch(line_arrow_head_scale=10, line_width=1.4),
)
cl_left.add(
    "RoutingMiddleware::performRouting()",
    "Throws 404 NotFound or 405 MethodNotAllowed",
    badge_text="T1",
    icon=phosphor.git_branch,
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=10.0),
    badge_style=Styles.White,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
)
cl_left.add(
    "Application Middleware & Route Handlers",
    "Throw 400 BadRequest, 401 Unauthorized, etc.",
    badge_text="T2",
    icon=phosphor.code,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "Custom Title & Description Overrides",
    "Fluent setTitle() & setDescription() calls",
    badge_text="T3",
    icon=phosphor.pencil_simple,
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: ErrorMiddleware Catch & ErrorHandler Rendering
p_right = Panel(
    "Phase 2 · ErrorMiddleware & Rendering",
    "",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.SecondaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.0),
    icon=phosphor.shield_check,
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
    "ErrorMiddleware::handleException()",
    "Resolves exact class or subclass handler",
    badge_text="E1",
    icon=phosphor.funnel,
)
cl_right.add(
    "ErrorHandler Status & Allow Header",
    "Reads getCode(); sets Allow header on 405",
    badge_text="E2",
    icon=phosphor.scales,
    style=Styles.SecondaryNeutral,
)
cl_right.add(
    "AbstractErrorRenderer Output",
    "Uses getTitle() & getDescription() safely",
    badge_text="E3",
    icon=phosphor.file_text,
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

## `class` Slim\Exception\HttpException

- **Source File**: `Slim/Exception/HttpException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: `\RuntimeException` (implements `\Throwable`)
- **Direct Subclasses**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception)
- **Consumed By**: [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware), [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer)

`HttpException` is the base runtime exception for all HTTP-aware errors in Slim 4. It binds the active PSR-7 `ServerRequestInterface` instance to the exception and provides fluent accessors for `$title` and `$description` so [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) can render safe, user-facing error summaries even when `$displayErrorDetails` is `false`.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

use Psr\Http\Message\ServerRequestInterface;
use RuntimeException;
use Throwable;

/**
 * @api
 * @method int getCode()
 */
class HttpException extends RuntimeException
{
    protected ServerRequestInterface $request;

    protected string $title = '';

    protected string $description = '';

    public function __construct(
        ServerRequestInterface $request,
        string $message = '',
        int $code = 0,
        ?Throwable $previous = null
    );

    public function getRequest(): ServerRequestInterface;

    public function getTitle(): string;

    public function setTitle(string $title): self;

    public function getDescription(): string;

    public function setDescription(string $description): self;
}
```

### Properties, Constructor & Methods

| Member | Visibility & Type | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| `$request` | `protected ServerRequestInterface` | — | — | The PSR-7 server request active when the exception was thrown. |
| `$title` | `protected string` | — | — | Short human-readable error title (default `''`). |
| `$description` | `protected string` | — | — | Extended human-readable explanation (default `''`). |
| `__construct()` | `public` | `ServerRequestInterface $request`, `string $message = ''`, `int $code = 0`, `?Throwable $previous = null` | `void` | Calls `parent::__construct($message, $code, $previous)` and stores `$this->request = $request`. |
| `getRequest()` | `public` | *(none)* | `ServerRequestInterface` | Returns the associated PSR-7 `ServerRequestInterface` instance. |
| `getTitle()` | `public` | *(none)* | `string` | Returns the exception title used by [`AbstractErrorRenderer::getErrorTitle()`](06_error_renderers.md#slim-error-abstracterrorrenderer). |
| `setTitle()` | `public` | `string $title` | `self` | Sets a custom error title and returns `$this` for fluent chaining. |
| `getDescription()` | `public` | *(none)* | `string` | Returns the exception description used by [`AbstractErrorRenderer::getErrorDescription()`](06_error_renderers.md#slim-error-abstracterrorrenderer). |
| `setDescription()` | `public` | `string $description` | `self` | Sets a custom error description and returns `$this` for fluent chaining. |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpException;

$app->post('/webhooks', function (Request $request, Response $response): Response {
    if (!$request->hasHeader('X-Signature')) {
        throw (new HttpException($request, 'Missing webhook signature header.', 422))
            ->setTitle('422 Unprocessable Content')
            ->setDescription('Every webhook delivery must include an X-Signature HMAC header.');
    }

    return $response->withStatus(202);
});
```

---

## `class` Slim\Exception\HttpSpecializedException

- **Source File**: `Slim/Exception/HttpSpecializedException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpException`](#slim-exception-httpexception)
- **Modifier**: `abstract class`
- **Direct Subclasses**: [`HttpBadRequestException`](#slim-exception-httpbadrequestexception), [`HttpUnauthorizedException`](#slim-exception-httpunauthorizedexception), [`HttpForbiddenException`](#slim-exception-httpforbiddenexception), [`HttpNotFoundException`](#slim-exception-httpnotfoundexception), [`HttpMethodNotAllowedException`](#slim-exception-httpmethodnotallowedexception), [`HttpGoneException`](#slim-exception-httpgoneexception), [`HttpTooManyRequestsException`](#slim-exception-httptoomanyrequestsexception), [`HttpInternalServerErrorException`](#slim-exception-httpinternalservererrorexception), [`HttpNotImplementedException`](#slim-exception-httpnotimplementedexception)

`HttpSpecializedException` is the abstract intermediate base class for all status-code-specific HTTP exceptions. It simplifies instantiation to a 3-argument constructor `($request, ?$message = null, ?$previous = null)` by automatically forwarding the concrete subclass's `$this->code` and default `$this->message` to [`HttpException::__construct()`](#slim-exception-httpexception).

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

use Psr\Http\Message\ServerRequestInterface;
use Throwable;

abstract class HttpSpecializedException extends HttpException
{
    /**
     * @param ServerRequestInterface $request
     * @param string|null $message
     * @param Throwable|null $previous
     */
    public function __construct(
        ServerRequestInterface $request,
        ?string $message = null,
        ?Throwable $previous = null
    ) {
        if ($message !== null) {
            $this->message = $message;
        }

        parent::__construct($request, $this->message, $this->code, $previous);
    }
}
```

### Constructor & Inherited Methods

| Member | Visibility & Type | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| `__construct()` | `public` | `ServerRequestInterface $request`, `?string $message = null`, `?Throwable $previous = null` | `void` | Overrides `$this->message` only when `$message !== null`, then invokes `parent::__construct($request, $this->message, $this->code, $previous)`. |

### Usage Example

```php
use Slim\Exception\HttpSpecializedException;

// Define a custom 409 Conflict specialized exception for domain entities:
final class HttpConflictException extends HttpSpecializedException
{
    /** @var int */
    protected $code = 409;

    /** @var string */
    protected $message = 'Conflict.';

    protected string $title = '409 Conflict';
    protected string $description = 'The request could not be completed due to a state conflict with the target resource.';
}
```

---

## `class` Slim\Exception\HttpBadRequestException

- **Source File**: `Slim/Exception/HttpBadRequestException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `400 Bad Request`** client error when request syntax, query parameters, or body payload validation fails.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpBadRequestException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 400;

    /**
     * @var string
     */
    protected $message = 'Bad request.';

    protected string $title = '400 Bad Request';
    protected string $description = 'The server cannot or will not process ' .
        'the request due to an apparent client error.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `400` | HTTP status code `400`. |
| `$message` | `protected string` | `'Bad request.'` | Default exception message when `$message` constructor arg is `null`. |
| `$title` | `protected string` | `'400 Bad Request'` | Default error title rendered by [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface). |
| `$description` | `protected string` | `'The server cannot or will not process the request due to an apparent client error.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpBadRequestException;

$app->post('/users', function (Request $request, Response $response): Response {
    $data = (array) $request->getParsedBody();
    if (empty($data['email'])) {
        throw new HttpBadRequestException($request, 'Field "email" is required.');
    }
    return $response->withStatus(201);
});
```

---

## `class` Slim\Exception\HttpUnauthorizedException

- **Source File**: `Slim/Exception/HttpUnauthorizedException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `401 Unauthorized`** client error when a request lacks valid authentication credentials (e.g., missing or expired Bearer token).

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpUnauthorizedException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 401;

    /**
     * @var string
     */
    protected $message = 'Unauthorized.';

    protected string $title = '401 Unauthorized';
    protected string $description = 'The request requires valid user authentication.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `401` | HTTP status code `401`. |
| `$message` | `protected string` | `'Unauthorized.'` | Default exception message. |
| `$title` | `protected string` | `'401 Unauthorized'` | Default error title. |
| `$description` | `protected string` | `'The request requires valid user authentication.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Exception\HttpUnauthorizedException;

$authMiddleware = function (Request $request, RequestHandler $handler) {
    if (!$request->hasHeader('Authorization')) {
        throw new HttpUnauthorizedException($request, 'Missing Bearer token.');
    }
    return $handler->handle($request);
};
```

---

## `class` Slim\Exception\HttpForbiddenException

- **Source File**: `Slim/Exception/HttpForbiddenException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `403 Forbidden`** client error when an authenticated caller lacks permission or scope to perform the requested operation.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpForbiddenException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 403;

    /**
     * @var string
     */
    protected $message = 'Forbidden.';

    protected string $title = '403 Forbidden';
    protected string $description = 'You are not permitted to perform the requested operation.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `403` | HTTP status code `403`. |
| `$message` | `protected string` | `'Forbidden.'` | Default exception message. |
| `$title` | `protected string` | `'403 Forbidden'` | Default error title. |
| `$description` | `protected string` | `'You are not permitted to perform the requested operation.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpForbiddenException;

$app->delete('/admin/users/{id}', function (Request $request, Response $response): Response {
    if ($request->getAttribute('role') !== 'admin') {
        throw new HttpForbiddenException($request, 'Admin privileges are required to delete users.');
    }
    return $response->withStatus(204);
});
```

---

## `class` Slim\Exception\HttpNotFoundException

- **Source File**: `Slim/Exception/HttpNotFoundException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`
- **Thrown By**: [`Slim\Middleware\RoutingMiddleware::performRouting()`](04_middleware.md#slim-middleware-routingmiddleware) when `RoutingResults::getRouteStatus()` is `RoutingResults::NOT_FOUND` (`0`), or directly by application route handlers.

Represents an **HTTP `404 Not Found`** error when no route pattern matches the request URI or a domain entity lookup returns null.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

class HttpNotFoundException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 404;

    /**
     * @var string
     */
    protected $message = 'Not found.';

    protected string $title = '404 Not Found';
    protected string $description = 'The requested resource could not be found. Please verify the URI and try again.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `404` | HTTP status code `404`. |
| `$message` | `protected string` | `'Not found.'` | Default exception message. |
| `$title` | `protected string` | `'404 Not Found'` | Default error title. |
| `$description` | `protected string` | `'The requested resource could not be found. Please verify the URI and try again.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpNotFoundException;

$app->get('/articles/{slug}', function (Request $request, Response $response, array $args): Response {
    $article = $this->get(ArticleRepository::class)->findBySlug($args['slug']);
    if ($article === null) {
        throw new HttpNotFoundException($request, sprintf('Article "%s" was not found.', $args['slug']));
    }
    $response->getBody()->write(json_encode($article, JSON_THROW_ON_ERROR));
    return $response->withHeader('Content-Type', 'application/json');
});
```

---

## `class` Slim\Exception\HttpMethodNotAllowedException

- **Source File**: `Slim/Exception/HttpMethodNotAllowedException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`
- **Thrown By**: [`Slim\Middleware\RoutingMiddleware::performRouting()`](04_middleware.md#slim-middleware-routingmiddleware) when `RoutingResults::getRouteStatus()` is `RoutingResults::METHOD_NOT_ALLOWED` (`2`).
- **Special Handling in `ErrorHandler`**: [`ErrorHandler::createResponse()`](05_handlers_and_strategies.md#slim-handlers-errorhandler) inspects `$this->exception instanceof HttpMethodNotAllowedException` and automatically populates the HTTP `Allow` response header from `getAllowedMethods()`.

Represents an **HTTP `405 Method Not Allowed`** error when the URI path matches a registered route pattern, but the HTTP request method is not supported by that route.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

use function implode;

class HttpMethodNotAllowedException extends HttpSpecializedException
{
    /**
     * @var string[]
     */
    protected array $allowedMethods = [];

    /**
     * @var int
     */
    protected $code = 405;

    /**
     * @var string
     */
    protected $message = 'Method not allowed.';

    protected string $title = '405 Method Not Allowed';
    protected string $description = 'The request method is not supported for the requested resource.';

    /**
     * @return string[]
     */
    public function getAllowedMethods(): array;

    /**
     * @param string[] $methods
     */
    public function setAllowedMethods(array $methods): self;
}
```

### Properties, Constructor & Methods

| Member | Visibility & Type | Parameters / Default | Return Type | Description |
| :--- | :--- | :--- | :--- | :--- |
| `$allowedMethods` | `protected string[]` | `[]` | — | List of HTTP verbs permitted for the matched URI pattern. |
| `$code` | `protected int` | `405` | — | HTTP status code `405`. |
| `$message` | `protected string` | `'Method not allowed.'` | — | Default message; updated by `setAllowedMethods()`. |
| `$title` | `protected string` | `'405 Method Not Allowed'` | — | Default error title. |
| `$description` | `protected string` | `'The request method is not supported for the requested resource.'` | — | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | `void` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |
| `getAllowedMethods()` | `public` | *(none)* | `string[]` | Returns the array of allowed HTTP methods (e.g. `['GET', 'POST']`). |
| `setAllowedMethods()` | `public` | `string[] $methods` | `self` | Stores `$this->allowedMethods = $methods`, updates `$this->message` to `'Method not allowed. Must be one of: ' . implode(', ', $methods)`, and returns `$this`. |

### Usage Example

```php
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpMethodNotAllowedException;

// Inside RoutingMiddleware::performRouting() or custom routing logic:
$exception = new HttpMethodNotAllowedException($request);
$exception->setAllowedMethods(['GET', 'HEAD', 'POST']);
// $exception->getMessage() === 'Method not allowed. Must be one of: GET, HEAD, POST'
throw $exception;
```

---

## `class` Slim\Exception\HttpGoneException

- **Source File**: `Slim/Exception/HttpGoneException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `410 Gone`** error indicating that the target resource was intentionally and permanently removed from the origin server.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpGoneException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 410;

    /**
     * @var string
     */
    protected $message = 'Gone.';

    protected string $title = '410 Gone';
    protected string $description = 'The target resource is no longer available at the origin server.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `410` | HTTP status code `410`. |
| `$message` | `protected string` | `'Gone.'` | Default exception message. |
| `$title` | `protected string` | `'410 Gone'` | Default error title. |
| `$description` | `protected string` | `'The target resource is no longer available at the origin server.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpGoneException;

$app->get('/v1/legacy-export', function (Request $request, Response $response): Response {
    throw (new HttpGoneException($request, 'The v1 export endpoint has been permanently decommissioned.'))
        ->setDescription('Please migrate to /v2/exports.');
});
```

---

## `class` Slim\Exception\HttpTooManyRequestsException

- **Source File**: `Slim/Exception/HttpTooManyRequestsException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `429 Too Many Requests`** error when a client exceeds its configured request rate limit or quota window.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpTooManyRequestsException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 429;

    /**
     * @var string
     */
    protected $message = 'Too many requests.';

    protected string $title = '429 Too Many Requests';
    protected string $description = 'The client application has surpassed its rate limit, ' .
                                    'or number of requests they can send in a given period of time.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `429` | HTTP status code `429`. |
| `$message` | `protected string` | `'Too many requests.'` | Default exception message. |
| `$title` | `protected string` | `'429 Too Many Requests'` | Default error title. |
| `$description` | `protected string` | `'The client application has surpassed its rate limit, or number of requests they can send in a given period of time.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\RequestHandlerInterface as RequestHandler;
use Slim\Exception\HttpTooManyRequestsException;

$rateLimitMiddleware = function (Request $request, RequestHandler $handler) use ($limiter) {
    $clientIp = $request->getServerParams()['REMOTE_ADDR'] ?? '127.0.0.1';
    if (!$limiter->allow($clientIp)) {
        throw new HttpTooManyRequestsException($request, 'Rate limit of 100 req/min exceeded.');
    }
    return $handler->handle($request);
};
```

---

## `class` Slim\Exception\HttpInternalServerErrorException

- **Source File**: `Slim/Exception/HttpInternalServerErrorException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `500 Internal Server Error`** when the server encounters an unexpected condition or upstream failure that prevents fulfilling the request.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpInternalServerErrorException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 500;

    /**
     * @var string
     */
    protected $message = 'Internal server error.';

    protected string $title = '500 Internal Server Error';
    protected string $description = 'Unexpected condition encountered preventing server from fulfilling request.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `500` | HTTP status code `500`. |
| `$message` | `protected string` | `'Internal server error.'` | Default exception message. |
| `$title` | `protected string` | `'500 Internal Server Error'` | Default error title. |
| `$description` | `protected string` | `'Unexpected condition encountered preventing server from fulfilling request.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpInternalServerErrorException;

$app->post('/checkout', function (Request $request, Response $response): Response {
    try {
        $this->get(PaymentGateway::class)->charge($request->getParsedBody());
    } catch (\RuntimeException $e) {
        throw new HttpInternalServerErrorException($request, 'Payment settlement failed.', $e);
    }
    return $response->withStatus(200);
});
```

---

## `class` Slim\Exception\HttpNotImplementedException

- **Source File**: `Slim/Exception/HttpNotImplementedException.php`
- **Namespace**: `Slim\Exception`
- **Extends**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

Represents an **HTTP `501 Not Implemented`** server error when the server does not support the capability or protocol feature required to fulfill the request.

### PHP Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Exception;

/** @api */
class HttpNotImplementedException extends HttpSpecializedException
{
    /**
     * @var int
     */
    protected $code = 501;

    /**
     * @var string
     */
    protected $message = 'Not implemented.';

    protected string $title = '501 Not Implemented';
    protected string $description = 'The server does not support the functionality required to fulfill the request.';
}
```

### Properties & Constructor

| Member | Visibility & Type | Default Value / Signature | Description |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `501` | HTTP status code `501`. |
| `$message` | `protected string` | `'Not implemented.'` | Default exception message. |
| `$title` | `protected string` | `'501 Not Implemented'` | Default error title. |
| `$description` | `protected string` | `'The server does not support the functionality required to fulfill the request.'` | Default error description. |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | Inherited from [`HttpSpecializedException`](#slim-exception-httpspecializedexception). |

### Usage Example

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpNotImplementedException;

$app->post('/reports/pdf', function (Request $request, Response $response): Response {
    throw new HttpNotImplementedException($request, 'Direct PDF export is not yet implemented.');
});
```
