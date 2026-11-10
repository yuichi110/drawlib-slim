# PSR-17 ファクトリ自動検出とプロバイダ

`Slim\Factory\Psr17\*` に含まれる全 10 クラス（[`Psr17FactoryProvider`](#slim-factory-psr17-psr17factoryprovider)、[`Psr17Factory`](#slim-factory-psr17-psr17factory)、[`ServerRequestCreator`](#slim-factory-psr17-serverrequestcreator)、[`SlimHttpServerRequestCreator`](#slim-factory-psr17-slimhttpserverrequestcreator)、[`SlimPsr17Factory`](#slim-factory-psr17-slimpsr17factory)、[`SlimHttpPsr17Factory`](#slim-factory-psr17-slimhttppsr17factory)、[`NyholmPsr17Factory`](#slim-factory-psr17-nyholmpsr17factory)、[`GuzzlePsr17Factory`](#slim-factory-psr17-guzzlepsr17factory)、[`LaminasDiactorosPsr17Factory`](#slim-factory-psr17-laminasdiactorospsr17factory)、[`HttpSoftPsr17Factory`](#slim-factory-psr17-httpsoftpsr17factory)）のリファレンスです。

```drawlib align=center code=fold file=psr17_class_hierarchy.png caption="Slim\\Factory\\Psr17\\* — クラス階層・プロバイダレジストリ・デコレータ構成 (全 10 クラス)"
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

## PSR-17 自動検出の優先順位とベンダマッピング一覧

[`AppFactory::determineResponseFactory()`](01_app_and_factories.md#slim-factory-appfactory) や [`ServerRequestCreatorFactory::determineServerRequestCreator()`](01_app_and_factories.md#slim-factory-serverrequestcreatorfactory) が明示的なファクトリ指定なしで呼び出されると、`Psr17FactoryProvider::getFactories()` を順番に走査し、オートローダ上で利用可能な最初のプロバイダを選択します。

```drawlib align=center code=fold file=psr17_discovery_priority_pipeline.png caption="PSR-17 自動検出の優先順位とベンダクラス設定マトリクス"
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

- **ソースファイル**: `Slim/Factory/Psr17/Psr17FactoryProvider.php`
- **名前空間**: `Slim\Factory\Psr17`
- **実装インターフェース**: [`Slim\Interfaces\Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface)

`Psr17FactoryProvider` は、PSR-17 自動検出時に走査される [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) クラス名の順序付き静的リストを保持します。`addFactory()` を呼び出すと `array_unshift()` によって `static::$factories` の先頭にクラス名が追加され、組み込みの 5 プロバイダよりも優先されます。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\Psr17FactoryProvider`)

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

### 静的プロパティとメソッド (`Slim\Factory\Psr17\Psr17FactoryProvider`)

| メンバ / メソッド | 引数 / 型 | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$factories` | `protected static string[]` | `string[]` | 登録済みの `Psr17Factory` クラス名配列（`SlimPsr17Factory`、`HttpSoftPsr17Factory`、`NyholmPsr17Factory`、`LaminasDiactorosPsr17Factory`、`GuzzlePsr17Factory`）。 |
| `getFactories()` | *(なし)* | `string[]` | 現在登録されている `Psr17FactoryInterface` クラス名の配列を返します。 |
| `setFactories($factories)` | `string[] $factories` | `void` | `$factories` 配列全体をカスタムの優先順位リストで置き換えます。 |
| `addFactory($factory)` | `string $factory` | `void` | `static::$factories` の先頭に `$factory` を追加（`array_unshift()`）し、最優先で検出されるようにします。 |

### 使用例 (`Slim\Factory\Psr17\Psr17FactoryProvider`)

```php
<?php

declare(strict_types=1);

use Slim\Factory\Psr17\NyholmPsr17Factory;
use Slim\Factory\Psr17\Psr17FactoryProvider;

// 複数パッケージがインストールされている環境で Nyholm/PSR-7 を最優先に固定
Psr17FactoryProvider::setFactories([
    NyholmPsr17Factory::class,
]);
```

---

## `class` Slim\Factory\Psr17\Psr17Factory

- **ソースファイル**: `Slim/Factory/Psr17/Psr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **実装インターフェース**: [`Slim\Interfaces\Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface)

`Psr17Factory` は、各 PSR-7 / PSR-17 ベンダアダプタが継承する抽象基底クラスです。各サブクラスは保護された静的文字列プロパティ（`$responseFactoryClass`、`$streamFactoryClass`、`$serverRequestCreatorClass`、`$serverRequestCreatorMethod`）を定義し、`Psr17Factory` が `class_exists()` の確認とインスタンス生成を担います。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\Psr17Factory`)

```php
namespace Slim\Factory\Psr17;

use Psr\Http\Message\ResponseFactoryInterface;
use Psr\Http\Message\StreamFactoryInterface;
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

### 静的プロパティとメソッド (`Slim\Factory\Psr17\Psr17Factory`)

| メンバ / メソッド | 引数 / 型 | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$responseFactoryClass` | `protected static string` | `string` | ベンダの `ResponseFactoryInterface` 実装の完全修飾クラス名。 |
| `$streamFactoryClass` | `protected static string` | `string` | ベンダの `StreamFactoryInterface` 実装の完全修飾クラス名。 |
| `$serverRequestCreatorClass` | `protected static string` | `string` | グローバル変数から `ServerRequestInterface` を生成するベンダクラスの完全修飾名。 |
| `$serverRequestCreatorMethod` | `protected static string` | `string` | `$serverRequestCreatorClass` 上で呼び出されるメソッド名（例: `'createFromGlobals'`、`'fromGlobals'`）。 |
| `getResponseFactory()` | *(なし)* | `ResponseFactoryInterface` | `isResponseFactoryAvailable()` と `instanceof ResponseFactoryInterface` を検証した上で `new static::$responseFactoryClass()` を生成します。失敗時は `RuntimeException` をスローします。 |
| `getStreamFactory()` | *(なし)* | `StreamFactoryInterface` | `isStreamFactoryAvailable()` と `instanceof StreamFactoryInterface` を検証した上で `new static::$streamFactoryClass()` を生成します。失敗時は `RuntimeException` をスローします。 |
| `getServerRequestCreator()` | *(なし)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | `new ServerRequestCreator(static::$serverRequestCreatorClass, static::$serverRequestCreatorMethod)` を返します。利用不可の場合は `RuntimeException` をスローします。 |
| `isResponseFactoryAvailable()` | *(なし)* | `bool` | `static::$responseFactoryClass` が空でなく `class_exists()` が真の場合に `true` を返します。 |
| `isStreamFactoryAvailable()` | *(なし)* | `bool` | `static::$streamFactoryClass` が空でなく `class_exists()` が真の場合に `true` を返します。 |
| `isServerRequestCreatorAvailable()` | *(なし)* | `bool` | `static::$serverRequestCreatorClass` と `static::$serverRequestCreatorMethod` が空でなく `class_exists()` が真の場合に `true` を返します。 |

---

## `class` Slim\Factory\Psr17\ServerRequestCreator

- **ソースファイル**: `Slim/Factory/Psr17/ServerRequestCreator.php`
- **名前空間**: `Slim\Factory\Psr17`
- **実装インターフェース**: [`Slim\Interfaces\ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface)

`ServerRequestCreator` は、サードパーティの静的またはインスタンスファクトリメソッド（`Slim\Psr7\Factory\ServerRequestFactory::createFromGlobals()` や `Nyholm\Psr7Server\ServerRequestCreator::fromGlobals()` など）を `Closure::fromCallable([$this->serverRequestCreator, $this->serverRequestCreatorMethod])()` で呼び出し、Slim 共通の [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) に適合させるアダプタです。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\ServerRequestCreator`)

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

### コンストラクタとメソッド (`Slim\Factory\Psr17\ServerRequestCreator`)

| メソッド | パラメータ | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct(...)` | `object\|string $serverRequestCreator`, `string $serverRequestCreatorMethod` | `void` | 対象クラス名（静的メソッド用）またはオブジェクトインスタンス（`NyholmPsr17Factory` 用）と呼び出しメソッド名を保持します。 |
| `createServerRequestFromGlobals()` | *(なし)* | `ServerRequestInterface` | `Closure::fromCallable([$this->serverRequestCreator, $this->serverRequestCreatorMethod])` を引数なしで実行し、`ServerRequestInterface` を生成して返します。 |

### 使用例 (`Slim\Factory\Psr17\ServerRequestCreator`)

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

- **ソースファイル**: `Slim/Factory/Psr17/SlimHttpServerRequestCreator.php`
- **名前空間**: `Slim\Factory\Psr17`
- **実装インターフェース**: [`Slim\Interfaces\ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface)

`SlimHttpServerRequestCreator` は、任意の [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) をラップし、返された PSR-7 `ServerRequestInterface` を `Slim\Http\ServerRequest`（オプションの `slim/http` パッケージ）でデコレートすることで、`$request->getParam()`、`$request->getQueryParam()`、`$request->isXhr()` などのヘルパーメソッドを提供します。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\SlimHttpServerRequestCreator`)

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

### コンストラクタとメソッド (`Slim\Factory\Psr17\SlimHttpServerRequestCreator`)

| メソッド | パラメータ | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct($serverRequestCreator)` | `ServerRequestCreatorInterface $serverRequestCreator` | `void` | デコレート対象の内部 `ServerRequestCreatorInterface` を保持します。 |
| `createServerRequestFromGlobals()` | *(なし)* | `ServerRequestInterface` | `isServerRequestDecoratorAvailable()` を確認した上で内部クリエイタを呼び出し、`new static::$serverRequestDecoratorClass($request)` でラップして返します。 |
| `isServerRequestDecoratorAvailable()` | *(なし)* | `bool` | `class_exists('Slim\Http\ServerRequest')` の結果を返します。 |

---

## `class` Slim\Factory\Psr17\SlimPsr17Factory

- **ソースファイル**: `Slim/Factory/Psr17/SlimPsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `slim/psr7` (`^1.6`) — **自動検出優先度 #1**

`SlimPsr17Factory` は、`Psr17FactoryProvider` で最優先される公式 `slim/psr7` パッケージ向けの PSR-17 アダプタです。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\SlimPsr17Factory`)

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

### 使用例 (`Slim\Factory\Psr17\SlimPsr17Factory`)

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

- **ソースファイル**: `Slim/Factory/Psr17/SlimHttpPsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `slim/http` (`^1.3`)

`SlimHttpPsr17Factory` は、[`AppFactory::attemptResponseFactoryDecoration()`](01_app_and_factories.md#slim-factory-appfactory) から呼び出されるデコレータ専用ファクトリです。5 つのベース PSR-17 プロバイダとは異なり、単体の PSR-7 実装は提供せず、`createDecoratedResponseFactory()` によって任意のベース `ResponseFactoryInterface` と `StreamFactoryInterface` を `Slim\Http\Factory\DecoratedResponseFactory` でラップします（`$response->withJson()`、`$response->withRedirect()`、`$response->write()` などのヘルパーメソッドが付与されます）。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

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

### 静的メソッド (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

| メソッド | パラメータ | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `createDecoratedResponseFactory(...)` | `ResponseFactoryInterface $responseFactory`, `StreamFactoryInterface $streamFactory` | `ResponseFactoryInterface` | `new Slim\Http\Factory\DecoratedResponseFactory($responseFactory, $streamFactory)` を生成し、`instanceof ResponseFactoryInterface` を検証して返します（失敗時は `RuntimeException`）。 |

### 使用例 (`Slim\Factory\Psr17\SlimHttpPsr17Factory`)

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

- **ソースファイル**: `Slim/Factory/Psr17/NyholmPsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `nyholm/psr7` (`^1.8`) および `nyholm/psr7-server` (`^1.1`) — **自動検出優先度 #3**

`NyholmPsr17Factory` は、Nyholm の高速な PSR-7 / PSR-17 実装を統合します。`Nyholm\Psr7\Factory\Psr17Factory` は 4 つの PSR-17 ファクトリインターフェース（`ServerRequestFactoryInterface`、`UriFactoryInterface`、`UploadedFileFactoryInterface`、`StreamFactoryInterface`）を単一クラスで実装しているため、`NyholmPsr17Factory::getServerRequestCreator()` は親メソッドをオーバーライドし、単一の `$psr17Factory` インスタンスを `new Nyholm\Psr7Server\ServerRequestCreator($psr17Factory, $psr17Factory, $psr17Factory, $psr17Factory)` の 4 引数すべてに渡します。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\NyholmPsr17Factory`)

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

### オーバーライドされた静的メソッド (`Slim\Factory\Psr17\NyholmPsr17Factory`)

| メソッド | パラメータ | 戻り値 | 説明 |
| :--- | :--- | :--- | :--- |
| `getServerRequestCreator()` | *(なし)* | [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | `Nyholm\Psr7\Factory\Psr17Factory` を生成して `new Nyholm\Psr7Server\ServerRequestCreator(...)` に注入し、`new ServerRequestCreator($serverRequestCreator, 'fromGlobals')` でラップして返します。 |
| `isServerRequestCreatorAvailable()` | *(なし)* | `bool` | `Nyholm\Psr7Server\ServerRequestCreator`（`parent::isServerRequestCreatorAvailable()`）と `Nyholm\Psr7\Factory\Psr17Factory` の両方が存在する場合のみ `true` を返します。 |

---

## `class` Slim\Factory\Psr17\GuzzlePsr17Factory

- **ソースファイル**: `Slim/Factory/Psr17/GuzzlePsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `guzzlehttp/psr7` (`^2.6`) — **自動検出優先度 #5**

`GuzzlePsr17Factory` は、`guzzlehttp/psr7`（レスポンス・ストリーム生成に `GuzzleHttp\Psr7\HttpFactory`、サーバリクエスト生成に `GuzzleHttp\Psr7\ServerRequest::fromGlobals()`）を Slim にバインドします。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\GuzzlePsr17Factory`)

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

- **ソースファイル**: `Slim/Factory/Psr17/LaminasDiactorosPsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `laminas/laminas-diactoros` (`^2.17 || ^3`) — **自動検出優先度 #4**

`LaminasDiactorosPsr17Factory` は、Laminas Diactoros（`Laminas\Diactoros\ResponseFactory`、`Laminas\Diactoros\StreamFactory`、および `Laminas\Diactoros\ServerRequestFactory::fromGlobals()`）を Slim にバインドします。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\LaminasDiactorosPsr17Factory`)

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

- **ソースファイル**: `Slim/Factory/Psr17/HttpSoftPsr17Factory.php`
- **名前空間**: `Slim\Factory\Psr17`
- **継承元**: [`Slim\Factory\Psr17\Psr17Factory`](#slim-factory-psr17-psr17factory)
- **対応パッケージ**: `httpsoft/http-message` (`^1.1`) および `httpsoft/http-server-request` (`^1.1`) — **自動検出優先度 #2**

`HttpSoftPsr17Factory` は、HttpSoft の軽量な PSR-7 / PSR-17 実装（`HttpSoft\Message\ResponseFactory`、`HttpSoft\Message\StreamFactory`、および `HttpSoft\ServerRequest\ServerRequestCreator::createFromGlobals()`）を Slim にバインドします。

### PHP クラスシグネチャ (`Slim\Factory\Psr17\HttpSoftPsr17Factory`)

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
