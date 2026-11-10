# ルーティング (`Slim\Routing`)

`Slim\Routing` 名前空間は、FastRoute を基盤とした Slim 4 のルーティングサブシステムを実装します。ルート登録（`RouteCollectorProxy`、`RouteCollector`、`Route`、`RouteGroup`）、名前付きルートからの URL 生成（`RouteParser`）、リクエストスコープのルーティング状態管理（`RouteContext`）、および URI ディスパッチと実行（`RouteResolver`、`Dispatcher`、`FastRouteDispatcher`、`RoutingResults`、`RouteRunner`）を担います。

```drawlib align=center code=fold file=routing_architecture_ja.png caption="Slim 4 ルーティングサブシステム — ルート登録・URI解決・ディスパッチの全体構成"
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
text((46, 75), "1. ルート登録・URL生成フェーズ", style=Styles.PrimaryBold.patch(text_size=12.0))

rectangle(
    (134, 43),
    width=80,
    height=74,
    style=Styles.PrimaryNeutral.patch(shape_r=3.0),
)
text((134, 75), "2. URIディスパッチ・ルート実行フェーズ", style=Styles.PrimaryBold.patch(text_size=12.0))

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
text((46, 39.5), "Route[]・RouteGroup[] の管理", style=Styles.White.patch(text_size=10.0))

rectangle(
    (27, 20),
    width=30,
    height=14,
    style=Styles.Neutral.patch(shape_r=2.0),
)
text((27, 22.5), "Route & Group", style=Styles.BlackBold.patch(text_size=10.5))
text((27, 17.5), "パターン + ミドルウェア", style=Styles.Dark.patch(text_size=9.5))

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
text((134, 39.5), "静的マップ -> 正規表現 -> HEAD/GET", style=Styles.White.patch(text_size=10.0))

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
text((90, 45.5), "ルート定義", style=Styles.PrimaryBold.patch(text_size=10.0))

save()
```

---

## `class` Slim\Routing\RouteCollectorProxy

- **ソースファイル**: `Slim/Routing/RouteCollectorProxy.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface)
- **サブクラス**: [`Slim\App`](01_app_and_factories.md#slim-app)

`RouteCollectorProxy` は、[`Slim\App`](01_app_and_factories.md#slim-app) およびネストされたルートグループで共有される HTTP メソッド別の流暢なルーティング API（`get()`、`post()`、`put()`、`patch()`、`delete()`、`options()`、`any()`、`map()`、`group()`、`redirect()`）を提供します。ルートグループ用にインスタンス化された場合、すべての子ルートおよびサブグループのパターン先頭に `$groupPattern` を付与したうえで、背後の [`RouteCollector`](#slim-routing-routecollector) に登録を委譲します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$responseFactory` | `ResponseFactoryInterface` | — | ルートおよびリダイレクトでレスポンスを生成するための PSR-17 レスポンスファクトリ。 |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | 文字列・配列・クロージャ形式のルートハンドラやグループコールバックを解決します。 |
| `$container` | `?ContainerInterface` | `null` | 任意の PSR-11 DI コンテナ。 |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `new RouteCollector(...)` | 登録済みルートとグループを保持する背後のルートコレクタ。 |
| `$groupPattern` | `string` | `''` | このプロキシ経由で登録されるすべてのルートおよびグループに付与されるプレフィックスパターン。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?RouteCollectorInterface $routeCollector = null`, `string $groupPattern = ''` | `void` | プロキシを初期化します。`$routeCollector` が省略された場合は新しい [`RouteCollector`](#slim-routing-routecollector) を生成します。 |
| `getResponseFactory` | *(なし)* | `ResponseFactoryInterface` | 設定されている PSR-17 レスポンスファクトリを返します。 |
| `getCallableResolver` | *(なし)* | `CallableResolverInterface` | 設定されている Callable リゾルバを返します。 |
| `getContainer` | *(なし)* | `?ContainerInterface` | PSR-11 コンテナインスタンス（未設定時は `null`）を返します。 |
| `getRouteCollector` | *(なし)* | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | 背後の [`RouteCollector`](#slim-routing-routecollector) を返します。 |
| `getBasePath` | *(なし)* | `string` | ルートコレクタに設定されているアプリケーションのベースパスを返します。 |
| `setBasePath` | `string $basePath` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | ルートコレクタにベースパスを設定し、`$this` を返します。 |
| `get` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `GET` ルートを登録します。 |
| `post` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `POST` ルートを登録します。 |
| `put` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `PUT` ルートを登録します。 |
| `patch` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `PATCH` ルートを登録します。 |
| `delete` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `DELETE` ルートを登録します。 |
| `options` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->groupPattern` を付与した `OPTIONS` ルートを登録します。 |
| `any` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `OPTIONS` のすべてにマッチするルートを登録します。 |
| `map` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$pattern` の先頭に `$this->groupPattern` を結合し、`RouteCollector::map()` に委譲します。 |
| `group` | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | `$pattern` の先頭に `$this->groupPattern` を結合し、`RouteCollector::group()` に委譲します。 |
| `redirect` | `string $from`, `string\|UriInterface $to`, `int $status = 302` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$from` に対する `GET` ルートを登録し、`Location: $to` ヘッダを持つリダイレクトレスポンスを返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Routing/RouteCollector.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface)

`RouteCollector` は、[`Route`](#slim-routing-route) および [`RouteGroup`](#slim-routing-routegroup) インスタンスの生成と保持、デフォルトの [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)（既定は [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse)）の管理、FastRoute キャッシュファイルの設定、および名前付きルートやルート識別子による検索を担う中央レジストリです。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$routeParser` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | `new RouteParser($this)` | 名前付きルートから相対 URL・完全 URL を生成するルートパーサ。 |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | 生成されるルートやグループに渡される Callable リゾルバ。 |
| `$container` | `?ContainerInterface` | `null` | 生成されるルートやプロキシに渡される任意の PSR-11 コンテナ。 |
| `$defaultInvocationStrategy` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | `new RequestResponse()` | ルートハンドラ呼び出し時のデフォルト実行戦略。 |
| `$basePath` | `string` | `''` | `RouteParser::urlFor()` および `Dispatcher` で先頭に付与されるベースパス。 |
| `$cacheFile` | `?string` | `null` | FastRoute ディスパッチテーブルのキャッシュファイルパス（`null` で無効）。 |
| `$routes` | `array<string, RouteInterface>` | `[]` | ルート識別子（`route0`, `route1`, ...）をキーとする登録済みルート配列。 |
| `$routesByName` | `array<string, RouteInterface>` | `[]` | ルート名をキーとする名前付きルートの検索キャッシュ。 |
| `$routeGroups` | `RouteGroupInterface[]` | `[]` | `group()` 収集中の親ルートグループのスタック。 |
| `$routeCounter` | `int` | `0` | 一意なルート識別子を採番する単調増加カウンタ。 |
| `$responseFactory` | `ResponseFactoryInterface` | — | 生成されるルートやプロキシに渡される PSR-17 レスポンスファクトリ。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?InvocationStrategyInterface $defaultInvocationStrategy = null`, `?RouteParserInterface $routeParser = null`, `?string $cacheFile = null` | `void` | コレクタを初期化します。省略時は [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) と [`RouteParser`](#slim-routing-routeparser) が生成されます。 |
| `getRouteParser` | *(なし)* | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | [`RouteParser`](#slim-routing-routeparser) インスタンスを返します。 |
| `getDefaultInvocationStrategy` | *(なし)* | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | デフォルトのルート実行戦略を返します。 |
| `setDefaultInvocationStrategy` | `InvocationStrategyInterface $strategy` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | 以降に作成されるルートのデフォルト実行戦略を変更します。 |
| `getCacheFile` | *(なし)* | `?string` | FastRoute キャッシュファイルのパス（無効時は `null`）を返します。 |
| `setCacheFile` | `string $cacheFile` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | 既存ファイルの読取権限または親ディレクトリの書込権限を検証し、キャッシュファイルを設定します。不正時は `RuntimeException` をスローします。 |
| `getBasePath` | *(なし)* | `string` | 設定されているベースパスを返します。 |
| `setBasePath` | `string $basePath` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `urlFor()` やディスパッチで使用するベースパスを設定します。 |
| `getRoutes` | *(なし)* | `RouteInterface[]` | ルート識別子をキーとする全登録ルートを返します。 |
| `removeNamedRoute` | `string $name` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | 指定名のルートを `$routesByName` と `$routes` の両方から削除します。未登録時は `RuntimeException` をスローします。 |
| `getNamedRoute` | `string $name` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | ルート名からルートを検索し、`$routesByName` にキャッシュして返します。未登録時は `RuntimeException` をスローします。 |
| `lookupRoute` | `string $identifier` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | 内部識別子（`'route0'` など）でルートを検索します。存在しない場合は `RuntimeException` をスローします。 |
| `group` | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | 新しい [`RouteGroup`](#slim-routing-routegroup) を `$routeGroups` スタックに積み、`collectRoutes()` を実行後ポップして返します。 |
| `createGroup` *(protected)* | `string $pattern`, `callable\|string $callable` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | スコープ付き [`RouteCollectorProxy`](#slim-routing-routecollectorproxy) を持つ [`RouteGroup`](#slim-routing-routegroup) を生成するファクトリメソッド。 |
| `createProxy` *(protected)* | `string $pattern` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | グループパターン用の [`RouteCollectorProxy`](#slim-routing-routecollectorproxy) を生成するファクトリメソッド。 |
| `map` | `string[] $methods`, `string $pattern`, `callable\|array\|string $handler` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | [`Route`](#slim-routing-route) を生成して `$routes` に登録し、`$routeCounter` をインクリメントして返します。 |
| `createRoute` *(protected)* | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | 現在の `$routeGroups` と `$routeCounter` を渡して [`Route`](#slim-routing-route) をインスタンス化します。 |

### 使用例

```php
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponseArgs;

$app = AppFactory::create();
$routeCollector = $app->getRouteCollector();

// ルート引数を個別の関数引数として展開する戦略に変更
$routeCollector->setDefaultInvocationStrategy(new RequestResponseArgs());

// 本番環境向けに FastRoute キャッシュファイルを有効化
$routeCollector->setCacheFile(__DIR__ . '/../var/cache/routes.cache.php');
```

---

## `class` Slim\Routing\Route

- **ソースファイル**: `Slim/Routing/Route.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface), `Psr\Http\Server\RequestHandlerInterface`

`Route` は登録された単一のエンドポイントを表し、それ自体が PSR-15 の `RequestHandlerInterface` として動作します。対応 HTTP メソッド、URI パターン、ハンドラ、ルート引数、親 [`RouteGroup`](#slim-routing-routegroup) の配列、およびルート専用の [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) を保持します。[`RouteRunner`](#slim-routing-routerunner) から `run()` が呼ばれると、初回実行時に親グループのミドルウェアを内側のグループから外側のグループの順に遅延結合したうえで `handle()` を呼び出します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$methods` | `string[]` | `[]` | このルートが受け付ける HTTP メソッド配列（例: `['GET', 'POST']`）。 |
| `$identifier` | `string` | `'route' . $identifier` | 一意なルート識別子（例: `'route0'`）。 |
| `$name` | `?string` | `null` | URL 逆引き生成用の任意のルート名。 |
| `$groups` | `RouteGroupInterface[]` | `[]` | 外側から内側の順に並んだ親ルートグループの配列。 |
| `$invocationStrategy` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | `new RequestResponse()` | 解決されたルートハンドラを呼び出す実行戦略。 |
| `$arguments` | `array<string, string>` | `[]` | リクエスト URI から抽出された（または手動設定された）現在のルートパラメータ。 |
| `$savedArguments` | `array<string, string>` | `[]` | `prepare()` 呼び出しを跨いで保持される初期デフォルトのルート引数。 |
| `$container` | `?ContainerInterface` | `null` | 任意の PSR-11 コンテナ。 |
| `$middlewareDispatcher` | [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | — | `$this` を最内殻カーネルとしてラップするルート専用ミドルウェアディスパッチャ。 |
| `$callable` | `callable\|array{class-string, string}\|string` | — | 未解決のルートハンドラ定義。 |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | `$callable` およびミドルウェアを解決する Callable リゾルバ。 |
| `$responseFactory` | `ResponseFactoryInterface` | — | 実行戦略に渡す新規 `ResponseInterface` を生成する PSR-17 ファクトリ。 |
| `$pattern` | `string` | — | グループプレフィックスを含む完全なルート URI パターン。 |
| `$groupMiddlewareAppended` | `bool` | `false` | 親グループのミドルウェアが `$middlewareDispatcher` に追加済みかどうかを表すフラグ。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable`, `ResponseFactoryInterface $responseFactory`, `CallableResolverInterface $callableResolver`, `?ContainerInterface $container = null`, `?InvocationStrategyInterface $invocationStrategy = null`, `RouteGroupInterface[] $groups = []`, `int $identifier = 0` | `void` | ルートを生成し、内部の [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) を初期化します。 |
| `getCallableResolver` | *(なし)* | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | ルートの Callable リゾルバを返します。 |
| `getInvocationStrategy` | *(なし)* | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | ルートの実行戦略を返します。 |
| `setInvocationStrategy` | `InvocationStrategyInterface $invocationStrategy` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | このルート固有の実行戦略を上書き設定します。 |
| `getMethods` | *(なし)* | `string[]` | 対応する HTTP メソッド配列を返します。 |
| `getPattern` | *(なし)* | `string` | ルートの URI パターン文字列を返します。 |
| `setPattern` | `string $pattern` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | ルートの URI パターン文字列を更新します。 |
| `getCallable` | *(なし)* | `callable\|array\|string` | ルートハンドラ定義を返します。 |
| `setCallable` | `callable\|array\|string $callable` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | ルートハンドラ定義を置き換えます。 |
| `getName` | *(なし)* | `?string` | ルート名（未設定時は `null`）を返します。 |
| `setName` | `string $name` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `RouteParser::urlFor()` 用のルート名を設定します。 |
| `getIdentifier` | *(なし)* | `string` | 内部ルート識別子（`'route0'` など）を返します。 |
| `getArgument` | `string $name`, `?string $default = null` | `?string` | 指定名のルート引数を取得します（存在しない場合は `$default`）。 |
| `getArguments` | *(なし)* | `array<string, string>` | すべてのルート引数を返します。 |
| `setArguments` | `array<string, string> $arguments`, `bool $includeInSavedArguments = true` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | ルート引数を一括置換します（`$includeInSavedArguments` が `true` の場合は `$savedArguments` も更新）。 |
| `getGroups` | *(なし)* | `RouteGroupInterface[]` | 親ルートグループの配列を返します。 |
| `add` | `MiddlewareInterface\|string\|callable $middleware` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | ルート固有のミドルウェアを `$middlewareDispatcher` に追加します。 |
| `addMiddleware` | `MiddlewareInterface $middleware` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | 型付きの PSR-15 `MiddlewareInterface` インスタンスを `$middlewareDispatcher` に追加します。 |
| `prepare` | `array<string, string> $arguments` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$savedArguments` の上にリクエストでマッチした `$arguments` をマージ（`array_replace()`）します。 |
| `setArgument` | `string $name`, `string $value`, `bool $includeInSavedArguments = true` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | 単一のルート引数を設定します。 |
| `run` | `ServerRequestInterface $request` | `ResponseInterface` | 親グループのミドルウェアが未結合であれば遅延結合し、`$middlewareDispatcher->handle($request)` を実行します。 |
| `appendGroupMiddlewareToRoute` *(protected)* | *(なし)* | `void` | ルートのミドルウェアディスパッチャを内側としてラップし、`array_reverse($this->groups)` の順でグループミドルウェアを追加します。 |
| `handle` | `ServerRequestInterface $request` | `ResponseInterface` | `$callable` を解決し（対象が `RequestHandlerInterface` の場合は `RequestHandler` 戦略へ自動切替）、新規レスポンスを生成して戦略を実行します。 |

### 使用例

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

- **ソースファイル**: `Slim/Routing/RouteGroup.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface)

`RouteGroup` は共通の URL パターンプレフィックスとグループ単位のミドルウェアスタックをカプセル化します。ルート登録時に `collectRoutes()` がグループコールバックを解決し、グループスコープの [`RouteCollectorProxy`](#slim-routing-routecollectorproxy) を引数に渡して実行します。子 [`Route`](#slim-routing-route) の実行時には、`appendMiddlewareToDispatcher()` によってグループのミドルウェアがルートの [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) へ追加されます。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- |
| `$callable` | `callable\|string` | — | グループ内のルートを定義するコールバックまたはコンテナ解決文字列。 |
| `$callableResolver` | [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | — | `collectRoutes()` 実行時に `$callable` を解決するリゾルバ。 |
| `$routeCollectorProxy` | [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | — | `$callable` の第 1 引数として渡されるグループスコープ付きプロキシ。 |
| `$middleware` | `array<MiddlewareInterface\|string\|callable>` | `[]` | グループ内の全ルートに適用されるミドルウェアキュー。 |
| `$pattern` | `string` | — | グループの URI パターンプレフィックス（親グループのプレフィックスを含む）。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `string $pattern`, `callable\|string $callable`, `CallableResolverInterface $callableResolver`, `RouteCollectorProxyInterface $routeCollectorProxy` | `void` | パターン、ルート定義コールバック、リゾルバ、プロキシでルートグループを初期化します。 |
| `collectRoutes` | *(なし)* | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | `$callable` を解決し、`$routeCollectorProxy` を渡して実行します。 |
| `add` | `MiddlewareInterface\|string\|callable $middleware` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | ミドルウェア（PSR-15 インスタンス、callable、またはコンテナキー）をグループに追加します。 |
| `addMiddleware` | `MiddlewareInterface $middleware` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | 型付き PSR-15 `MiddlewareInterface` インスタンスをグループに追加します。 |
| `appendMiddlewareToDispatcher` | [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) `$dispatcher` | [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | `$this->middleware` を順に走査し、`$dispatcher->add($middleware)` を呼び出します。 |
| `getPattern` | *(なし)* | `string` | グループの URI パターンプレフィックスを返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Routing/RouteContext.php`
- **名前空間**: `Slim\Routing`
- **修飾子**: `final class`

`RouteContext` は、[`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) または [`RouteRunner`](#slim-routing-routerunner) によるルーティング完了後に、`ServerRequestInterface` の属性（attributes）からリクエストスコープのルーティング情報（`Route`、`RouteParser`、`RoutingResults`、`basePath`）を型安全に抽出するイミュータブルな値オブジェクトです。

### クラスシグネチャ

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

### 定数とプロパティ

| 定数 / プロパティ | 型 / 値 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `ROUTE` | `'__route__'` | `public const` | マッチした [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) を格納するリクエスト属性キー。 |
| `ROUTE_PARSER` | `'__routeParser__'` | `public const` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) を格納するリクエスト属性キー。 |
| `ROUTING_RESULTS` | `'__routingResults__'` | `public const` | [`RoutingResults`](#slim-routing-routingresults) を格納するリクエスト属性キー。 |
| `BASE_PATH` | `'__basePath__'` | `public const` | アプリケーションのベースパス文字列を格納するリクエスト属性キー。 |
| `$route` | `?RouteInterface` | `private` | マッチしたルートオブジェクト（未マッチ時は `null`）。 |
| `$routeParser` | `RouteParserInterface` | `private` | リクエストに紐づくルートパーサ。 |
| `$routingResults` | `RoutingResults` | `private` | ステータス・識別子・ルート引数を保持するディスパッチ結果。 |
| `$basePath` | `?string` | `private` | アプリケーションのベースパス（未設定時は `null`）。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `fromRequest` *(static)* | `ServerRequestInterface $serverRequest` | `self` | `$serverRequest` から `ROUTE`, `ROUTE_PARSER`, `ROUTING_RESULTS`, `BASE_PATH` 属性を読み取り、`RouteContext` を返します。ルーティング未完了時は `RuntimeException` をスローします。 |
| `__construct` *(private)* | `?RouteInterface $route`, `RouteParserInterface $routeParser`, `RoutingResults $routingResults`, `?string $basePath = null` | `void` | `RouteContext::fromRequest()` から呼び出されるプライベートコンストラクタ。 |
| `getRoute` | *(なし)* | `?RouteInterface` | マッチした [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) または `null` を返します。 |
| `getRouteParser` | *(なし)* | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) インスタンスを返します。 |
| `getRoutingResults` | *(なし)* | [`RoutingResults`](#slim-routing-routingresults) | [`RoutingResults`](#slim-routing-routingresults) インスタンスを返します。 |
| `getBasePath` | *(なし)* | `string` | ベースパス文字列を返します。`$basePath` が `null` の場合は `RuntimeException` をスローします。 |

### 使用例

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

- **ソースファイル**: `Slim/Routing/RouteParser.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface)

`RouteParser` は `FastRoute\RouteParser\Std` を用いて名前付きルートからの逆引き URL 生成を行います。必須パラメータおよび省略可能パラメータ（`[/{optional}]`）、クエリストリングの付与、ベースパスの結合、およびスキームとホスト名を含む完全 URL の構築をサポートします。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `private` | 名前付きルートの検索とベースパスの取得に使用されるルートコレクタ。 |
| `$routeParser` | `FastRoute\RouteParser\Std` | `private` | ルートパターンを静的セグメントとプレースホルダに分解する FastRoute パーサ。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector` | `void` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) を保持し、`FastRoute\RouteParser\Std` を初期化します。 |
| `relativeUrlFor` | `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | ベースパスを**含まない**相対 URL パスを生成します。必須プレースホルダが `$data` に不足している場合は `InvalidArgumentException` をスローします。 |
| `urlFor` | `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | `relativeUrlFor()` の結果の先頭に `$routeCollector->getBasePath()` を付与した URL パスを返します。 |
| `fullUrlFor` | `UriInterface $uri`, `string $routeName`, `array<string, string> $data = []`, `array<string, mixed> $queryParams = []` | `string` | `$uri` からスキームと Authority（例: `https://example.com`）を取得し、`urlFor()` の結果と結合した完全 URL を返します。 |

### 使用例

```php
$app->get('/archive/{year}[/{month}]', $handler)->setName('archive');

$routeParser = $app->getRouteCollector()->getRouteParser();

// "/archive/2026"
$path1 = $routeParser->relativeUrlFor('archive', ['year' => '2026']);

// "/base/archive/2026/11?page=2" (basePath = "/base" の場合)
$path2 = $routeParser->urlFor('archive', ['year' => '2026', 'month' => '11'], ['page' => 2]);

// "https://api.example.com/base/archive/2026/11"
$fullUrl = $routeParser->fullUrlFor($request->getUri(), 'archive', ['year' => '2026', 'month' => '11']);
```

---

## `class` Slim\Routing\RouteResolver

- **ソースファイル**: `Slim/Routing/RouteResolver.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface)

`RouteResolver` は [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) と [`Dispatcher`](#slim-routing-dispatcher) / [`RouteCollector`](#slim-routing-routecollector) の間を仲介します。リクエスト URI パスに対して `rawurldecode()` と先頭 `'/'` の正規化を行ったうえでディスパッチを実行し、マッチしたルート識別子を [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) インスタンスへと解決します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `protected` | マッチしたルート識別子から `RouteInterface` を引くためのルートコレクタ。 |
| `$dispatcher` | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | `private` | 背後のディスパッチャ（省略時は `new Dispatcher($routeCollector)`）。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector`, `?DispatcherInterface $dispatcher = null` | `void` | ルートコレクタと任意のカスタム [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) でリゾルバを初期化します。 |
| `computeRoutingResults` | `string $uri`, `string $method` | [`RoutingResults`](#slim-routing-routingresults) | `rawurldecode($uri)` を適用して先頭 `'/'` を保証し、`$this->dispatcher->dispatch($method, $uri)` の結果を返します。 |
| `resolveRoute` | `string $identifier` | [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | `$this->routeCollector->lookupRoute($identifier)` に委譲してルートを返します。存在しない場合は `RuntimeException` をスローします。 |

### 使用例

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

- **ソースファイル**: `Slim/Routing/RouteRunner.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: `Psr\Http\Server\RequestHandlerInterface`

`RouteRunner` は [`Slim\App`](01_app_and_factories.md#slim-app) のミドルウェアスタックの最深部（カーネル）に位置する `RequestHandlerInterface` 実装です。リクエストが到達した時点で [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) によって `RouteContext::ROUTING_RESULTS` 属性が設定されているかを確認し、未実行であればその場で `RoutingMiddleware` を生成してルーティングを実行します。その後 `RouteContext::BASE_PATH` 属性を付与し、`$route->run($request)` を呼び出します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `$routeResolver` | [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | `private` | ミドルウェアスタック内で `RoutingMiddleware` が実行されていなかった場合のフォールバックルーティングに使用されます。 |
| `$routeParser` | [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | `private` | フォールバック `RoutingMiddleware` の生成に使用されます。 |
| `$routeCollectorProxy` | `?RouteCollectorProxyInterface` | `private` | `getBasePath()` を取得して `RouteContext::BASE_PATH` 属性に格納するためのプロキシ（通常は `App` インスタンス）。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteResolverInterface $routeResolver`, `RouteParserInterface $routeParser`, `?RouteCollectorProxyInterface $routeCollectorProxy = null` | `void` | ルートリゾルバ、ルートパーサ、および任意のルートコレクタプロキシでランナーを初期化します。 |
| `handle` | `ServerRequestInterface $request` | `ResponseInterface` | ルーティング未実行時はルーティングを行い、`RouteContext::BASE_PATH` 属性を設定したうえで、`RouteContext::ROUTE` から取得した [`Route`](#slim-routing-route) の `run($request)` を実行します。未マッチ時は [`HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) または [`HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) をスローします。 |

### 使用例

```php
use Slim\Routing\RouteRunner;

// App::__construct() 内で自動生成されますが、カスタムカーネルとして手動構成も可能です:
$runner = new RouteRunner(
    $app->getRouteResolver(),
    $app->getRouteCollector()->getRouteParser(),
    $app
);
$response = $runner->handle($request);
```

---

## `class` Slim\Routing\Dispatcher

- **ソースファイル**: `Slim/Routing/Dispatcher.php`
- **名前空間**: `Slim\Routing`
- **実装インターフェース**: [`Slim\Interfaces\DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface)

`Dispatcher` は [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) を遅延生成してラップするアダプタです。`RouteCollector::getCacheFile()` の有無に応じて `FastRoute\cachedDispatcher` または `FastRoute\simpleDispatcher` を構築し、[`RouteCollector`](#slim-routing-routecollector) 内の全ルート（`getBasePath()` プレフィックス付き）を登録して、生の FastRoute 配列結果を [`RoutingResults`](#slim-routing-routingresults) オブジェクトに変換します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `$routeCollector` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | `private` | 登録済みルート、ベースパス、キャッシュファイル設定の取得元となるルートコレクタ。 |
| `$dispatcher` | `?FastRouteDispatcher` | `private` | 遅延初期化される [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) インスタンス。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `RouteCollectorInterface $routeCollector` | `void` | [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) インスタンスを保持します。 |
| `createDispatcher` *(protected)* | *(なし)* | [`FastRouteDispatcher`](#slim-routing-fastroutedispatcher) | キャッシュファイル設定時は `FastRoute\cachedDispatcher()`、未設定時は `FastRoute\simpleDispatcher()` を用いて `FastRouteDispatcher` を構築・キャッシュします。 |
| `dispatch` | `string $method`, `string $uri` | [`RoutingResults`](#slim-routing-routingresults) | `FastRouteDispatcher` で `$method` と `$uri` をディスパッチし、[`RoutingResults`](#slim-routing-routingresults) インスタンスを返します。 |
| `getAllowedMethods` | `string $uri` | `string[]` | `FastRouteDispatcher::getAllowedMethods()` に委譲し、指定 `$uri` で許可されている HTTP メソッド一覧を返します。 |

### 使用例

```php
use Slim\Routing\Dispatcher;
use Slim\Routing\RouteResolver;

$dispatcher = new Dispatcher($app->getRouteCollector());
$resolver = new RouteResolver($app->getRouteCollector(), $dispatcher);

$routingResults = $dispatcher->dispatch('GET', '/health');
```

---

## `class` Slim\Routing\FastRouteDispatcher

- **ソースファイル**: `Slim/Routing/FastRouteDispatcher.php`
- **名前空間**: `Slim\Routing`
- **親クラス**: `FastRoute\Dispatcher\GroupCountBased`

`FastRouteDispatcher` は Nikic FastRoute の `FastRoute\Dispatcher\GroupCountBased` を継承し、`HEAD` リクエスト時の `GET` ルートへの自動フォールバック、ワイルドカード `*` メソッドへのフォールバック、および URI 単位での許可 HTTP メソッド一覧のキャッシュ付き抽出といった Slim 固有のディスパッチ仕様を実装します。

```drawlib align=center code=fold file=routing_dispatch_flow_ja.png caption="FastRouteDispatcher::dispatch() — 多段マッチングとフォールバック判定パイプライン"
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
text((30, 60.5), "1. メソッド完全一致", style=Styles.WhiteBold.patch(text_size=11.0))
text((30, 55.0), "staticRouteMap[M]", style=Styles.White.patch(text_size=10.0))
text((30, 50.0), "variableRouteData[M]", style=Styles.White.patch(text_size=10.0))

# Stage 2: HEAD -> GET Fallback
rectangle(
    (90, 56),
    width=44,
    height=18,
    style=Styles.PrimaryNeutral.patch(shape_r=2.5),
)
text((90, 60.5), "2. HEAD フォールバック", style=Styles.BlackBold.patch(text_size=11.0))
text((90, 55.0), "method == 'HEAD' の場合", style=Styles.Dark.patch(text_size=10.0))
text((90, 50.0), "'GET' で再検索", style=Styles.Dark.patch(text_size=10.0))

# Stage 3: Wildcard '*' Fallback
rectangle(
    (150, 56),
    width=44,
    height=18,
    style=Styles.SecondaryNeutral.patch(shape_r=2.5),
)
text((150, 60.5), "3. ワイルドカード '*'", style=Styles.BlackBold.patch(text_size=11.0))
text((150, 55.0), "routingResults('*', uri)", style=Styles.Dark.patch(text_size=10.0))
text((150, 50.0), "フォールバックルート検索", style=Styles.Dark.patch(text_size=10.0))

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
text((60, 59.5), "不一致", style=Styles.Primary.patch(text_size=10.0))

line((112, 56), (128, 56), arrow_head="->", style=Styles.PrimaryBold)
text((120, 59.5), "不一致", style=Styles.Primary.patch(text_size=10.0))

# Match & Fallback arrows to outcomes
line((30, 47), (30, 26), arrow_head="->", style=Styles.PrimaryBold)
text((20, 36.5), "一致", style=Styles.PrimaryBold.patch(text_size=10.0))

line((80, 47), (46, 26), arrow_head="->", style=Styles.PrimaryBold)
line((140, 47), (56, 26), arrow_head="->", style=Styles.PrimaryBold)

line((150, 47), (104, 26), arrow_head="->", style=Styles.PrimaryBold)
line((156, 47), (156, 26), arrow_head="->", style=Styles.PrimaryBold)
text((166, 36.5), "URI未登録", style=Styles.Dark.patch(text_size=10.0))

save()
```

### クラスシグネチャ

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

### プロパティ

| プロパティ | 型 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `$allowedMethodsUri` | `?string` | `private` | `getAllowedMethods()` が直前に検査した URI（単一エントリメモ化用）。 |
| `$allowedMethods` | `string[]` | `private` | `$allowedMethodsUri` に対してキャッシュされた許可 HTTP メソッド配列。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `dispatch` | `string $httpMethod`, `string $uri` | `array{int, string\|null, array<string, string>}` | `$httpMethod` の完全一致、`HEAD` 時の `'GET'` フォールバック、`'*'` フォールバックを順に試行し、いずれも不一致の場合は `getAllowedMethods($uri)` の有無で `METHOD_NOT_ALLOWED` と `NOT_FOUND` を判定します。 |
| `routingResults` *(private)* | `string $httpMethod`, `string $uri` | `array{int, string\|null, array<string, string>}` | `$this->staticRouteMap[$httpMethod][$uri]` を検索し、なければ `$this->variableRouteData[$httpMethod]` に対して正規表現ディスパッチを実行します。 |
| `getAllowedMethods` | `string $uri` | `string[]` | `$staticRouteMap` と `$variableRouteData` の全 HTTP メソッドを走査して `$uri` にマッチするメソッドを重複排除・キャッシュして返します。 |

### 使用例

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

// HEAD リクエストは自動的に GET ルートへフォールバックされます:
[$status, $routeId, $vars] = $dispatcher->dispatch('HEAD', '/items/42');
```

---

## `class` Slim\Routing\RoutingResults

- **ソースファイル**: `Slim/Routing/RoutingResults.php`
- **名前空間**: `Slim\Routing`

`RoutingResults` は、[`Dispatcher`](#slim-routing-dispatcher) による HTTP メソッドと URI のディスパッチ結果を保持するクラスです。ステータス定数（`NOT_FOUND`、`FOUND`、`METHOD_NOT_ALLOWED`）、マッチしたルート識別子、抽出されたルート引数を保持し、[`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) への参照を通じて許可 HTTP メソッド一覧の遅延取得を提供します。

### クラスシグネチャ

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

### 定数とプロパティ

| 定数 / プロパティ | 型 / 値 | 可視性 | 説明 |
| :--- | :--- | :--- | :--- |
| `NOT_FOUND` | `0` | `public const` | リクエスト URI に一致するルートパターンが存在しない状態（`404 Not Found`）。 |
| `FOUND` | `1` | `public const` | URI パターンと HTTP メソッドの双方が登録ルートに一致した状態（`200 OK`）。 |
| `METHOD_NOT_ALLOWED` | `2` | `public const` | URI パターンに一致するルートは存在するが、リクエストされた HTTP メソッドが許可されていない状態（`405 Method Not Allowed`）。 |
| `$dispatcher` | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | `protected` | `405` 応答や `OPTIONS` リクエスト時に許可メソッド一覧を問い合わせるディスパッチャ。 |
| `$method` | `string` | `protected` | ディスパッチされた HTTP メソッド文字列。 |
| `$uri` | `string` | `protected` | URL デコード済みのディスパッチ対象 URI パス。 |
| `$routeStatus` | `int` | `protected` | ディスパッチステータス（`RoutingResults::NOT_FOUND`, `FOUND`, `METHOD_NOT_ALLOWED`）。 |
| `$routeIdentifier` | `?string` | `protected` | マッチした内部ルート識別子（`'route0'` など。未マッチ時は `null`）。 |
| `$routeArguments` | `array<string, string>` | `protected` | URI パスから抽出されたプレースホルダ引数の連想配列。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `DispatcherInterface $dispatcher`, `string $method`, `string $uri`, `int $routeStatus`, `?string $routeIdentifier = null`, `array<string, string> $routeArguments = []` | `void` | ディスパッチ結果の詳細を保持してインスタンスを初期化します。 |
| `getDispatcher` | *(なし)* | [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | 紐づけられた [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) を返します。 |
| `getMethod` | *(なし)* | `string` | ディスパッチされた HTTP リクエストメソッドを返します。 |
| `getUri` | *(なし)* | `string` | ディスパッチされたデコード済み URI パスを返します。 |
| `getRouteStatus` | *(なし)* | `int` | `RoutingResults::NOT_FOUND` (`0`), `FOUND` (`1`), `METHOD_NOT_ALLOWED` (`2`) のいずれかを返します。 |
| `getRouteIdentifier` | *(なし)* | `?string` | マッチしたルート識別子または `null` を返します。 |
| `getRouteArguments` | `bool $urlDecode = true` | `array<string, string>` | 抽出されたルート引数の連想配列を返します（`RouteResolver` で既にデコード済みのため、`$urlDecode` 引数は後方互換性のためにのみ残されています）。 |
| `getAllowedMethods` | *(なし)* | `string[]` | `$this->dispatcher->getAllowedMethods($this->uri)` に委譲し、対象 URI で許可されている全 HTTP メソッドを返します。 |

### 使用例

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Routing\RouteContext;
use Slim\Routing\RoutingResults;

// カスタム CORS プリフライトミドルウェア内で RoutingResults を参照する例
$routingResults = RouteContext::fromRequest($request)->getRoutingResults();

if ($routingResults->getRouteStatus() === RoutingResults::FOUND) {
    $allowedMethods = $routingResults->getAllowedMethods();
    $response = $response->withHeader('Allow', implode(', ', $allowedMethods));
}
```
