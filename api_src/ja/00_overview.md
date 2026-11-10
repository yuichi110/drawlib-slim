# Slim 4 パッケージ・名前空間概要

**Slim Framework `v4.15.3`**（`slim/slim`）の完全 API リファレンスカタログ（非公式）です。9 つの PSR-4 名前空間に属する **全 72 ファイル（55 具象・抽象クラス / 17 インターフェース）** について、正確な PHP 型シグネチャ、コンストラクタ・メソッド引数テーブル、および PSR-7 / PSR-11 / PSR-15 / PSR-17 準拠の実践的なコード例を網羅しています。

```drawlib align=center code=fold file=slim_package_map_ja.png caption="Slim Framework v4.15.3 — 9 名前空間アーキテクチャ & パッケージ依存関係マップ（全 72 シンボル）"
from drawlib.canvas import save, setup
from drawlib.diagrams.architecture import ArchitectureDiagram, Node, NodeGroup, PhosphorIcon
from drawlib.styles import Styles

setup(width=148, height=82)

d = ArchitectureDiagram(
    node_style=Styles.Dark,
    node_text_style=Styles.DarkBold.patch(text_size=10.2),
    edge_style=Styles.Dark.patch(line_width=1.4),
    edge_text_style=Styles.Muted.patch(text_size=9.5),
    node_card_style=Styles.Neutral,
)

boot_grp = d.add(
    NodeGroup(
        "1. 起動・PSR-17 層 (12)",
        width=38,
        height=72,
        style=Styles.PrimaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(5, 5),
)
n_factory = boot_grp.add(
    Node(
        "Slim\\Factory\n(2 Classes)",
        icon=PhosphorIcon.FACTORY,
        width=30,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(19, 48),
)
n_psr17 = boot_grp.add(
    Node(
        "Slim\\Factory\\Psr17\n(10 Classes)",
        icon=PhosphorIcon.PLUGS_CONNECTED,
        width=30,
        height=17,
        card_style=Styles.Neutral,
    ),
    xy=(19, 18),
)

core_grp = d.add(
    NodeGroup(
        "2. コア・ルーティング層 (22)",
        width=42,
        height=72,
        style=Styles.SecondaryNeutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(53, 5),
)
n_root = core_grp.add(
    Node(
        "Slim\\ (Core)\n(5 Classes)",
        icon=PhosphorIcon.CPU,
        width=32,
        height=15,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.2),
        card_style=Styles.PrimaryFlat,
    ),
    xy=(21, 53),
)
n_mw = core_grp.add(
    Node(
        "Slim\\Middleware\n(6 Classes)",
        icon=PhosphorIcon.STACK,
        width=32,
        height=15,
        card_style=Styles.Neutral,
    ),
    xy=(21, 33),
)
n_routing = core_grp.add(
    Node(
        "Slim\\Routing\n(11 Classes)",
        icon=PhosphorIcon.GIT_BRANCH,
        width=32,
        height=15,
        card_style=Styles.Neutral,
    ),
    xy=(21, 13),
)

err_grp = d.add(
    NodeGroup(
        "3. ハンドラ・例外・契約層 (38)",
        width=38,
        height=72,
        style=Styles.Neutral,
        text_style=Styles.DarkBold.patch(text_size=10.8, halign="left", valign="top"),
    ),
    xy=(105, 5),
)
n_handlers = err_grp.add(
    Node(
        "Slim\\Handlers\n(5 Classes)",
        icon=PhosphorIcon.SLIDERS,
        width=30,
        height=13.5,
        card_style=Styles.PrimaryNeutral,
    ),
    xy=(19, 55),
)
n_renderers = err_grp.add(
    Node(
        "Slim\\Error\n(5 Classes)",
        icon=PhosphorIcon.FILE_CODE,
        width=30,
        height=13.5,
        card_style=Styles.Neutral,
    ),
    xy=(19, 39),
)
n_exc = err_grp.add(
    Node(
        "Slim\\Exception\n(11 Classes)",
        icon=PhosphorIcon.WARNING_OCTAGON,
        width=30,
        height=13.5,
        card_style=Styles.Neutral,
    ),
    xy=(19, 23),
)
n_ifaces = err_grp.add(
    Node(
        "Slim\\Interfaces\n(17 Contracts)",
        icon=PhosphorIcon.SHIELD_CHECK,
        width=30,
        height=13.5,
        style=Styles.White,
        text_style=Styles.WhiteBold.patch(text_size=10.0),
        card_style=Styles.AccentFlat,
    ),
    xy=(19, 8),
)

n_factory.connect(n_psr17, label="discovers")
n_factory.connect(n_root, label="creates")
n_root.connect(n_mw, label="LIFO")
n_mw.connect(n_routing, label="routes")
n_mw.connect(n_handlers, label="errors")
n_handlers.connect(n_renderers)
n_routing.connect(n_exc, label="4xx/5xx")
n_routing.connect(n_ifaces, label="contracts")

d.draw(xy=(0, 0))
save()
```

---

## アーキテクチャと PHP-FIG (PSR) 標準への準拠

Slim v4.15.3 は全 72 ファイル（`3,149` LOC）の 100% で `declare(strict_types=1)` を徹底し、独自の HTTP メッセージ実装や専用 DI コンテナを内包せず、**PHP-FIG (PSR) 標準インターフェース**に疎結合でバインドする設計を採用しています。

| 標準規格 | Composer パッケージ | バージョン制約 | Slim v4.15.3 における役割 |
| :--- | :--- | :--- | :--- |
| **PHP ランタイム** | `php`, `ext-json` | `~7.4.0 \|\| ~8.0.0 .. ~8.5.0` | 厳格なスカラ型ヒント・戻り値型、および JSON ボディ解析・エラー出力。 |
| **PSR-3** | `psr/log` | `^1.1 \|\| ^2.0 \|\| ^3.0` | [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) と [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) に注入される `LoggerInterface`（デフォルトは [`Slim\Logger`](01_app_and_factories.md#slim-logger)）。 |
| **PSR-7** | `psr/http-message` | `^1.1 \|\| ^2.0` | ミドルウェアとルート間で授受されるイミュータブルな `ServerRequestInterface`、`ResponseInterface`、`StreamInterface`。 |
| **PSR-11** | `psr/container` | `^1.0 \|\| ^2.0` | [`AppFactory`](01_app_and_factories.md#slim-factory-appfactory)、[`CallableResolver`](01_app_and_factories.md#slim-callableresolver)、[`MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) が参照する任意の DI コンテナ `ContainerInterface`。 |
| **PSR-15** | `psr/http-server-handler`, `psr/http-server-middleware` | `^1.0` | `RequestHandlerInterface`（[`App`](01_app_and_factories.md#slim-app)、[`Route`](03_routing.md#slim-routing-route)、[`RouteRunner`](03_routing.md#slim-routing-routerunner)）および `MiddlewareInterface`（[`Slim\Middleware\*`](04_middleware.md)）。 |
| **PSR-17** | `psr/http-factory` | `^1.1` | [`Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) により自動検出される `ResponseFactoryInterface` と `StreamFactoryInterface`。 |
| **ルーティング** | `nikic/fast-route` | `^1.3` | [`Dispatcher`](03_routing.md#slim-routing-dispatcher) と [`FastRouteDispatcher`](03_routing.md#slim-routing-fastroutedispatcher) がラップする高速正規表現ルータ。 |

```drawlib align=center code=fold file=slim_psr_interoperability_pipeline_ja.png caption="エンドツーエンドのリクエストライフサイクルとカタログ構成の対応"
from drawlib.canvas import save, setup
from drawlib.smartarts import ChevronProcess, KpiCards
from drawlib.styles import Colors, Styles

setup(width=136, height=48)

proc = ChevronProcess(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Muted.patch(text_size=9.5),
    corner_angle=60.0,
    spacing=1.5,
    flat_left_end=True,
)
proc.add(
    "1. 起動・生成",
    description="AppFactory & PSR-17\n(Pages 01–02)",
    style=Styles.PrimaryNeutral,
)
proc.add(
    "2. ミドルウェア",
    description="PSR-15 LIFO Stack\n(Page 04)",
    style=Styles.Neutral,
)
proc.add(
    "3. ルーティング",
    description="FastRoute & Route\n(Page 03)",
    style=Styles.SecondaryNeutral,
)
proc.add(
    "4. 戦略・実行",
    description="Strategies & DI\n(Page 05)",
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.5),
    description_style=Styles.White.patch(text_size=9.5),
)
proc.add(
    "5. エラー・送出",
    description="Renderers & 4xx/5xx\n(Pages 06–07)",
    style=Styles.Neutral,
)
proc.draw(xy=(6, 30), width=124, height=13)

white_card = Styles.Neutral.patch(shape_fill_color=Colors.White)
kpis = KpiCards(
    style=white_card,
    metric_style=Styles.DarkBold.patch(text_size=12.5),
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Muted.patch(text_size=9.5),
    accent_style=Styles.PrimaryFlat,
    accent_position="top_bar",
    metric_layout="top_stack",
    spacing=3.0,
)
kpis.add(
    "72 PHP Files",
    "100% Strict Types",
    "55 Classes · 17 Interfaces",
    style=Styles.PrimaryNeutral,
    metric_style=Styles.PrimaryBold.patch(text_size=12.5),
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "6 PSR-17 Bridges",
    "自動ファクトリ検出",
    "6 種の PSR-7 実装に対応",
    accent_style=Styles.SecondaryFlat,
)
kpis.add(
    "6 Middlewares",
    "同心円 PSR-15 パイプライン",
    "Routing · Error · BodyParser",
    accent_style=Styles.PrimaryFlat,
)
kpis.add(
    "17 Contracts",
    "Slim\\Interfaces\\*",
    "全サブシステムの契約分離",
    accent_style=Styles.AccentFlat,
)
kpis.draw(xy=(6, 4), width=124, height=21, columns=4)

save()
```

---

## `package` Slim\

**ルートアプリケーションカーネル、Callable 解決、LIFO ミドルウェアディスパッチャ、レスポンス送出、ロガー** — 詳細は [01. App & Factories](01_app_and_factories.md) を参照してください。

ルート名前空間 `Slim\` には、PSR-15 リクエスト処理パイプラインの統括、文字列表記や DI コンテナからの Callable 解決、および SAPI クライアントへのレスポンス送出を担う 5 つの基幹クラスが定義されています。

| シンボル | 種別 | 継承 / 実装インターフェース | 概要 |
| :--- | :--- | :--- | :--- |
| [`Slim\App`](01_app_and_factories.md#slim-app) | `class` | extends [`RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), implements `RequestHandlerInterface` | アプリケーション本体（`VERSION = '4.15.1'`）。ルート・ミドルウェア登録、`handle()` による実行、`HEAD` リクエスト時の空ボディ保証（RFC 2616）、`run()` による送出を担当。 |
| [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | `final class` | implements [`AdvancedCallableResolverInterface`](08_interfaces.md#slim-interfaces-advancedcallableresolverinterface) | クロージャ、Invokable オブジェクト、`[class, method]` 配列、`'Class:method'` 文字列を PSR-11 コンテナ検索または直接インスタンス化（`new $class($container)`）で解決。 |
| [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | `class` | implements [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | 中心カーネル（`RouteRunner`）を匿名ハンドラフレームで同心円状に包む LIFO（後入れ先出し）PSR-15 ミドルウェアスタック。 |
| [`Slim\ResponseEmitter`](01_app_and_factories.md#slim-responseemitter) | `class` | — | PSR-7 `ResponseInterface` のヘッダ（複数 `Set-Cookie` 保護付き）、ステータス行、チャンク分割ボディ（既定 `4096` バイト）を出力。 |
| [`Slim\Logger`](01_app_and_factories.md#slim-logger) | `class` | extends `Psr\Log\AbstractLogger` | PHP 標準の `error_log()` へメッセージを出力する軽量な既定 PSR-3 ロガー。 |

---

## `package` Slim\Factory

**アプリケーションおよび ServerRequest の静的ブートストラップファクトリ** — 詳細は [01. App & Factories](01_app_and_factories.md) を参照してください。

`Slim\Factory` 名前空間には、明示的な引数・PSR-11 コンテナ・PSR-17 自動検出を組み合わせて `Slim\App` と `ServerRequestCreatorInterface` を構築する 2 つの静的ファクトリクラスが用意されています。

| シンボル | 種別 | 概要 |
| :--- | :--- | :--- |
| [`Slim\Factory\AppFactory`](01_app_and_factories.md#slim-factory-appfactory) | `class` | `create()`、`createFromContainer()`、`determineResponseFactory()`、およびコンテナや各種コンポーネントを事前設定する静的セッター群を提供。 |
| [`Slim\Factory\ServerRequestCreatorFactory`](01_app_and_factories.md#slim-factory-serverrequestcreatorfactory) | `class` | PHP スーパーグローバル（`$_SERVER`, `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES`）から `ServerRequestInterface` を生成する `ServerRequestCreatorInterface` を構築。 |

---

## `package` Slim\Factory\Psr17

**PSR-17 HTTP ファクトリ自動検出レジストリ & ベンダー別アダプタ群** — 詳細は [02. PSR-17 Providers](02_psr17_providers.md) を参照してください。

`Slim\Factory\Psr17` 名前空間の 10 クラスは、Composer でインストール済みの PSR-7 / PSR-17 実装を優先順（`SlimPsr17Factory`, `HttpSoftPsr17Factory`, `NyholmPsr17Factory`, `LaminasDiactorosPsr17Factory`, `GuzzlePsr17Factory`）に自動検出し、必要に応じて `slim/http` デコレータを適用します。

| シンボル | 種別 | 継承 / 実装インターフェース | 対応 Composer パッケージ |
| :--- | :--- | :--- | :--- |
| [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) | `class` | implements [`Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface) | 検出対象 `Psr17Factory` クラス名の優先順位リストを管理（`getFactories()`, `setFactories()`, `addFactory()`）。 |
| [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `abstract class` | implements [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) | `class_exists()` による存在確認と `ResponseFactoryInterface`、`StreamFactoryInterface`、[`ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator) の生成を担う抽象基底クラス。 |
| [`Slim\Factory\Psr17\ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator) | `class` | implements [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | ベンダー別の生成クラスとメソッドを `Closure::fromCallable()` 経由で呼び出し、スーパーグローバルから `ServerRequestInterface` を生成。 |
| [`Slim\Factory\Psr17\SlimHttpServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-slimhttpserverrequestcreator) | `class` | implements [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | 内部の `ServerRequestCreatorInterface` が生成したリクエストを `Slim\Http\ServerRequest`（`slim/http`）でラップするデコレータ。 |
| [`Slim\Factory\Psr17\SlimPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-slimpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `slim/psr7`（`Slim\Psr7\Factory\ResponseFactory`, `StreamFactory`, `ServerRequestFactory::createFromGlobals`）。 |
| [`Slim\Factory\Psr17\SlimHttpPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-slimhttppsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `slim/http`（`Slim\Http\Factory\DecoratedResponseFactory` によるレスポンスファクトリの装飾）。 |
| [`Slim\Factory\Psr17\NyholmPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-nyholmpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `nyholm/psr7` & `nyholm/psr7-server`（統合型 `Nyholm\Psr7\Factory\Psr17Factory` と `ServerRequestCreator::fromGlobals`）。 |
| [`Slim\Factory\Psr17\GuzzlePsr17Factory`](02_psr17_providers.md#slim-factory-psr17-guzzlepsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `guzzlehttp/psr7`（`GuzzleHttp\Psr7\HttpFactory`, `GuzzleHttp\Psr7\ServerRequest::fromGlobals`）。 |
| [`Slim\Factory\Psr17\LaminasDiactorosPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-laminasdiactorospsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `laminas/laminas-diactoros`（`Laminas\Diactoros\ResponseFactory`, `StreamFactory`, `ServerRequestFactory::fromGlobals`）。 |
| [`Slim\Factory\Psr17\HttpSoftPsr17Factory`](02_psr17_providers.md#slim-factory-psr17-httpsoftpsr17factory) | `class` | extends [`Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory) | `httpsoft/http-message` & `httpsoft/http-server-request`（`HttpSoft\Message\ResponseFactory`, `StreamFactory`, `ServerRequestCreator::createFromGlobals`）。 |

---

## `package` Slim\Routing

**ルート登録、ルートグループ、URL 逆引き生成、FastRoute ディスパッチ & ルート実行** — 詳細は [03. Routing Subsystem](03_routing.md) を参照してください。

`Slim\Routing` 名前空間の 11 クラスは、ルーティング DSL、ネスト可能なグループ、名前付きルートからの URL 生成（`RouteParser`）、FastRoute の正規表現ディスパッチとキャッシュ、リクエスト属性へのコンテキスト埋め込み（`RouteContext`）、およびルート単位のミドルウェア実行を担います。

| シンボル | 種別 | 継承 / 実装インターフェース | 概要 |
| :--- | :--- | :--- | :--- |
| [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy) | `class` | implements [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | `get()`, `post()`, `put()`, `delete()`, `options()`, `patch()`, `any()`, `map()`, `group()`, `redirect()` を備えるルーティングプロキシ（`Slim\App` の親クラス）。 |
| [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) | `class` | implements [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | ルートとグループの登録管理、既定の呼び出し戦略、ベースパス、FastRoute キャッシュファイルを保持する中央レジストリ。 |
| [`Slim\Routing\Route`](03_routing.md#slim-routing-route) | `class` | implements [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface), `RequestHandlerInterface` | 単一ルートを表し、独自の `MiddlewareDispatcher`、ルートパラメータ、呼び出し戦略、グループチェインを保持。 |
| [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) | `class` | implements [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | 共通の URI プレフィックスとグループミドルウェア群を束ねて配下のルートへ適用。 |
| [`Slim\Routing\RouteContext`](03_routing.md#slim-routing-routecontext) | `final class` | — | `RouteContext::fromRequest($request)` でリクエスト属性から `Route`, `RouteParser`, `RoutingResults`, `basePath` を型安全に取得する値オブジェクト。 |
| [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) | `class` | implements [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | 名前付きルートとパラメータから `relativeUrlFor()`, `urlFor()`, `fullUrlFor()` を逆引き生成。 |
| [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) | `class` | implements [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | `RouteCollectorInterface` と `DispatcherInterface` を橋渡しし、`RoutingResults` の算出と `RouteInterface` の解決を実行。 |
| [`Slim\Routing\RouteRunner`](03_routing.md#slim-routing-routerunner) | `class` | implements `RequestHandlerInterface` | ミドルウェアスタックの最深部カーネル。未解決時のルーティング補完、`RouteContext::ROUTE` 属性の設定、`Route::run()` の呼び出しを実行。 |
| [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) | `class` | implements [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | FastRoute の `simpleDispatcher` / `cachedDispatcher` を駆動し、`RoutingResults` と許可メソッド一覧を返却。 |
| [`Slim\Routing\FastRouteDispatcher`](03_routing.md#slim-routing-fastroutedispatcher) | `class` | extends `FastRoute\Dispatcher\GroupCountBased` | `HEAD -> GET` 自動フォールバックと許可 HTTP メソッド抽出を備えるカスタム FastRoute ディスパッチャ。 |
| [`Slim\Routing\RoutingResults`](03_routing.md#slim-routing-routingresults) | `class` | — | ディスパッチ結果（`NOT_FOUND = 0`, `FOUND = 1`, `METHOD_NOT_ALLOWED = 2`）、ルート識別子、`rawurldecode` 済み引数、許可メソッドを保持。 |

---

## `package` Slim\Middleware

**組み込み PSR-15 サーバーミドルウェア群** — 詳細は [04. Built-in PSR-15 Middlewares](04_middleware.md) を参照してください。

`Slim\Middleware` 名前空間には、ルーティング、例外捕捉、リクエストボディ解析、HTTP メソッド上書き、出力バッファリング、`Content-Length` 付与を担う 6 つの標準 PSR-15 ミドルウェアが揃っています。

| シンボル | 種別 | 実装インターフェース | 概要 |
| :--- | :--- | :--- | :--- |
| [`Slim\Middleware\RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) | `class` | `MiddlewareInterface` | 後続ミドルウェアの実行前にルーティングを完了させてリクエスト属性を付与し、不一致時は 404 / 405 例外を送出。 |
| [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) | `class` | `MiddlewareInterface` | 最外層の `try / catch (Throwable)` 境界として例外を捕捉し、型別のカスタムハンドラまたは既定の `ErrorHandlerInterface` に委譲。 |
| [`Slim\Middleware\BodyParsingMiddleware`](04_middleware.md#slim-middleware-bodyparsingmiddleware) | `class` | `MiddlewareInterface` | `application/json`, `application/x-www-form-urlencoded`, `application/xml`（`text/xml`）のボディを解析し `$request->withParsedBody()` に設定。 |
| [`Slim\Middleware\ContentLengthMiddleware`](04_middleware.md#slim-middleware-contentlengthmiddleware) | `class` | `MiddlewareInterface` | レスポンスストリームのサイズ（`$response->getBody()->getSize()`）を計測し、`Content-Length` ヘッダを自動付与。 |
| [`Slim\Middleware\MethodOverrideMiddleware`](04_middleware.md#slim-middleware-methodoverridemiddleware) | `class` | `MiddlewareInterface` | `X-Http-Method-Override` ヘッダまたは `POST` ボディの `_METHOD` パラメータに基づきリクエストメソッドを上書き。 |
| [`Slim\Middleware\OutputBufferingMiddleware`](04_middleware.md#slim-middleware-outputbufferingmiddleware) | `class` | `MiddlewareInterface` | `ob_start()` で標準出力を捕捉し、PSR-7 レスポンスボディの末尾（`APPEND`）または先頭（`PREPEND`）に結合。 |

---

## `package` Slim\Handlers

**標準 ErrorHandler とルート呼び出し戦略（Invocation Strategies）** — 詳細は [05. Error Handler & Route Strategies](05_handlers_and_strategies.md) を参照してください。

`Slim\Handlers` および `Slim\Handlers\Strategies` 名前空間には、コンテンツネゴシエーション対応の [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) と、ルートコールバックの引数渡し方式を切り替える 4 つの Strategy クラスが含まれています。

| シンボル | 種別 | 実装インターフェース | コールバック呼び出しシグネチャ |
| :--- | :--- | :--- | :--- |
| [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) | `class` | [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | `Accept` ヘッダから最適なエラーレンダラ（`json`, `xml`, `html`, `text/plain`）を選択し、PSR-3 ログ出力とエラー `ResponseInterface` 生成を実行。 |
| [`Slim\Handlers\Strategies\RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | **既定の戦略**: `function (ServerRequestInterface $request, ResponseInterface $response, array $args): ResponseInterface`。 |
| [`Slim\Handlers\Strategies\RequestResponseArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponseargs) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | ルート引数を位置引数として展開: `function (ServerRequestInterface $request, ResponseInterface $response, string $arg1, ...): ResponseInterface`。 |
| [`Slim\Handlers\Strategies\RequestResponseNamedArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponsenamedargs) | `class` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | ルート引数を PHP 8 名前付き引数として展開: `function (ServerRequestInterface $request, ResponseInterface $response, string $id, ...): ResponseInterface`。 |
| [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) | `class` | [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | PSR-15 スタイル（`function (ServerRequestInterface $request): ResponseInterface`）で呼び出し、任意でルート引数をリクエスト属性に注入。 |

---

## `package` Slim\Error\Renderers

**コンテンツネゴシエーション対応エラーレンダラ群** — 詳細は [06. Error Renderers](06_error_renderers.md) を参照してください。

`Slim\Error` および `Slim\Error\Renderers` 名前空間の 5 クラスは、捕捉された `Throwable` を `$displayErrorDetails` フラグおよび `$exception->getPrevious()` チェーンに従って各 MIME 形式の文字列へシリアライズします。

| シンボル | 種別 | 継承 / 実装インターフェース | 対応メディアタイプ（`ErrorHandler` 登録値） |
| :--- | :--- | :--- | :--- |
| [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `abstract class` | implements [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) | `HttpException` のタイトル・説明文と汎用 500 デフォルト値（`$defaultErrorTitle`, `$defaultErrorDescription`）を解決する抽象基底クラス。 |
| [`Slim\Error\Renderers\JsonErrorRenderer`](06_error_renderers.md#slim-error-renderers-jsonerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `application/json`, `application/vnd.api+json`（`JSON_PRETTY_PRINT \| JSON_UNESCAPED_SLASHES`）。 |
| [`Slim\Error\Renderers\HtmlErrorRenderer`](06_error_renderers.md#slim-error-renderers-htmlerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `text/html`, `application/xhtml+xml`（`htmlentities()` エスケープ済み HTML テンプレート）。 |
| [`Slim\Error\Renderers\XmlErrorRenderer`](06_error_renderers.md#slim-error-renderers-xmlerrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `application/xml`, `text/xml`（`<![CDATA[...]]>` セクションを用いた XML エラーペイロード）。 |
| [`Slim\Error\Renderers\PlainTextErrorRenderer`](06_error_renderers.md#slim-error-renderers-plaintexterrorrenderer) | `class` | extends [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) | `text/plain`（および [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) の既定エラーログフォーマッタ）。 |

---

## `package` Slim\Exception

**HTTP 4xx / 5xx 構造化例外クラス階層** — 詳細は [07. HTTP Exceptions](07_exceptions.md) を参照してください。

`Slim\Exception` 名前空間には、`RuntimeException` を継承し HTTP ステータスコード・タイトル・詳細説明文・発生元 `ServerRequestInterface` を保持する 11 クラスが定義されています。

| シンボル | ステータスコード | 既定メッセージ (`$message`) | 親クラス |
| :--- | :--- | :--- | :--- |
| [`Slim\Exception\HttpException`](07_exceptions.md#slim-exception-httpexception) | `500` | `''` | `RuntimeException` |
| [`Slim\Exception\HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) | *(abstract)* | *(継承)* | [`HttpException`](07_exceptions.md#slim-exception-httpexception) |
| [`Slim\Exception\HttpBadRequestException`](07_exceptions.md#slim-exception-httpbadrequestexception) | `400` | `'Bad request.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpUnauthorizedException`](07_exceptions.md#slim-exception-httpunauthorizedexception) | `401` | `'Unauthorized.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpForbiddenException`](07_exceptions.md#slim-exception-httpforbiddenexception) | `403` | `'Forbidden.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpNotFoundException`](07_exceptions.md#slim-exception-httpnotfoundexception) | `404` | `'Not found.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) | `405` | `'Method not allowed.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpGoneException`](07_exceptions.md#slim-exception-httpgoneexception) | `410` | `'Gone.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpTooManyRequestsException`](07_exceptions.md#slim-exception-httptoomanyrequestsexception) | `429` | `'Too many requests.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpInternalServerErrorException`](07_exceptions.md#slim-exception-httpinternalservererrorexception) | `500` | `'Internal server error.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |
| [`Slim\Exception\HttpNotImplementedException`](07_exceptions.md#slim-exception-httpnotimplementedexception) | `501` | `'Not implemented.'` | [`HttpSpecializedException`](07_exceptions.md#slim-exception-httpspecializedexception) |

---

## `package` Slim\Interfaces

**全 17 契約インターフェース（`Slim\Interfaces\*`）** — 詳細は [08. Contract Interfaces](08_interfaces.md) を参照してください。

Slim 4 のすべてのサブシステムは具象クラスではなく `Slim\Interfaces\*` の契約に依存しており、`AppFactory` または PSR-11 コンテナ経由で任意のカスタム実装に差し替えることができます。

| 契約インターフェース | 既定の具象実装クラス | サブシステム |
| :--- | :--- | :--- |
| [`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | Callable・DI 解決 |
| [`AdvancedCallableResolverInterface`](08_interfaces.md#slim-interfaces-advancedcallableresolverinterface) | [`Slim\CallableResolver`](01_app_and_factories.md#slim-callableresolver) | ルート / ミドルウェア別 Callable 解決 |
| [`MiddlewareDispatcherInterface`](08_interfaces.md#slim-interfaces-middlewaredispatcherinterface) | [`Slim\MiddlewareDispatcher`](01_app_and_factories.md#slim-middlewaredispatcher) | PSR-15 LIFO スタック |
| [`Psr17FactoryInterface`](08_interfaces.md#slim-interfaces-psr17factoryinterface) | [`Slim\Factory\Psr17\Psr17Factory`](02_psr17_providers.md#slim-factory-psr17-psr17factory)（+ 6 具象クラス） | PSR-17 ファクトリ検出 |
| [`Psr17FactoryProviderInterface`](08_interfaces.md#slim-interfaces-psr17factoryproviderinterface) | [`Slim\Factory\Psr17\Psr17FactoryProvider`](02_psr17_providers.md#slim-factory-psr17-psr17factoryprovider) | PSR-17 プロバイダレジストリ |
| [`ServerRequestCreatorInterface`](08_interfaces.md#slim-interfaces-serverrequestcreatorinterface) | [`ServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-serverrequestcreator), [`SlimHttpServerRequestCreator`](02_psr17_providers.md#slim-factory-psr17-slimhttpserverrequestcreator) | グローバルからの Request 生成 |
| [`RouteCollectorProxyInterface`](08_interfaces.md#slim-interfaces-routecollectorproxyinterface) | [`Slim\Routing\RouteCollectorProxy`](03_routing.md#slim-routing-routecollectorproxy), [`Slim\App`](01_app_and_factories.md#slim-app) | ルーティング DSL |
| [`RouteCollectorInterface`](08_interfaces.md#slim-interfaces-routecollectorinterface) | [`Slim\Routing\RouteCollector`](03_routing.md#slim-routing-routecollector) | ルートレジストリ |
| [`RouteInterface`](08_interfaces.md#slim-interfaces-routeinterface) | [`Slim\Routing\Route`](03_routing.md#slim-routing-route) | ルートエンティティ |
| [`RouteGroupInterface`](08_interfaces.md#slim-interfaces-routegroupinterface) | [`Slim\Routing\RouteGroup`](03_routing.md#slim-routing-routegroup) | ルートグループ |
| [`RouteParserInterface`](08_interfaces.md#slim-interfaces-routeparserinterface) | [`Slim\Routing\RouteParser`](03_routing.md#slim-routing-routeparser) | URL 逆引き生成 |
| [`RouteResolverInterface`](08_interfaces.md#slim-interfaces-routeresolverinterface) | [`Slim\Routing\RouteResolver`](03_routing.md#slim-routing-routeresolver) | ルート解決 |
| [`DispatcherInterface`](08_interfaces.md#slim-interfaces-dispatcherinterface) | [`Slim\Routing\Dispatcher`](03_routing.md#slim-routing-dispatcher) | FastRoute ブリッジ |
| [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | [`RequestResponse`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponse), [`RequestResponseArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponseargs), [`RequestResponseNamedArgs`](05_handlers_and_strategies.md#slim-handlers-strategies-requestresponsenamedargs) | ルートコールバック呼び出し戦略 |
| [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | [`Slim\Handlers\Strategies\RequestHandler`](05_handlers_and_strategies.md#slim-handlers-strategies-requesthandler) | PSR-15 ルート呼び出し戦略 |
| [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) | 例外ハンドリング |
| [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) | [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer)（+ 4 レンダラ） | エラーペイロード描画 |
