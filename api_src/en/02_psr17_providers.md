# PSR-17 Factory Auto-Discovery & Providers

Reference for all 10 classes in `Slim\Factory\Psr17\*`: [`Psr17FactoryProvider`](#slim-factory-psr17-psr17factoryprovider), [`Psr17Factory`](#slim-factory-psr17-psr17factory), [`ServerRequestCreator`](#slim-factory-psr17-serverrequestcreator), [`SlimHttpServerRequestCreator`](#slim-factory-psr17-slimhttpserverrequestcreator), [`SlimPsr17Factory`](#slim-factory-psr17-slimpsr17factory), [`SlimHttpPsr17Factory`](#slim-factory-psr17-slimhttppsr17factory), [`NyholmPsr17Factory`](#slim-factory-psr17-nyholmpsr17factory), [`GuzzlePsr17Factory`](#slim-factory-psr17-guzzlepsr17factory), [`LaminasDiactorosPsr17Factory`](#slim-factory-psr17-laminasdiactorospsr17factory), and [`HttpSoftPsr17Factory`](#slim-factory-psr17-httpsoftpsr17factory).

```drawlib align=center code=fold file=psr17_class_hierarchy.png caption="Slim\\Factory\\Psr17\\* — Class Hierarchy, Provider Registry & Decorator Architecture (10 Classes)"
from drawlib.canvas import save, setup
from drawlib.diagrams.architecture import ArchitectureDiagram, Node, NodeGroup, PhosphorIcon
from drawlib.styles import Styles

setup(width=162, height=78)

d = ArchitectureDiagram(
    node_style=Styles.Dark,
    node_text_style=Styles.DarkBold.patch(text_size=10.0),
    edge_style=Styles.Dark.patch(line_width=1.4),
    edge_text_style=Styles.Muted.patch(text_size=9.5),
    node_card_style=Styles.Neutral,
)

reg_grp = d.add(
    NodeGroup(
        "1. Registry & Base Adapter",
        width=41,
        height=68,
        style=Styles.PrimaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.5, halign="left", valign="top"),
    ),
    xy=(4, 5),
)
provider = reg_grp.add(
    Node(
        "Psr17FactoryProvider\n(Priority List [5])",
        icon=PhosphorIcon.LIST_NUMBERS,
        width=34,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(20.5, 46),
)
base_fac = reg_grp.add(
    Node(
        "Psr17Factory\n(abstract base)",
        icon=PhosphorIcon.CUBE,
        width=34,
        height=17,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.2),
        card_style=Styles.PrimaryFlat,
    ),
    xy=(20.5, 18),
)

sub_grp = d.add(
    NodeGroup(
        "2. Concrete Vendor Adapters (6)",
        width=64,
        height=68,
        style=Styles.SecondaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.5, halign="left", valign="top"),
    ),
    xy=(51, 5),
)
f_slim = sub_grp.add(
    Node("1. SlimPsr17Factory\n(slim/psr7)", width=28, height=14, card_style=Styles.Neutral),
    xy=(16, 50),
)
f_httpsoft = sub_grp.add(
    Node("2. HttpSoftPsr17Factory\n(httpsoft/*)", width=28, height=14, card_style=Styles.Neutral),
    xy=(48, 50),
)
f_nyholm = sub_grp.add(
    Node("3. NyholmPsr17Factory\n(nyholm/psr7*)", width=28, height=14, card_style=Styles.Neutral),
    xy=(16, 31),
)
f_laminas = sub_grp.add(
    Node("4. LaminasDiactoros\n(laminas-diactoros)", width=28, height=14, card_style=Styles.Neutral),
    xy=(48, 31),
)
f_guzzle = sub_grp.add(
    Node("5. GuzzlePsr17Factory\n(guzzlehttp/psr7)", width=28, height=14, card_style=Styles.Neutral),
    xy=(16, 12),
)
f_slimhttp = sub_grp.add(
    Node("SlimHttpPsr17Factory\n(slim/http Decorator)", width=28, height=14, card_style=Styles.PrimaryNeutral),
    xy=(48, 12),
)

req_grp = d.add(
    NodeGroup(
        "3. Request Creators",
        width=34,
        height=68,
        style=Styles.Neutral,
        text_style=Styles.DarkBold.patch(text_size=10.5, halign="left", valign="top"),
    ),
    xy=(124, 5),
)
req_creator = req_grp.add(
    Node(
        "ServerRequestCreator\n(Closure::fromCallable)",
        icon=PhosphorIcon.GLOBE,
        width=28,
        height=18,
        card_style=Styles.Neutral,
    ),
    xy=(17, 46),
)
req_dec = req_grp.add(
    Node(
        "SlimHttpServer\nRequestCreator",
        icon=PhosphorIcon.SHIELD_CHECK,
        width=28,
        height=18,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.0),
        card_style=Styles.AccentFlat,
    ),
    xy=(17, 18),
)

provider.connect(base_fac, label="iterates")
base_fac.connect(f_nyholm, label="extends")
f_httpsoft.connect(req_creator, label="creates")
req_creator.connect(req_dec, label="decorates")

d.draw(xy=(0, 0))
save()
```

---

## PSR-17 Auto-Discovery Priority & Vendor Mapping Matrix

When [`AppFactory::determineResponseFactory()`](01_app_and_factories.md#slim-factory-appfactory) or [`ServerRequestCreatorFactory::determineServerRequestCreator()`](01_app_and_factories.md#slim-factory-serverrequestcreatorfactory) runs without an explicit factory, it iterates `Psr17FactoryProvider::getFactories()` in order and picks the **first** provider whose vendor classes exist in the autoloader:

```drawlib align=center code=fold file=psr17_discovery_priority_pipeline.png caption="PSR-17 Auto-Discovery Order & Vendor Class Configuration Matrix"
from drawlib.canvas import save, setup
from drawlib.smartarts import ChevronProcess, Table
from drawlib.styles import Styles

setup(width=164, height=62)

proc = ChevronProcess(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    corner_angle=60.0,
    spacing=1.5,
    flat_left_end=True,
)
proc.add(
    "1. SlimPsr17",
    description="slim/psr7\n(Priority #1)",
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.2),
    description_style=Styles.White.patch(text_size=9.5),
)
proc.add("2. HttpSoft", description="httpsoft/*\n(Priority #2)", style=Styles.PrimaryNeutral)
proc.add("3. Nyholm", description="nyholm/psr7*\n(Priority #3)", style=Styles.SecondaryNeutral)
proc.add("4. Laminas", description="diactoros\n(Priority #4)", style=Styles.Neutral)
proc.add("5. Guzzle", description="guzzlehttp/psr7\n(Priority #5)", style=Styles.Neutral)
proc.draw(xy=(4, 45), width=156, height=13)

tbl = Table(
    cell_style=Styles.White,
    text_style=Styles.Dark.patch(text_size=10.0),
    header_cell_style=Styles.PrimaryFlat,
    header_text_style=Styles.WhiteBold.patch(text_size=10.2),
    border_style=Styles.MutedThin,
)
tbl.draw_flexible(
    xy=(4, 41),
    column_widths=[36, 42, 52, 26],
    row_heights=[6, 6, 6, 6, 6, 6],
    data=[
        ["Provider Class", "responseFactoryClass", "serverRequestCreatorClass", "Creator Method"],
        ["SlimPsr17Factory", "Slim\\Psr7\\Factory\\ResponseFactory", "Slim\\Psr7\\Factory\\ServerRequestFactory", "createFromGlobals"],
        ["HttpSoftPsr17Factory", "HttpSoft\\Message\\ResponseFactory", "HttpSoft\\ServerRequest\\ServerRequestCreator", "createFromGlobals"],
        ["NyholmPsr17Factory", "Nyholm\\Psr7\\Factory\\Psr17Factory", "Nyholm\\Psr7Server\\ServerRequestCreator", "fromGlobals"],
        ["LaminasDiactorosPsr17Factory", "Laminas\\Diactoros\\ResponseFactory", "Laminas\\Diactoros\\ServerRequestFactory", "fromGlobals"],
        ["GuzzlePsr17Factory", "GuzzleHttp\\Psr7\\HttpFactory", "GuzzleHttp\\Psr7\\ServerRequest", "fromGlobals"],
    ],
)

save()
```

---

## `class` Slim\Factory\Psr17\Psr17FactoryProvider

- **Source File**: `Slim/Factory/Psr17/Psr17FactoryProvider.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Implements**: [`Slim\Interfaces\Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface)

`Psr17FactoryProvider` maintains the ordered static list of [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) class names probed during automatic PSR-17 factory discovery. Calling `addFactory()` prepends a custom factory class to the front of `static::$factories` via `array_unshift()`, giving it highest priority over the 5 built-in providers.

### PHP Class Signature (`Slim\Factory\Psr17\Psr17FactoryProvider`)

```php
namespace Slim\Factory\Psr17;

use Slim\Interfaces\Psr17FactoryProviderInterface;

class Psr17FactoryProvider implements Psr17FactoryProviderInterface
{
    /**
     * @var string[]
     */
    protected static array $factories = [
        SlimPsr17Factory::class,
        HttpSoftPsr17Factory::class,
        NyholmPsr17Factory::class,
        LaminasDiactorosPsr17Factory::class,
        GuzzlePsr17Factory::class,
    ];

    public static function getFactories(): array;
    public static function setFactories(array $factories): void;
    public static function addFactory(string $factory): void;
}
```

### Static Properties & Methods (`Slim\Factory\Psr17\Psr17FactoryProvider`)

| Member / Method | Parameters / Type | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `$factories` | `protected static string[]` | `string[]` | Ordered list of `Psr17Factory` class names (`SlimPsr17Factory`, `HttpSoftPsr17Factory`, `NyholmPsr17Factory`, `LaminasDiactorosPsr17Factory`, `GuzzlePsr17Factory`). |
| `getFactories()` | *(none)* | `string[]` | Returns the current array of registered `Psr17FactoryInterface` class names. |
| `setFactories($factories)` | `string[] $factories` | `void` | Replaces the entire `$factories` array with a custom priority order. |
| `addFactory($factory)` | `string $factory` | `void` | Prepends `$factory` to the beginning of `static::$factories` (`array_unshift()`), giving it top discovery priority. |

### Usage Example (`Slim\Factory\Psr17\Psr17FactoryProvider`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\AppFactory;
use Slim\Factory\Psr17\NyholmPsr17Factory;
use Slim\Factory\Psr17\Psr17FactoryProvider;

// Force NyholmPsr17Factory to be checked first (or exclusively)
Psr17FactoryProvider::setFactories([NyholmPsr17Factory::class]);

$app = AppFactory::create();
```

---

## `class` Slim\Factory\Psr17\Psr17Factory

- **Source File**: `Slim/Factory/Psr17/Psr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Modifiers**: `abstract class`
- **Implements**: [`Slim\Interfaces\Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface)

`Psr17Factory` is the abstract template class inherited by all 6 vendor-specific PSR-17 factory adapters. Concrete subclasses need only declare four protected static strings (`$responseFactoryClass`, `$streamFactoryClass`, `$serverRequestCreatorClass`, `$serverRequestCreatorMethod`); `Psr17Factory` provides the shared `class_exists()` availability checks and factory instantiation logic.

### PHP Class Signature (`Slim\Factory\Psr17\Psr17Factory`)

```php
namespace Slim\Factory\Psr17;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\StreamFactoryInterface;
use RuntimeException;
use Slim\Interfaces\Psr17FactoryInterface;
use Slim\Interfaces\ServerRequestCreatorInterface;

abstract class Psr17Factory implements Psr17FactoryInterface
{
    protected static string $responseFactoryClass;
    protected static string $streamFactoryClass;
    protected static string $serverRequestCreatorClass;
    protected static string $serverRequestCreatorMethod;

    public static function getResponseFactory(): ResponseFactoryInterface;
    public static function getStreamFactory(): StreamFactoryInterface;
    public static function getServerRequestCreator(): ServerRequestCreatorInterface;
    public static function isResponseFactoryAvailable(): bool;
    public static function isStreamFactoryAvailable(): bool;
    public static function isServerRequestCreatorAvailable(): bool;
}
```

### Static Properties & Methods (`Slim\Factory\Psr17\Psr17Factory`)

| Member / Method | Parameters / Type | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `$responseFactoryClass` | `protected static string` | `string` | Fully-qualified vendor class name implementing `Psr\Http\Message\ResponseFactoryInterface`. |
| `$streamFactoryClass` | `protected static string` | `string` | Fully-qualified vendor class name implementing `Psr\Http\Message\StreamFactoryInterface`. |
| `$serverRequestCreatorClass` | `protected static string` | `string` | Fully-qualified vendor class name providing global request creation. |
| `$serverRequestCreatorMethod` | `protected static string` | `string` | Method name on `$serverRequestCreatorClass` (e.g. `'createFromGlobals'` or `'fromGlobals'`). |
| `getResponseFactory()` | *(none)* | `ResponseFactoryInterface` | Instantiates `new static::$responseFactoryClass()` after verifying `isResponseFactoryAvailable()` and `instanceof ResponseFactoryInterface`. Throws `RuntimeException` on failure. |
| `getStreamFactory()` | *(none)* | `StreamFactoryInterface` | Instantiates `new static::$streamFactoryClass()` after verifying `isStreamFactoryAvailable()` and `instanceof StreamFactoryInterface`. Throws `RuntimeException` on failure. |
| `getServerRequestCreator()` | *(none)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Returns `new ServerRequestCreator(static::$serverRequestCreatorClass, static::$serverRequestCreatorMethod)`. Throws `RuntimeException` if unavailable. |
| `isResponseFactoryAvailable()` | *(none)* | `bool` | Returns `true` when `static::$responseFactoryClass` is non-empty and `class_exists()` succeeds. |
| `isStreamFactoryAvailable()` | *(none)* | `bool` | Returns `true` when `static::$streamFactoryClass` is non-empty and `class_exists()` succeeds. |
| `isServerRequestCreatorAvailable()` | *(none)* | `bool` | Returns `true` when both `static::$serverRequestCreatorClass` and `static::$serverRequestCreatorMethod` are non-empty and `class_exists()` succeeds. |

---

## `class` Slim\Factory\Psr17\ServerRequestCreator

- **Source File**: `Slim/Factory/Psr17/ServerRequestCreator.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Implements**: [`Slim\Interfaces\ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface)

`ServerRequestCreator` adapts third-party static or instance factory methods (such as `Slim\Psr7\Factory\ServerRequestFactory::createFromGlobals()` or `Nyholm\Psr7Server\ServerRequestCreator::fromGlobals()`) to Slim's uniform [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) contract using `Closure::fromCallable([$this->serverRequestCreator, $this->serverRequestCreatorMethod])()`.

### PHP Class Signature (`Slim\Factory\Psr17\ServerRequestCreator`)

```php
namespace Slim\Factory\Psr17;

use Psr\Http\Message\ServerRequestInterface;
use Slim\Interfaces\ServerRequestCreatorInterface;

class ServerRequestCreator implements ServerRequestCreatorInterface
{
    /**
     * @var object|string
     */
    protected $serverRequestCreator;

    protected string $serverRequestCreatorMethod;

    /**
     * @param object|string $serverRequestCreator
     */
    public function __construct($serverRequestCreator, string $serverRequestCreatorMethod);

    public function createServerRequestFromGlobals(): ServerRequestInterface;
}
```

### Constructor & Methods (`Slim\Factory\Psr17\ServerRequestCreator`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct(...)` | `object\|string $serverRequestCreator`, `string $serverRequestCreatorMethod` | `void` | Stores the target class name (for static methods) or object instance (used by `NyholmPsr17Factory`) and the method name to invoke. |
| `createServerRequestFromGlobals()` | *(none)* | `ServerRequestInterface` | Wraps `[$this->serverRequestCreator, $this->serverRequestCreatorMethod]` via `Closure::fromCallable()` and invokes it with zero arguments to produce a `ServerRequestInterface`. |

### Usage Example (`Slim\Factory\Psr17\ServerRequestCreator`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\Psr17\ServerRequestCreator;
use Slim\Psr7\Factory\ServerRequestFactory;

$creator = new ServerRequestCreator(ServerRequestFactory::class, 'createFromGlobals');
$request = $creator->createServerRequestFromGlobals();
```

---

## `class` Slim\Factory\Psr17\SlimHttpServerRequestCreator

- **Source File**: `Slim/Factory/Psr17/SlimHttpServerRequestCreator.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Implements**: [`Slim\Interfaces\ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface)

`SlimHttpServerRequestCreator` is a Decorator around any [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) that wraps the resulting PSR-7 `ServerRequestInterface` inside `Slim\Http\ServerRequest` (from the optional `slim/http` package), adding helper methods such as `$request->getParam()`, `$request->getQueryParam()`, and `$request->isXhr()`.

### PHP Class Signature (`Slim\Factory\Psr17\SlimHttpServerRequestCreator`)

```php
namespace Slim\Factory\Psr17;

use Psr\Http\Message\ServerRequestInterface;
use RuntimeException;
use Slim\Interfaces\ServerRequestCreatorInterface;

class SlimHttpServerRequestCreator implements ServerRequestCreatorInterface
{
    protected ServerRequestCreatorInterface $serverRequestCreator;
    protected static string $serverRequestDecoratorClass = 'Slim\Http\ServerRequest';

    public function __construct(ServerRequestCreatorInterface $serverRequestCreator);
    public function createServerRequestFromGlobals(): ServerRequestInterface;
    public static function isServerRequestDecoratorAvailable(): bool;
}
```

### Constructor & Methods (`Slim\Factory\Psr17\SlimHttpServerRequestCreator`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `__construct($serverRequestCreator)` | `ServerRequestCreatorInterface $serverRequestCreator` | `void` | Stores the inner `ServerRequestCreatorInterface` to decorate. |
| `createServerRequestFromGlobals()` | *(none)* | `ServerRequestInterface` | Verifies `isServerRequestDecoratorAvailable()`, calls `$this->serverRequestCreator->createServerRequestFromGlobals()`, and wraps the result in `new static::$serverRequestDecoratorClass($request)`. Throws `RuntimeException` if unavailable or invalid. |
| `isServerRequestDecoratorAvailable()` | *(none)* | `bool` | Returns `class_exists('Slim\Http\ServerRequest')`. |

---

## `class` Slim\Factory\Psr17\SlimPsr17Factory

- **Source File**: `Slim/Factory/Psr17/SlimPsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Package**: `slim/psr7` (`^1.6`) — **Discovery Priority #1**

`SlimPsr17Factory` is the highest-priority PSR-17 adapter in `Psr17FactoryProvider`, binding Slim to the official `slim/psr7` package.

### PHP Class Signature (`Slim\Factory\Psr17\SlimPsr17Factory`)

```php
namespace Slim\Factory\Psr17;

class SlimPsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'Slim\Psr7\Factory\ResponseFactory';
    protected static string $streamFactoryClass = 'Slim\Psr7\Factory\StreamFactory';
    protected static string $serverRequestCreatorClass = 'Slim\Psr7\Factory\ServerRequestFactory';
    protected static string $serverRequestCreatorMethod = 'createFromGlobals';
}
```

### Usage Example (`Slim\Factory\Psr17\SlimPsr17Factory`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\Psr17\SlimPsr17Factory;

if (SlimPsr17Factory::isResponseFactoryAvailable()) {
    $responseFactory = SlimPsr17Factory::getResponseFactory();
    $streamFactory = SlimPsr17Factory::getStreamFactory();
    $request = SlimPsr17Factory::getServerRequestCreator()->createServerRequestFromGlobals();
}
```

---

## `class` Slim\Factory\Psr17\SlimHttpPsr17Factory

- **Source File**: `Slim/Factory/Psr17/SlimHttpPsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Package**: `slim/http` (`^1.3`)

`SlimHttpPsr17Factory` is a specialized decorator factory invoked by [`AppFactory::attemptResponseFactoryDecoration()`](01_app_and_factories.md#slim-factory-appfactory). Unlike the 5 base PSR-17 providers, `slim/http` does not provide a standalone PSR-7 implementation; instead, `createDecoratedResponseFactory()` wraps any base `ResponseFactoryInterface` and `StreamFactoryInterface` inside `Slim\Http\Factory\DecoratedResponseFactory` so responses expose convenience helpers like `$response->withJson()`, `$response->withRedirect()`, and `$response->write()`.

### PHP Class Signature (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

```php
namespace Slim\Factory\Psr17;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\StreamFactoryInterface;
use RuntimeException;

class SlimHttpPsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'Slim\Http\Factory\DecoratedResponseFactory';

    /**
     * @throws RuntimeException when the factory could not be instantiated
     */
    public static function createDecoratedResponseFactory(
        ResponseFactoryInterface $responseFactory,
        StreamFactoryInterface $streamFactory
    ): ResponseFactoryInterface;
}
```

### Static Methods (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `createDecoratedResponseFactory(...)` | `ResponseFactoryInterface $responseFactory`, `StreamFactoryInterface $streamFactory` | `ResponseFactoryInterface` | Instantiates `new Slim\Http\Factory\DecoratedResponseFactory($responseFactory, $streamFactory)` and verifies `instanceof ResponseFactoryInterface` (throwing `RuntimeException` on failure). |

### Usage Example (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\Psr17\SlimHttpPsr17Factory;
use Slim\Factory\Psr17\SlimPsr17Factory;

$decoratedFactory = SlimHttpPsr17Factory::createDecoratedResponseFactory(
    SlimPsr17Factory::getResponseFactory(),
    SlimPsr17Factory::getStreamFactory()
);
```

---

## `class` Slim\Factory\Psr17\NyholmPsr17Factory

- **Source File**: `Slim/Factory/Psr17/NyholmPsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Packages**: `nyholm/psr7` (`^1.8`) and `nyholm/psr7-server` (`^1.1`) — **Discovery Priority #3**

`NyholmPsr17Factory` integrates Nyholm's high-performance PSR-7/PSR-17 implementation. Because `Nyholm\Psr7\Factory\Psr17Factory` implements all four PSR-17 factory interfaces (`ServerRequestFactoryInterface`, `UriFactoryInterface`, `UploadedFileFactoryInterface`, `StreamFactoryInterface`) in a single unified class, `NyholmPsr17Factory::getServerRequestCreator()` overrides the parent method to pass a single `$psr17Factory` instance four times into `new Nyholm\Psr7Server\ServerRequestCreator($psr17Factory, $psr17Factory, $psr17Factory, $psr17Factory)`.

### PHP Class Signature (`Slim\Factory\Psr17\NyholmPsr17Factory`)

```php
namespace Slim\Factory\Psr17;

use Slim\Interfaces\ServerRequestCreatorInterface;

class NyholmPsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'Nyholm\Psr7\Factory\Psr17Factory';
    protected static string $streamFactoryClass = 'Nyholm\Psr7\Factory\Psr17Factory';
    protected static string $serverRequestCreatorClass = 'Nyholm\Psr7Server\ServerRequestCreator';
    protected static string $serverRequestCreatorMethod = 'fromGlobals';

    public static function getServerRequestCreator(): ServerRequestCreatorInterface;
    public static function isServerRequestCreatorAvailable(): bool;
}
```

### Overridden Static Methods (`Slim\Factory\Psr17\NyholmPsr17Factory`)

| Method | Parameters | Return Type | Description |
| :--- | :--- | :--- | :--- |
| `getServerRequestCreator()` | *(none)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | Instantiates `Nyholm\Psr7\Factory\Psr17Factory`, injects it into `new Nyholm\Psr7Server\ServerRequestCreator(...)`, and wraps the instance in `new ServerRequestCreator($serverRequestCreator, 'fromGlobals')`. |
| `isServerRequestCreatorAvailable()` | *(none)* | `bool` | Returns `true` only when both `Nyholm\Psr7Server\ServerRequestCreator` (`parent::isServerRequestCreatorAvailable()`) and `Nyholm\Psr7\Factory\Psr17Factory` exist. |

---

## `class` Slim\Factory\Psr17\GuzzlePsr17Factory

- **Source File**: `Slim/Factory/Psr17/GuzzlePsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Package**: `guzzlehttp/psr7` (`^2.6`) — **Discovery Priority #5**

`GuzzlePsr17Factory` binds Slim to `guzzlehttp/psr7` (`GuzzleHttp\Psr7\HttpFactory` for response and stream creation, and `GuzzleHttp\Psr7\ServerRequest::fromGlobals()` for server request creation).

### PHP Class Signature (`Slim\Factory\Psr17\GuzzlePsr17Factory`)

```php
namespace Slim\Factory\Psr17;

class GuzzlePsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'GuzzleHttp\Psr7\HttpFactory';
    protected static string $streamFactoryClass = 'GuzzleHttp\Psr7\HttpFactory';
    protected static string $serverRequestCreatorClass = 'GuzzleHttp\Psr7\ServerRequest';
    protected static string $serverRequestCreatorMethod = 'fromGlobals';
}
```

---

## `class` Slim\Factory\Psr17\LaminasDiactorosPsr17Factory

- **Source File**: `Slim/Factory/Psr17/LaminasDiactorosPsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Package**: `laminas/laminas-diactoros` (`^2.17 || ^3`) — **Discovery Priority #4**

`LaminasDiactorosPsr17Factory` binds Slim to Laminas Diactoros (`Laminas\Diactoros\ResponseFactory`, `Laminas\Diactoros\StreamFactory`, and `Laminas\Diactoros\ServerRequestFactory::fromGlobals()`).

### PHP Class Signature (`Slim\Factory\Psr17\LaminasDiactorosPsr17Factory`)

```php
namespace Slim\Factory\Psr17;

class LaminasDiactorosPsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'Laminas\Diactoros\ResponseFactory';
    protected static string $streamFactoryClass = 'Laminas\Diactoros\StreamFactory';
    protected static string $serverRequestCreatorClass = 'Laminas\Diactoros\ServerRequestFactory';
    protected static string $serverRequestCreatorMethod = 'fromGlobals';
}
```

---

## `class` Slim\Factory\Psr17\HttpSoftPsr17Factory

- **Source File**: `Slim/Factory/Psr17/HttpSoftPsr17Factory.php`
- **Namespace**: `Slim\Factory\Psr17`
- **Extends**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **Backed Packages**: `httpsoft/http-message` (`^1.1`) and `httpsoft/http-server-request` (`^1.1`) — **Discovery Priority #2**

`HttpSoftPsr17Factory` binds Slim to HttpSoft's lightweight PSR-7/PSR-17 implementation (`HttpSoft\Message\ResponseFactory`, `HttpSoft\Message\StreamFactory`, and `HttpSoft\ServerRequest\ServerRequestCreator::createFromGlobals()`).

### PHP Class Signature (`Slim\Factory\Psr17\HttpSoftPsr17Factory`)

```php
namespace Slim\Factory\Psr17;

class HttpSoftPsr17Factory extends Psr17Factory
{
    protected static string $responseFactoryClass = 'HttpSoft\Message\ResponseFactory';
    protected static string $streamFactoryClass = 'HttpSoft\Message\StreamFactory';
    protected static string $serverRequestCreatorClass = 'HttpSoft\ServerRequest\ServerRequestCreator';
    protected static string $serverRequestCreatorMethod = 'createFromGlobals';
}
```
