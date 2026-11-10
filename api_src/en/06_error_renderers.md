# Error Renderers

The `Slim\Error` and `Slim\Error\Renderers` namespaces define the base [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) and four concrete formatters implementing [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface). Invoked by [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) based on the negotiated `Accept` header (or as the error logger formatter), each renderer serializes a `Throwable` into JSON, HTML, XML, or Plain Text while respecting the `displayErrorDetails` flag.

```drawlib align=center code=fold file=p2_renderers_class_hierarchy.png caption="Slim\Error Class Hierarchy & Default MIME Content-Type Mappings"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=84)

# Top Tier: ErrorRendererInterface
rectangle(
    (90, 73),
    width=78,
    height=13,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text(
    (90, 75.5),
    "<<interface>> Slim\\Interfaces\\ErrorRendererInterface",
    style=Styles.SecondaryBold.patch(text_size=10.5),
)
text(
    (90, 70.0),
    "__invoke(Throwable exception, bool displayErrorDetails): string",
    style=Styles.Dark.patch(text_size=10.0),
)

# Middle Tier: AbstractErrorRenderer
rectangle(
    (90, 48),
    width=92,
    height=18,
    style=Styles.PrimaryFlat.patch(shape_r=2.5),
)
phosphor.brackets_curly((52, 48), width=6.0, style=Styles.White)
text(
    (95, 52.5),
    "abstract Slim\\Error\\AbstractErrorRenderer",
    style=Styles.WhiteBold.patch(text_size=11.5),
)
text(
    (95, 47.0),
    "getErrorTitle(Throwable) | getErrorDescription(Throwable)",
    style=Styles.White.patch(text_size=10.0),
)
text(
    (95, 42.0),
    "Uses HttpException title/description or defaultError* properties",
    style=Styles.White.patch(text_size=10.0),
)

# Bottom Tier: 4 Concrete Renderers
# 1. JsonErrorRenderer
rectangle(
    (25, 16),
    width=38,
    height=20,
    style=Styles.AccentFlat.patch(shape_r=2.0),
)
text((25, 21.5), "JsonErrorRenderer", style=Styles.WhiteBold.patch(text_size=10.5))
text((25, 16.0), "application/json", style=Styles.White.patch(text_size=10.0))
text((25, 10.5), "+json media types", style=Styles.White.patch(text_size=10.0))

# 2. HtmlErrorRenderer
rectangle(
    (68, 16),
    width=38,
    height=20,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((68, 21.5), "HtmlErrorRenderer", style=Styles.PrimaryBold.patch(text_size=10.5))
text((68, 16.0), "text/html", style=Styles.Dark.patch(text_size=10.0))
text((68, 10.5), "(Default HTTP Fallback)", style=Styles.Dark.patch(text_size=10.0))

# 3. XmlErrorRenderer
rectangle(
    (112, 16),
    width=38,
    height=20,
    style=Styles.PrimaryNeutral.patch(shape_r=2.0),
)
text((112, 21.5), "XmlErrorRenderer", style=Styles.PrimaryBold.patch(text_size=10.5))
text((112, 16.0), "application/xml, text/xml", style=Styles.Dark.patch(text_size=10.0))
text((112, 10.5), "+xml media types", style=Styles.Dark.patch(text_size=10.0))

# 4. PlainTextErrorRenderer
rectangle(
    (155, 16),
    width=38,
    height=20,
    style=Styles.SecondaryNeutral.patch(shape_r=2.0),
)
text((155, 21.5), "PlainTextErrorRenderer", style=Styles.SecondaryBold.patch(text_size=10.5))
text((155, 16.0), "text/plain", style=Styles.Dark.patch(text_size=10.0))
text((155, 10.5), "(Default Log Renderer)", style=Styles.Dark.patch(text_size=10.0))

# Connectors
line((90, 57), (90, 66.5), arrow_head="->", style=Styles.SecondaryBold)
line((62, 39), (25, 26), arrow_head="->", style=Styles.AccentBold)
line((80, 39), (68, 26), arrow_head="->", style=Styles.PrimaryBold)
line((100, 39), (112, 26), arrow_head="->", style=Styles.PrimaryBold)
line((118, 39), (155, 26), arrow_head="->", style=Styles.SecondaryBold)

save()
```

---

## Summary of Error Renderers

| Class | Namespace | Registered MIME Types | Exception Chain (`getPrevious()`) | Primary Output Structure |
| :--- | :--- | :--- | :--- | :--- |
| [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) | `Slim\Error` | *(Abstract Base)* | N/A | Resolves `HttpException` title/description or default error strings. |
| [`JsonErrorRenderer`](#slim-error-renderers-jsonerrorrenderer) | `Slim\Error\Renderers` | `application/json`, `*+json` | Yes (`do ... while`) | Pretty-printed JSON object with `message` and optional `exception` array. |
| [`HtmlErrorRenderer`](#slim-error-renderers-htmlerrorrenderer) | `Slim\Error\Renderers` | `text/html` *(Default HTTP)* | Primary `Throwable` only | Complete HTML5 page (`<!doctype html>`) with inline styles and stack trace. |
| [`XmlErrorRenderer`](#slim-error-renderers-xmlerrorrenderer) | `Slim\Error\Renderers` | `application/xml`, `text/xml`, `*+xml` | Yes (`do ... while`) | UTF-8 XML document with `<error>`, `<message>` CDATA, and `<exception>` nodes. |
| [`PlainTextErrorRenderer`](#slim-error-renderers-plaintexterrorrenderer) | `Slim\Error\Renderers` | `text/plain` *(Default Logger)* | Yes (`while`) | Multi-line text with title, `Type`/`Code`/`Message`/`File`/`Line`/`Trace`, and `Previous Error:` blocks. |

```drawlib align=center code=fold file=p2_renderers_payload_flow.png caption="Error Renderer Output Modes: Production (displayErrorDetails = false) vs Debug (displayErrorDetails = true)"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
from drawlib.text import text

setup(width=180, height=76)

# Input node
rectangle(
    (25, 38),
    width=36,
    height=32,
    style=Styles.PrimaryFlat.patch(shape_r=2.5),
)
phosphor.shield_warning((25, 47.0), width=6.5, style=Styles.White)
text((25, 39.0), "Throwable Input", style=Styles.WhiteBold.patch(text_size=11.0))
text((25, 33.0), "HttpException or", style=Styles.White.patch(text_size=10.0))
text((25, 27.5), "Uncaught Error", style=Styles.White.patch(text_size=10.0))

# Top Branch: displayErrorDetails = false
rectangle(
    (116, 56),
    width=110,
    height=24,
    style=Styles.Neutral.patch(shape_r=2.5),
)
text(
    (116, 63.5),
    "Production Mode: displayErrorDetails = false",
    style=Styles.PrimaryBold.patch(text_size=11.5),
)
text(
    (116, 56.5),
    "JSON / XML / Text: Outputs getErrorTitle(exception) only (no stack trace or file paths)",
    style=Styles.Dark.patch(text_size=10.0),
)
text(
    (116, 50.0),
    "HTML: Renders <h1>getErrorTitle()</h1> and <p>getErrorDescription()</p>",
    style=Styles.Dark.patch(text_size=10.0),
)

# Bottom Branch: displayErrorDetails = true
rectangle(
    (116, 20),
    width=110,
    height=26,
    style=Styles.AccentFlat.patch(shape_r=2.5),
)
text(
    (116, 28.5),
    "Diagnostic Mode: displayErrorDetails = true",
    style=Styles.WhiteBold.patch(text_size=11.5),
)
text(
    (116, 21.5),
    "JSON & XML: Appends exception[] / <exception> chain (type, code, message, file, line)",
    style=Styles.White.patch(text_size=10.0),
)
text(
    (116, 15.0),
    "PlainText & HTML: Includes full Trace string (PlainText also walks getPrevious() chain)",
    style=Styles.White.patch(text_size=10.0),
)

# Connectors
line((43, 45), (61, 56), arrow_head="->", style=Styles.PrimaryBold)
line((43, 31), (61, 20), arrow_head="->", style=Styles.AccentBold)

save()
```

---

## `class` Slim\Error\AbstractErrorRenderer

- **Source**: `Slim/Error/AbstractErrorRenderer.php`
- **Namespace**: `Slim\Error`
- **Implements**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`AbstractErrorRenderer` is the abstract base class extended by all built-in Slim error renderers. It provides default fallback title and description strings for generic `Throwable` instances, while automatically extracting specialized status titles and descriptions when the caught exception is an instance of [`HttpException`](07_exceptions.md#slim-exception-httpexception).

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Error;

use Slim\Exception\HttpException;
use Slim\Interfaces\ErrorRendererInterface;
use Throwable;

abstract class AbstractErrorRenderer implements ErrorRendererInterface
{
    protected string $defaultErrorTitle = 'Slim Application Error';

    protected string $defaultErrorDescription = 'A website error has occurred. Sorry for the temporary inconvenience.';

    protected function getErrorTitle(Throwable $exception): string;

    protected function getErrorDescription(Throwable $exception): string;
}
```

### Properties

| Property | Visibility | Type | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `$defaultErrorTitle` | `protected` | `string` | `'Slim Application Error'` | Fallback error title returned by `getErrorTitle()` when `$exception` is not an [`HttpException`](07_exceptions.md#slim-exception-httpexception). |
| `$defaultErrorDescription` | `protected` | `string` | `'A website error has occurred. Sorry for the temporary inconvenience.'` | Fallback error description returned by `getErrorDescription()` when `$exception` is not an [`HttpException`](07_exceptions.md#slim-exception-httpexception). |

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Abstract contract inherited from [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface); implemented by concrete subclasses. |
| `getErrorTitle` | `Throwable $exception` | `string` | Protected. Returns `$exception->getTitle()` if `$exception instanceof HttpException`, otherwise returns `$this->defaultErrorTitle`. |
| `getErrorDescription` | `Throwable $exception` | `string` | Protected. Returns `$exception->getDescription()` if `$exception instanceof HttpException`, otherwise returns `$this->defaultErrorDescription`. |

### Usage Example

```php
<?php

use Slim\Error\AbstractErrorRenderer;
use Slim\Factory\AppFactory;
use Throwable;

class CustomProblemJsonRenderer extends AbstractErrorRenderer
{
    protected string $defaultErrorTitle = 'Internal Server Error';
    protected string $defaultErrorDescription = 'An unexpected server error occurred.';

    public function __invoke(Throwable $exception, bool $displayErrorDetails): string
    {
        $payload = [
            'title' => $this->getErrorTitle($exception),
            'detail' => $displayErrorDetails
                ? $exception->getMessage()
                : $this->getErrorDescription($exception),
        ];

        return (string) json_encode($payload, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    }
}

$app = AppFactory::create();
$errorMiddleware = $app->addErrorMiddleware(false, true, true);
$errorMiddleware->getDefaultErrorHandler()->registerErrorRenderer(
    'application/problem+json',
    CustomProblemJsonRenderer::class
);
```

---

## `class` Slim\Error\Renderers\JsonErrorRenderer

- **Source**: `Slim/Error/Renderers/JsonErrorRenderer.php`
- **Namespace**: `Slim\Error\Renderers`
- **Extends**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **Implements**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`JsonErrorRenderer` formats uncaught exceptions into a pretty-printed JSON object (`JSON_INVALID_UTF8_SUBSTITUTE | JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES`). In [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), it is registered for `'application/json'` as well as any vendor media type matching `/\+json/` (such as `'application/problem+json'` or `'application/vnd.api+json'`).

When `$displayErrorDetails` is `false`, the JSON payload contains only `{"message": "<ErrorTitle>"}`. When `$displayErrorDetails` is `true`, an `"exception"` array is appended containing the primary exception and every chained `$exception->getPrevious()` entry.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Error\Renderers;

use Slim\Error\AbstractErrorRenderer;
use Throwable;

class JsonErrorRenderer extends AbstractErrorRenderer
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string;

    /**
     * @return array<string|int>
     */
    private function formatExceptionFragment(Throwable $exception): array;
}
```

### Properties

Inherits `$defaultErrorTitle` and `$defaultErrorDescription` from [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer).

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Builds `['message' => $this->getErrorTitle($exception)]`, appends `['exception' => [...]]` across the `getPrevious()` chain when `$displayErrorDetails` is `true`, and encodes to JSON. |
| `formatExceptionFragment` | `Throwable $exception` | `array<string, string\|int>` | Private helper returning `['type' => get_class($exception), 'code' => $code, 'message' => $exception->getMessage(), 'file' => $exception->getFile(), 'line' => $exception->getLine()]`. |

### Usage Example

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\JsonErrorRenderer;

$renderer = new JsonErrorRenderer();
$exception = new RuntimeException('Database connection timed out', 1045);

// 1. Production output ($displayErrorDetails = false):
// {
//     "message": "Slim Application Error"
// }
$prodJson = $renderer($exception, false);

// 2. Detailed output ($displayErrorDetails = true):
// {
//     "message": "Slim Application Error",
//     "exception": [
//         {
//             "type": "RuntimeException",
//             "code": 1045,
//             "message": "Database connection timed out",
//             "file": "/app/src/Database.php",
//             "line": 42
//         }
//     ]
// }
$debugJson = $renderer($exception, true);
```

---

## `class` Slim\Error\Renderers\HtmlErrorRenderer

- **Source**: `Slim/Error/Renderers/HtmlErrorRenderer.php`
- **Namespace**: `Slim\Error\Renderers`
- **Extends**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **Implements**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`HtmlErrorRenderer` is Slim's default HTTP error renderer (`$defaultErrorRenderer = HtmlErrorRenderer::class`), registered for `'text/html'`. It outputs a standalone HTML5 document with minimal inline CSS and a `Go Back` history link (`onclick="window.history.go(-1)"`).

When `$displayErrorDetails` is `false`, it escapes `getErrorDescription($exception)` with `htmlspecialchars(..., ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')` inside a `<p>` tag. When `$displayErrorDetails` is `true`, it renders a `<h2>Details</h2>` section (`Type`, `Code`, `Message`, `File`, `Line`) followed by `<h2>Trace</h2><pre>...</pre>` for the caught `$exception`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Error\Renderers;

use Slim\Error\AbstractErrorRenderer;
use Throwable;

class HtmlErrorRenderer extends AbstractErrorRenderer
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string;

    public function renderHtmlBody(string $title = '', string $html = ''): string;

    private function renderExceptionFragment(Throwable $exception): string;
}
```

### Properties

Inherits `$defaultErrorTitle` and `$defaultErrorDescription` from [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer).

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Builds the inner HTML body (either detailed exception metadata + stack trace or escaped error description) and wraps it via `renderHtmlBody()`. |
| `renderHtmlBody` | `string $title = ''`, `string $html = ''` | `string` | Public helper that escapes `$title` and returns a complete `<!doctype html><html lang="en">...</html>` document containing `<h1>{$title}</h1>`, `<div>{$html}</div>`, and a `Go Back` link. |
| `renderExceptionFragment` | `Throwable $exception` | `string` | Private helper formatting `Type`, `Code`, HTML-encoded `Message`, `File`, `Line`, and `<pre>` stack trace for `$exception`. |

### Usage Example

```php
<?php

use Slim\Error\Renderers\HtmlErrorRenderer;
use Slim\Exception\HttpNotFoundException;
use Slim\Factory\AppFactory;

$app = AppFactory::create();
$renderer = new HtmlErrorRenderer();

// Render a custom HTML error page using renderHtmlBody() directly
$customHtml = $renderer->renderHtmlBody(
    '404 Not Found',
    '<p>The requested resource could not be located on this server.</p>'
);
```

---

## `class` Slim\Error\Renderers\XmlErrorRenderer

- **Source**: `Slim/Error/Renderers/XmlErrorRenderer.php`
- **Namespace**: `Slim\Error\Renderers`
- **Extends**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **Implements**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`XmlErrorRenderer` serializes exceptions into a UTF-8 XML document (`<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`) rooted at `<error>`. In [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), it is registered for both `'application/xml'` and `'text/xml'`, and also matches vendor media types ending in `+xml` via `/\+(json|xml)/`.

Text fields (`<message>`) are wrapped in CDATA sections via `createCdataSection()`, which safely splits any embedded `]]>` sequence into `]]]]><![CDATA[>`. When `$displayErrorDetails` is `true`, it iterates through `$exception` and all `$exception->getPrevious()` causes, emitting an `<exception>` block for each.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Error\Renderers;

use Slim\Error\AbstractErrorRenderer;
use Throwable;

class XmlErrorRenderer extends AbstractErrorRenderer
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string;

    private function createCdataSection(string $content): string;
}
```

### Properties

Inherits `$defaultErrorTitle` and `$defaultErrorDescription` from [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer).

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Generates an XML `<error>` payload with a `<message>` CDATA element and, when `$displayErrorDetails` is `true`, one `<exception>` element per chained `Throwable`. |
| `createCdataSection` | `string $content` | `string` | Private helper that wraps `$content` in `<![CDATA[...]]>` after escaping `]]>` sequences. |

### Usage Example

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\XmlErrorRenderer;

$renderer = new XmlErrorRenderer();
$xml = $renderer(new RuntimeException('Invalid XML payload', 422), true);

/*
Outputs:
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<error>
  <message><![CDATA[Slim Application Error]]></message>
  <exception>
    <type>RuntimeException</type>
    <code>422</code>
    <message><![CDATA[Invalid XML payload]]></message>
    <file>/app/index.php</file>
    <line>18</line>
  </exception>
</error>
*/
```

---

## `class` Slim\Error\Renderers\PlainTextErrorRenderer

- **Source**: `Slim/Error/Renderers/PlainTextErrorRenderer.php`
- **Namespace**: `Slim\Error\Renderers`
- **Extends**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **Implements**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`PlainTextErrorRenderer` formats exceptions as human-readable plain text. It serves a dual role in [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler):
1. Registered in `$errorRenderers['text/plain']` for HTTP clients requesting `Accept: text/plain`.
2. Configured as the default `$logErrorRenderer` used by `ErrorHandler::writeToErrorLog()` to format entries sent to PSR-3 [`LoggerInterface`](01_app_and_factories.md#slim-logger).

When `$displayErrorDetails` (or `$logErrorDetails` for logging) is `true`, it outputs `Type`, `Code`, `Message`, `File`, `Line`, and `Trace` for the primary exception, followed by `Previous Error:` sections for every chained `$exception->getPrevious()`.

### Class Signature

```php
<?php

declare(strict_types=1);

namespace Slim\Error\Renderers;

use Slim\Error\AbstractErrorRenderer;
use Throwable;

class PlainTextErrorRenderer extends AbstractErrorRenderer
{
    public function __invoke(Throwable $exception, bool $displayErrorDetails): string;

    private function formatExceptionFragment(Throwable $exception): string;
}
```

### Properties

Inherits `$defaultErrorTitle` and `$defaultErrorDescription` from [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer).

### Methods & Parameters

| Method | Parameters & Types | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | Returns `"{$this->getErrorTitle($exception)}\n"`, appending `formatExceptionFragment()` for `$exception` and each `$exception->getPrevious()` when `$displayErrorDetails` is `true`. |
| `formatExceptionFragment` | `Throwable $exception` | `string` | Private helper formatting `Type:`, `Code:`, `Message:`, `File:`, `Line:`, and `Trace:` lines for a single `Throwable`. |

### Usage Example

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\PlainTextErrorRenderer;
use Slim\Factory\AppFactory;

$app = AppFactory::create();

// Use PlainTextErrorRenderer explicitly or customize error logging
$errorMiddleware = $app->addErrorMiddleware(false, true, true);
$errorHandler = $errorMiddleware->getDefaultErrorHandler();
$errorHandler->setLogErrorRenderer(PlainTextErrorRenderer::class);

$renderer = new PlainTextErrorRenderer();
$logEntry = $renderer(new RuntimeException('Cache backend unreachable', 503), true);
```
