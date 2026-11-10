# 契約インターフェース (`Slim\Interfaces\*`)

`Slim\Interfaces` 名前空間（`Slim/Interfaces/` 配下の全 `17` ファイル・`17` インターフェース）は、Slim Framework `v4.15.3` の全サブシステムを疎結合化するアーキテクチャ契約群を定義します。PSR-17 ファクトリ自動検出、PSR-11 コンテナ連携の Callable 解決、LIFO 順の PSR-15 ミドルウェアディスパッチ、FastRoute による正規表現ルーティング、ルート呼び出しストラテジ、およびコンテンツネゴシエーション対応のエラー描画のすべてがインターフェース背後に抽象化されており、[`AppFactory`](01_app_and_factories.md#slim-app) または DI コンテナを通じて任意のカスタム実装へ差し替えることができます。

```drawlib align=center code=fold file=api_interfaces_domain_map_ja.png caption="Slim\Interfaces 全 17 契約インターフェースの体系 — ルーティング・PSR-17・ミドルウェア・ストラテジ・エラー処理"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=90, dpi=150)

# Left Panel: Routing & FastRoute Dispatching Contracts (7 Interfaces)
p_left = Panel(
    "ルーティング・ディスパッチ契約 (7 種)",
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
    "HTTP メソッド別のルート登録 (get/post/map/group)",
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
    "ルート／グループ単位のミドルウェアと run()",
    badge_text="R2",
    icon=phosphor.brackets_curly,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "RouteParserInterface",
    "名前付きルートからの逆引き URL 生成 (urlFor)",
    badge_text="R3",
    icon=phosphor.link,
)
cl_left.add(
    "RouteResolver & DispatcherInterface",
    "FastRoute URI 照合 -> RoutingResults 返却",
    badge_text="R4",
    icon=phosphor.lightning,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: PSR-17, Callable, Middleware & Error Contracts (10 Interfaces)
p_right = Panel(
    "PSR-17・Callable・ミドルウェア・エラー契約 (10 種)",
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
    "Psr17Factory・Provider・RequestCreator",
    "PSR-17 ファクトリ自動検出と SAPI リクエスト生成",
    badge_text="P17",
    icon=phosphor.factory,
)
cl_right.add(
    "CallableResolver & AdvancedCallable",
    "'Class:method' 表記および DI サービスの解決",
    badge_text="DI",
    icon=phosphor.code,
    style=Styles.PrimaryNeutral,
)
cl_right.add(
    "MiddlewareDispatcher & Strategies",
    "LIFO 型 PSR-15 スタックと 2 種の呼び出し契約",
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
    "例外 -> PSR-7 レスポンス変換と MIME 文字列描画",
    badge_text="Err",
    icon=phosphor.shield_warning,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_right.draw(xy=rx, width=rw, height=rh)

save()
```

### `Slim\Interfaces\*` 全 17 インターフェース一覧表

| インターフェース | ソースファイル | 継承元 (`extends`) | 既定の実装クラス |
| :--- | :--- | :--- | :--- |
| [`AdvancedCallableResolverInterface`](#slim-interfaces-advancedcallableresolverinterface) | `Slim/Interfaces/AdvancedCallableResolverInterface.php` | [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) |
| [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | `Slim/Interfaces/CallableResolverInterface.php` | — | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) |
| [`DispatcherInterface`](#slim-interfaces-dispatcherinterface) | `Slim/Interfaces/DispatcherInterface.php` | — | [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) |
| [`ErrorHandlerInterface`](#slim-interfaces-errorhandlerinterface) | `Slim/Interfaces/ErrorHandlerInterface.php` | — | [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) |
| [`ErrorRendererInterface`](#slim-interfaces-errorrendererinterface) | `Slim/Interfaces/ErrorRendererInterface.php` | — | [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer), [`JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer), `HtmlErrorRenderer`, `PlainTextErrorRenderer`, `XmlErrorRenderer` |
| [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | `Slim/Interfaces/InvocationStrategyInterface.php` | — | [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse), `RequestResponseArgs`, `RequestResponseNamedArgs`, [`RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) |
| [`MiddlewareDispatcherInterface`](#slim-interfaces-middlewaredispatcherinterface) | `Slim/Interfaces/MiddlewareDispatcherInterface.php` | `Psr\Http\Server\RequestHandlerInterface` | [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) |
| [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) | `Slim/Interfaces/Psr17FactoryInterface.php` | — | [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory)（および具象プロバイダ 6 種） |
| [`Psr17FactoryProviderInterface`](#slim-interfaces-psr17factoryproviderinterface) | `Slim/Interfaces/Psr17FactoryProviderInterface.php` | — | [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) |
| [`RequestHandlerInvocationStrategyInterface`](#slim-interfaces-requesthandlerinvocationstrategyinterface) | `Slim/Interfaces/RequestHandlerInvocationStrategyInterface.php` | [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) |
| [`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) | `Slim/Interfaces/RouteCollectorInterface.php` | — | [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) |
| [`RouteCollectorProxyInterface`](#slim-interfaces-routecollectorproxyinterface) | `Slim/Interfaces/RouteCollectorProxyInterface.php` | — | [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app) |
| [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | `Slim/Interfaces/RouteGroupInterface.php` | — | [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) |
| [`RouteInterface`](#slim-interfaces-routeinterface) | `Slim/Interfaces/RouteInterface.php` | — | [`Slim\Routing\Route`](03_routing.md#slim-routing-route) |
| [`RouteParserInterface`](#slim-interfaces-routeparserinterface) | `Slim/Interfaces/RouteParserInterface.php` | — | [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) |
| [`RouteResolverInterface`](#slim-interfaces-routeresolverinterface) | `Slim/Interfaces/RouteResolverInterface.php` | — | [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) |
| [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) | `Slim/Interfaces/ServerRequestCreatorInterface.php` | — | `Slim\Factory\Psr17\ServerRequestCreator`, `SlimHttpServerRequestCreator` |

```drawlib align=center code=fold file=api_interfaces_wiring_lifecycle_ja.png caption="契約インターフェースの継承関係と Slim\App コンストラクタにおける既定実装の配線"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=84, dpi=150)

# Left Panel: 3 Specialized Sub-Interface Extensions
p_left = Panel(
    "サブインターフェース拡張ペア (3 組)",
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
    "PSR-15 RequestHandlerInterface を継承",
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
    "CallableResolverInterface を拡張 (+2 メソッド)",
    badge_text="DI",
    icon=phosphor.plugs_connected,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "RequestHandlerInvocationStrategy",
    "InvocationStrategyInterface のマーカー拡張",
    badge_text="Tag",
    icon=phosphor.tag,
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: Default Kernel Wiring in App::__construct()
p_right = Panel(
    "App::__construct() の既定実装配線",
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
    "省略時は new CallableResolver(container) を生成",
    badge_text="W1",
    icon=phosphor.code,
)
cl_right.add(
    "RouteCollector & RouteResolverInterface",
    "省略時は RouteCollector + RouteResolver を生成",
    badge_text="W2",
    icon=phosphor.compass,
    style=Styles.SecondaryNeutral,
)
cl_right.add(
    "MiddlewareDispatcherInterface",
    "RouteRunner を核として PSR-15 オニオンを構成",
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

- **ソースファイル**: `Slim/Interfaces/AdvancedCallableResolverInterface.php`
- **名前空間**: `Slim\Interfaces`
- **継承元 (`extends`)**: [`Slim\Interfaces\CallableResolverInterface`](#slim-interfaces-callableresolverinterface)
- **既定実装クラス**: [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver)
- **主な参照元**: [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher), [`Slim\Routing\Route`](03_routing.md#slim-routing-route), [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup), [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware), [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)

[`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) を拡張し、呼び出し文脈に応じた解決メソッド（`resolveRoute()` および `resolveMiddleware()`）を追加する契約です。`:method` サフィックスを持たない単一のクラス名やコンテナサービス ID が渡された際、[`CallableResolver`](01_app_and_factories.md#slim-callableresolver) は `resolveRoute()` では PSR-15 `RequestHandlerInterface::handle` を、`resolveMiddleware()` では PSR-15 `MiddlewareInterface::process` を優先的にバインドします。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `resolveRoute()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | ルートハンドラ定義を PHP `callable` へ解決します（PSR-15 `RequestHandlerInterface` インスタンスの場合は `[$instance, 'handle']` へ変換）。 |
| `resolveMiddleware()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | ミドルウェア定義を PHP `callable` へ解決します（PSR-15 `MiddlewareInterface` インスタンスの場合は `[$instance, 'process']` へ変換）。 |
| `resolve()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) から継承。 |

### 使用例

```php
use Slim\CallableResolver;
use Slim\Interfaces\AdvancedCallableResolverInterface;

/** @var AdvancedCallableResolverInterface $resolver */
$resolver = new CallableResolver($container);

// PSR-15 RequestHandlerInterface 実装クラス名を [$instance, 'handle'] へ解決:
$routeCallable = $resolver->resolveRoute(ShowUserAction::class);

// PSR-15 MiddlewareInterface 実装クラス名を [$instance, 'process'] へ解決:
$middlewareCallable = $resolver->resolveMiddleware(AuthMiddleware::class);
```

---

## `interface` Slim\Interfaces\CallableResolverInterface

- **ソースファイル**: `Slim/Interfaces/CallableResolverInterface.php`
- **名前空間**: `Slim\Interfaces`
- **拡張先サブインターフェース**: [`Slim\Interfaces\AdvancedCallableResolverInterface`](#slim-interfaces-advancedcallableresolverinterface)
- **既定実装クラス**: [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver)

文字列記法（`'Class:method'`、`'Class::method'`、または PSR-11 コンテナのサービス識別子）、`['Class', 'method']` 配列、または `__invoke()` を実装したクラスを実行可能な PHP `callable` へ解決する基底契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `resolve()` | `callable\|array{class-string, string}\|string $toResolve` | `callable` | `$toResolve` を実行可能な `callable` に解決します。解決不能な場合は `\RuntimeException` を送出します。 |

### 使用例

```php
use Slim\CallableResolver;
use Slim\Interfaces\CallableResolverInterface;

/** @var CallableResolverInterface $resolver */
$resolver = new CallableResolver($container);

// Slim 固有の 'Class:method' 表記を DI コンテナまたは new HomeController() で解決:
$callable = $resolver->resolve('App\Controller\HomeController:index');
```

---

## `interface` Slim\Interfaces\DispatcherInterface

- **ソースファイル**: `Slim/Interfaces/DispatcherInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher)
- **主な参照元**: [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver), `Slim\Routing\RoutingResults`

内部の URL ルーティングエンジン（FastRoute の `FastRouteDispatcher`）をラップし、HTTP メソッドと URI パスの照合結果（`Slim\Routing\RoutingResults`）および対象 URI で許可されている HTTP メソッド一覧を返す契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `dispatch()` | `string $method`, `string $uri` | `RoutingResults` | 登録済みルートに対して `$method` と `$uri` を照合し、`RoutingResults`（`NOT_FOUND` / `FOUND` / `METHOD_NOT_ALLOWED`）を返します。 |
| `getAllowedMethods()` | `string $uri` | `string[]` | 指定した `$uri` パターンに対して登録されている重複排除済みの HTTP メソッド配列を返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Interfaces/ErrorHandlerInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)
- **主な参照元**: [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware)

[`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) に登録される例外ハンドラの呼び出し契約です。捕捉された `\Throwable`、発生時の PSR-7 `ServerRequestInterface`、および 3 つの詳細表示・ログ出力フラグを受け取り、エラー応答となる PSR-7 `ResponseInterface` を返します。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `ServerRequestInterface $request`, `Throwable $exception`, `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails` | `ResponseInterface` | `$exception` を処理し（`$logErrors` が `true` の場合はログ出力、`$displayErrorDetails` が `true` の場合は詳細情報を含めて）、PSR-7 `ResponseInterface` を返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Interfaces/ErrorRendererInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer), [`Slim\Error\Renderers\JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer), `Slim\Error\Renderers\HtmlErrorRenderer`, `Slim\Error\Renderers\PlainTextErrorRenderer`, `Slim\Error\Renderers\XmlErrorRenderer`
- **主な参照元**: [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)

[`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) の `Accept` ヘッダ交渉によって選択されたメディアタイプ（HTML・JSON・XML・PlainText 等）に応じ、捕捉された `\Throwable` をレスポンスボディ文字列へ変換する契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | `$exception` をシリアライズした文字列を返します（`$displayErrorDetails` が `true` の場合のみ例外メッセージとスタックトレースを展開）。 |

### 使用例

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

- **ソースファイル**: `Slim/Interfaces/InvocationStrategyInterface.php`
- **名前空間**: `Slim\Interfaces`
- **拡張先サブインターフェース**: [`Slim\Interfaces\RequestHandlerInvocationStrategyInterface`](#slim-interfaces-requesthandlerinvocationstrategyinterface)
- **既定実装クラス**: [`Slim\Handlers\Strategies\RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) *(既定)*, `Slim\Handlers\Strategies\RequestResponseArgs`, `Slim\Handlers\Strategies\RequestResponseNamedArgs`, [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler)
- **主な参照元**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

マッチしたルートの callable を、PSR-7 の `ServerRequestInterface`、`ResponseInterface`、および FastRoute が抽出した URI プレースホルダ引数配列（`array<string, string>`）を用いて呼び出すストラテジ契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | ストラテジ固有の引数展開規則で `$callable` を実行し、生成された PSR-7 `ResponseInterface` を返します。 |

### 使用例

```php
use Slim\Handlers\Strategies\RequestResponseArgs;

// ルート引数を位置引数 function ($request, $response, $id, $slug) として展開するストラテジに変更:
$routeCollector = $app->getRouteCollector();
$routeCollector->setDefaultInvocationStrategy(new RequestResponseArgs());
```

---

## `interface` Slim\Interfaces\MiddlewareDispatcherInterface

- **ソースファイル**: `Slim/Interfaces/MiddlewareDispatcherInterface.php`
- **名前空間**: `Slim\Interfaces`
- **継承元 (`extends`)**: `Psr\Http\Server\RequestHandlerInterface`
- **既定実装クラス**: [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher)
- **主な参照元**: [`Slim\App`](01_app_and_factories.md#slim-app), `Slim\Factory\AppFactory`, [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

Slim の Last-In-First-Out（LIFO：後入れ先出し）同心円状 PSR-15 ミドルウェアスタックを管理する契約です。`Psr\Http\Server\RequestHandlerInterface` を継承しているため、すべての実装は `handle(ServerRequestInterface $request): ResponseInterface` も提供します。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `add()` | `MiddlewareInterface\|string\|callable $middleware` | `self` | PSR-15 `MiddlewareInterface`、callable、または遅延解決されるクラス名／コンテナ ID を LIFO スタックの最外層へ追加します。 |
| `addMiddleware()` | `MiddlewareInterface $middleware` | `self` | 型付きの PSR-15 `MiddlewareInterface` インスタンスを LIFO スタックの最外層へ追加します。 |
| `seedMiddlewareStack()` | `RequestHandlerInterface $kernel` | `void` | ミドルウェアスタックの最内殻（カーネル）を `$kernel`（`RouteRunner` や `Route`）で初期化します。 |
| `handle()` | `ServerRequestInterface $request` | `ResponseInterface` | `Psr\Http\Server\RequestHandlerInterface` から継承。スタック最外層の `$tip` を実行します。 |

### 使用例

```php
use Slim\Interfaces\MiddlewareDispatcherInterface;

/** @var MiddlewareDispatcherInterface $dispatcher */
$dispatcher = $app->getMiddlewareDispatcher();
$dispatcher->add(CorrelationIdMiddleware::class);
```

---

## `interface` Slim\Interfaces\Psr17FactoryInterface

- **ソースファイル**: `Slim/Interfaces/Psr17FactoryInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定基底実装クラス**: [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory)（`SlimPsr17Factory`, `HttpSoftPsr17Factory`, `NyholmPsr17Factory`, `LaminasDiactorosPsr17Factory`, `GuzzlePsr17Factory`, `SlimHttpPsr17Factory` が継承）
- **主な参照元**: `Slim\Factory\AppFactory`, `Slim\Factory\ServerRequestCreatorFactory`

ゼロ設定ブートストラップ時に各 PSR-7 / PSR-17 実装パッケージがインストール済みかどうかを検査し（`isResponseFactoryAvailable()`, `isStreamFactoryAvailable()`, `isServerRequestCreatorAvailable()`）、対応する `ResponseFactoryInterface`、`StreamFactoryInterface`、[`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) を生成する静的アダプタ契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `getResponseFactory()` | *(なし・static)* | `ResponseFactoryInterface` | プロバイダの PSR-17 `ResponseFactoryInterface` を生成して返します（生成不能時は `\RuntimeException`）。 |
| `getStreamFactory()` | *(なし・static)* | `StreamFactoryInterface` | プロバイダの PSR-17 `StreamFactoryInterface` を生成して返します（生成不能時は `\RuntimeException`）。 |
| `getServerRequestCreator()` | *(なし・static)* | [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) | プロバイダの [`ServerRequestCreatorInterface`](#slim-interfaces-serverrequestcreatorinterface) を生成して返します（生成不能時は `\RuntimeException`）。 |
| `isResponseFactoryAvailable()` | *(なし・static)* | `bool` | レスポンスファクトリクラスがオートロード可能であれば `true` を返します。 |
| `isStreamFactoryAvailable()` | *(なし・static)* | `bool` | ストリームファクトリクラスがオートロード可能であれば `true` を返します。 |
| `isServerRequestCreatorAvailable()` | *(なし・static)* | `bool` | サーバリクエスト生成クラスおよびメソッドが利用可能であれば `true` を返します。 |

### 使用例

```php
use Slim\Factory\Psr17\NyholmPsr17Factory;

if (NyholmPsr17Factory::isResponseFactoryAvailable()) {
    $responseFactory = NyholmPsr17Factory::getResponseFactory();
}
```

---

## `interface` Slim\Interfaces\Psr17FactoryProviderInterface

- **ソースファイル**: `Slim/Interfaces/Psr17FactoryProviderInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider)
- **主な参照元**: `Slim\Factory\AppFactory`, `Slim\Factory\ServerRequestCreatorFactory`

`AppFactory::determineResponseFactory()` および `ServerRequestCreatorFactory::determineServerRequestCreator()` が自動探索する [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) 実装クラス名の優先順位リストを管理するレジストリ契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `getFactories()` | *(なし・static)* | `string[]` | 登録されている [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) クラス名配列を優先順で返します。 |
| `setFactories()` | `string[] $factories` *(static)* | `void` | PSR-17 ファクトリアダプタクラス名の配列全体を置き換えます。 |
| `addFactory()` | `string $factory` *(static)* | `void` | カスタム [`Psr17FactoryInterface`](#slim-interfaces-psr17factoryinterface) クラス名を探索リストの先頭（最優先）へ追加します。 |

### 使用例

```php
use Slim\Factory\Psr17\Psr17FactoryProvider;

// カスタム PSR-17 ファクトリアダプタを最優先として先頭登録:
Psr17FactoryProvider::addFactory(CustomPsr17Factory::class);
```

---

## `interface` Slim\Interfaces\RequestHandlerInvocationStrategyInterface

- **ソースファイル**: `Slim/Interfaces/RequestHandlerInvocationStrategyInterface.php`
- **名前空間**: `Slim\Interfaces`
- **継承元 (`extends`)**: [`Slim\Interfaces\InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface)
- **既定実装クラス**: [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler)

PSR-15 の `RequestHandlerInterface` シグネチャ（`callable(ServerRequestInterface): ResponseInterface`）でルートハンドラを直接呼び出すストラテジを表すマーカーサブインターフェースです。

### PHP インターフェースシグネチャ

```php
<?php

declare(strict_types=1);

namespace Slim\Interfaces;

interface RequestHandlerInvocationStrategyInterface extends InvocationStrategyInterface
{
}
```

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke()` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) から継承。 |

### 使用例

```php
use Slim\Handlers\Strategies\RequestHandler;
use Slim\Interfaces\RequestHandlerInvocationStrategyInterface;

/** @var RequestHandlerInvocationStrategyInterface $strategy */
$strategy = new RequestHandler(true); // ルート引数を Request 属性として注入
$app->getRouteCollector()->setDefaultInvocationStrategy($strategy);
```

---

## `interface` Slim\Interfaces\RouteCollectorInterface

- **ソースファイル**: `Slim/Interfaces/RouteCollectorInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector)
- **主な参照元**: [`Slim\App`](01_app_and_factories.md#slim-app), [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher), [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser), [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver)

[`RouteInterface`](#slim-interfaces-routeinterface) および [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) の登録・保持、既定の [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) の管理、FastRoute キャッシュファイルの設定、およびルート名・内部識別子（`route0`, `route1`, ...）による検索を担う中央ルートレジストリ契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `getRouteParser()` | *(なし)* | [`RouteParserInterface`](#slim-interfaces-routeparserinterface) | 逆引き URL 生成用のルートパーサを返します。 |
| `getDefaultInvocationStrategy()` | *(なし)* | [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface) | 既定の呼び出しストラテジ（初期値は [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse)）を返します。 |
| `setDefaultInvocationStrategy()` | `InvocationStrategyInterface $strategy` | `RouteCollectorInterface` | 新規登録ルートに適用される既定の呼び出しストラテジを設定します。 |
| `getCacheFile()` | *(なし)* | `?string` | FastRoute のディスパッチキャッシュファイルパス（未設定時は `null`）を返します。 |
| `setCacheFile()` | `string $cacheFile` | `RouteCollectorInterface` | FastRoute キャッシュファイルのパスを設定します（読み書き権限を検証）。 |
| `getBasePath()` / `setBasePath()` | `string $basePath` | `string` / `RouteCollectorInterface` | アプリケーションのベースパスを取得・設定します。 |
| `getRoutes()` | *(なし)* | `RouteInterface[]` | 登録済みすべての [`RouteInterface`](#slim-interfaces-routeinterface) 配列を返します。 |
| `getNamedRoute()` | `string $name` | [`RouteInterface`](#slim-interfaces-routeinterface) | 指定したルート名の [`RouteInterface`](#slim-interfaces-routeinterface) を返します（未登録時は `\RuntimeException`）。 |
| `removeNamedRoute()` | `string $name` | `RouteCollectorInterface` | 指定した名前付きルートを削除します（未登録時は `\RuntimeException`）。 |
| `lookupRoute()` | `string $identifier` | [`RouteInterface`](#slim-interfaces-routeinterface) | 内部識別子（`'route0'` 等）から [`RouteInterface`](#slim-interfaces-routeinterface) を検索します。 |
| `group()` | `string $pattern`, `string\|callable $callable` | [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | 共通プレフィックス `$pattern` を持つルートグループを生成します。 |
| `map()` | `string[] $methods`, `string $pattern`, `callable\|array\|string $handler` | [`RouteInterface`](#slim-interfaces-routeinterface) | 指定した HTTP メソッド配列とパターンに対するルートを登録して返します。 |

### 使用例

```php
$collector = $app->getRouteCollector();
$collector->setCacheFile(__DIR__ . '/../var/cache/fastroute.php');

$route = $collector->getNamedRoute('users.show');
```

---

## `interface` Slim\Interfaces\RouteCollectorProxyInterface

- **ソースファイル**: `Slim/Interfaces/RouteCollectorProxyInterface.php`
- **名前空間**: `Slim\Interfaces`
- **ジェネリクス型注釈**: `@template TContainerInterface of (ContainerInterface|null)`
- **既定実装クラス**: [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app)

[`Slim\App`](01_app_and_factories.md#slim-app) およびルートグループのコールバック引数（`$app->group('/v1', function (RouteCollectorProxyInterface $group) { ... })`）が共通実装する、利用者向けのルーティング登録ファサード契約です。HTTP メソッド別の短縮メソッド（`get()`, `post()`, `put()`, `patch()`, `delete()`, `options()`, `any()`）、`map()`、`group()`、`redirect()` を提供します。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `getResponseFactory()` | *(なし)* | `ResponseFactoryInterface` | PSR-17 レスポンスファクトリを返します。 |
| `getCallableResolver()` | *(なし)* | [`CallableResolverInterface`](#slim-interfaces-callableresolverinterface) | Callable リゾルバを返します。 |
| `getContainer()` | *(なし)* | `?ContainerInterface` | PSR-11 コンテナインスタンス（未設定時は `null`）を返します。 |
| `getRouteCollector()` | *(なし)* | [`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) | 内部のルートコレクタを返します。 |
| `getBasePath()` / `setBasePath()` | `string $basePath` | `string` / `RouteCollectorProxyInterface` | ベースパスを取得・設定します。 |
| `get()` / `post()` / `put()` / `patch()` / `delete()` / `options()` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | 対応する単一 HTTP メソッドのルートを登録します。 |
| `any()` | `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, `OPTIONS` のすべてに一致するルートを登録します。 |
| `map()` | `string[] $methods`, `string $pattern`, `callable\|array\|string $callable` | [`RouteInterface`](#slim-interfaces-routeinterface) | 任意の HTTP メソッド配列に対するルートを登録します。 |
| `group()` | `string $pattern`, `string\|callable $callable` | [`RouteGroupInterface`](#slim-interfaces-routegroupinterface) | 共通 URI プレフィックスとミドルウェアを共有するルートグループを登録します。 |
| `redirect()` | `string $from`, `string\|UriInterface $to`, `int $status = 302` | [`RouteInterface`](#slim-interfaces-routeinterface) | `Location` ヘッダによる HTTP リダイレクト応答を返す `GET` ルートを登録します（既定ステータス `302`）。 |

### 使用例

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

- **ソースファイル**: `Slim/Interfaces/RouteGroupInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup)
- **主な参照元**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), [`Slim\Routing\Route`](03_routing.md#slim-routing-route)

`RouteCollectorProxyInterface::group()` が返すルートグループの契約です。`add()` / `addMiddleware()` によるグループ単位の PSR-15 ミドルウェア登録と、ルート実行時にそれらのミドルウェアを [`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) へ連結する `appendMiddlewareToDispatcher()` を定義します。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `collectRoutes()` | *(なし)* | `RouteGroupInterface` | グループコールバックを解決・実行し、グループ内のルート群を登録します。 |
| `add()` | `MiddlewareInterface\|string\|callable $middleware` | `RouteGroupInterface` | グループにミドルウェア（インスタンス、callable、またはクラス名／サービス ID）を追加します。 |
| `addMiddleware()` | `MiddlewareInterface $middleware` | `RouteGroupInterface` | 型付きの PSR-15 `MiddlewareInterface` インスタンスをグループに追加します。 |
| `appendMiddlewareToDispatcher()` | `MiddlewareDispatcher $dispatcher` | `RouteGroupInterface` | グループに登録されたすべてのミドルウェアを `$dispatcher` へ追加します。 |
| `getPattern()` | *(なし)* | `string` | ルートグループの URI プレフィックスパターンを返します。 |

### 使用例

```php
$app->group('/admin', function ($group): void {
    $group->get('/audit-logs', AuditLogAction::class);
})->add(AdminRoleMiddleware::class);
```

---

## `interface` Slim\Interfaces\RouteInterface

- **ソースファイル**: `Slim/Interfaces/RouteInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\Route`](03_routing.md#slim-routing-route)
- **主な参照元**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), `Slim\Routing\RouteRunner`, `Slim\Routing\RouteContext`

個々のルート定義を表す契約です。許可された HTTP メソッド配列、URI パターン、ルートハンドラ、ルート名、内部識別子、抽出された URI パラメータ、ルート固有の [`InvocationStrategyInterface`](#slim-interfaces-invocationstrategyinterface)、および `run(ServerRequestInterface $request)` で実行されるルート固有の PSR-15 ミドルウェアスタックをカプセル化します。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `getInvocationStrategy()` / `setInvocationStrategy()` | `InvocationStrategyInterface $invocationStrategy` | `InvocationStrategyInterface` / `RouteInterface` | このルート固有の呼び出しストラテジを取得・設定します。 |
| `getMethods()` | *(なし)* | `string[]` | このルートで許可されている HTTP メソッド配列を返します。 |
| `getPattern()` / `setPattern()` | `string $pattern` | `string` / `RouteInterface` | ルート URI パターンを取得・変更します。 |
| `getCallable()` / `setCallable()` | `callable\|array\|string $callable` | `callable\|array\|string` / `RouteInterface` | ルートハンドラを取得・変更します。 |
| `getName()` / `setName()` | `string $name` | `?string` / `RouteInterface` | [`RouteParserInterface`](#slim-interfaces-routeparserinterface) が参照するルート名を取得・設定します。 |
| `getIdentifier()` | *(なし)* | `string` | 一意の内部ルート識別子（`'route0'` 等）を返します。 |
| `getArgument()` | `string $name`, `?string $default = null` | `?string` | 単一の URI プレースホルダ引数を取得します。 |
| `getArguments()` | *(なし)* | `array<string, string>` | マッチしたすべての URI プレースホルダ引数配列を返します。 |
| `setArgument()` / `setArguments()` | `string $name, string $value` / `array $arguments` | `RouteInterface` / `self` | **`4.14.1` 以降非推奨（`@deprecated`）**（カスタム属性にはミドルウェア内の PSR-7 リクエスト属性を使用）。 |
| `add()` / `addMiddleware()` | `MiddlewareInterface\|string\|callable $middleware` | `self` | このルート固有のローカルスタックへミドルウェアを追加します。 |
| `prepare()` | `array<string, string> $arguments` | `self` | 現在のリクエストサイクルで抽出されたルート引数をセットします。 |
| `run()` | `ServerRequestInterface $request` | `ResponseInterface` | 所属グループのミドルウェアを結合した上で、ルートのローカルミドルウェアスタックとハンドラを実行します。 |

### 使用例

```php
use Slim\Handlers\Strategies\RequestResponseArgs;

$app->get('/orders/{id:[0-9]+}', OrderController::class . ':show')
    ->setName('orders.show')
    ->setInvocationStrategy(new RequestResponseArgs())
    ->add(OrderOwnershipMiddleware::class);
```

---

## `interface` Slim\Interfaces\RouteParserInterface

- **ソースファイル**: `Slim/Interfaces/RouteParserInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser)
- **主な参照元**: [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector), `Slim\Routing\RouteContext`, [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware)

名前付きルートから、ベースパスを除いた相対パス（`relativeUrlFor()`）、ベースパスを含む相対 URL（`urlFor()`）、およびスキームとホスト名を含む完全修飾 URL（`fullUrlFor()`）を逆引き生成する契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `relativeUrlFor()` | `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | ベースパスを**除いた**名前付きルートのパス文字列を生成します（未登録時は `\RuntimeException`、必須プレースホルダ不足時は `\InvalidArgumentException`）。 |
| `urlFor()` | `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | アプリケーションの `basePath` を**含む**名前付きルートの URL パスを生成します。 |
| `fullUrlFor()` | `UriInterface $uri`, `string $routeName`, `array<string, string> $data = []`, `array $queryParams = []` | `string` | `$uri` のスキームおよび Authority（ホスト・ポート）を付与した完全修飾 URL（`scheme://authority/path?query`）を生成します。 |

### 使用例

```php
use Slim\Routing\RouteContext;

$routeParser = RouteContext::fromRequest($request)->getRouteParser();

$relative = $routeParser->relativeUrlFor('orders.show', ['id' => '42']);
$path     = $routeParser->urlFor('orders.show', ['id' => '42'], ['expand' => 'items']);
$fullUrl  = $routeParser->fullUrlFor($request->getUri(), 'orders.show', ['id' => '42']);
```

---

## `interface` Slim\Interfaces\RouteResolverInterface

- **ソースファイル**: `Slim/Interfaces/RouteResolverInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver)
- **主な参照元**: [`Slim\App`](01_app_and_factories.md#slim-app), [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware), `Slim\Routing\RouteRunner`

[`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) と [`DispatcherInterface`](#slim-interfaces-dispatcherinterface)・[`RouteCollectorInterface`](#slim-interfaces-routecollectorinterface) の間を仲介し、リクエスト URI に対する `RoutingResults` の算出と、マッチしたルート識別子から [`RouteInterface`](#slim-interfaces-routeinterface) インスタンスへの解決を行う契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `computeRoutingResults()` | `string $uri`, `string $method` | `RoutingResults` | `$uri` を `rawurldecode()` した上で `DispatcherInterface::dispatch($method, $uri)` へ委譲し、`RoutingResults` を返します。 |
| `resolveRoute()` | `string $identifier` | [`RouteInterface`](#slim-interfaces-routeinterface) | `RouteCollectorInterface::lookupRoute($identifier)` を通じて対応する [`RouteInterface`](#slim-interfaces-routeinterface) を返します。 |

### 使用例

```php
$resolver = $app->getRouteResolver();
$results  = $resolver->computeRoutingResults('/users/42', 'GET');
$route    = $resolver->resolveRoute($results->getRouteIdentifier());
```

---

## `interface` Slim\Interfaces\ServerRequestCreatorInterface

- **ソースファイル**: `Slim/Interfaces/ServerRequestCreatorInterface.php`
- **名前空間**: `Slim\Interfaces`
- **既定実装クラス**: `Slim\Factory\Psr17\ServerRequestCreator`, `Slim\Factory\Psr17\SlimHttpServerRequestCreator`
- **主な参照元**: [`Slim\App::run()`](01_app_and_factories.md#slim-app), `Slim\Factory\ServerRequestCreatorFactory`

[`App::run()`](01_app_and_factories.md#slim-app) が引数なしで呼び出された際に、PHP の SAPI スーパーグローバル変数群（`$_SERVER`, `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES`）から PSR-7 `ServerRequestInterface` インスタンスを生成する契約です。

### PHP インターフェースシグネチャ

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

### メソッド・引数一覧

| メソッド | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- |
| `createServerRequestFromGlobals()` | *(なし)* | `ServerRequestInterface` | 現在の PHP SAPI グローバル環境から PSR-7 `ServerRequestInterface` を構築して返します。 |

### 使用例

```php
use Slim\Factory\ServerRequestCreatorFactory;

$creator = ServerRequestCreatorFactory::create();
$request = $creator->createServerRequestFromGlobals();
$app->run($request);
```
