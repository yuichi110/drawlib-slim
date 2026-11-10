# ハンドラと実行ストラテジー (Handlers & Strategies)

`Slim\Handlers` 名前空間は、HTTP コンテンツネゴシエーション・例外ロギング・エラーレスポンス生成を担うデフォルトの [`ErrorHandler`](#slim-handlers-errorhandler) と、`Slim\Handlers\Strategies` 配下の 4 つのルートコールバック実行ストラテジーを提供します。これらのクラスは、マッチした [`Route`](03_routing.md#slim-routing-route) コールバックの呼び出し規約と、未捕捉の `Throwable` を [`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) 経由で PSR-7 レスポンスへ変換するパイプラインを制御します。

```drawlib align=center code=fold file=p2_handlers_error_pipeline_ja.png caption="Slim\Handlers\ErrorHandler の実行とコンテンツネゴシエーション・パイプライン"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
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

## クラス一覧

| クラス | 名前空間 | 実装インターフェース | 主な役割 |
| :--- | :--- | :--- | :--- |
| [`ErrorHandler`](#slim-handlers-errorhandler) | `Slim\Handlers` | [`ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface) | `Accept` ヘッダに基づく MIME ネゴシエーション、PSR-3 ロギング、エラーレスポンス生成を実行します。 |
| [`RequestResponse`](#slim-handlers-strategies-requestresponse) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | デフォルト戦略：ルート引数をリクエスト属性に付与し、`($request, $response, array $args)` で呼び出します。 |
| [`RequestResponseArgs`](#slim-handlers-strategies-requestresponseargs) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | ルートパラメータを位置引数 `($request, $response, ...array_values($args))` として展開します。 |
| [`RequestResponseNamedArgs`](#slim-handlers-strategies-requestresponsenamedargs) | `Slim\Handlers\Strategies` | [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) | ルートパラメータを PHP 8+ の名前付き引数 `($request, $response, ...$args)` として展開します。 |
| [`RequestHandler`](#slim-handlers-strategies-requesthandler) | `Slim\Handlers\Strategies` | [`RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface) | PSR-15 スタイルの `$callable($request)` として呼び出し、オプションでリクエスト属性注入を行います。 |

---

## `class` Slim\Handlers\ErrorHandler

- **ソースファイル**: `Slim/Handlers/ErrorHandler.php`
- **名前空間**: `Slim\Handlers`
- **実装インターフェース**: [`Slim\Interfaces\ErrorHandlerInterface`](08_interfaces.md#slim-interfaces-errorhandlerinterface)

`ErrorHandler` は、[`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware) から呼び出される Slim 標準のエラーハンドラです。HTTP ステータスコードの決定、リクエストの `Accept` ヘッダに基づくコンテンツタイプのネゴシエーション（[`Slim\Error\Renderers`](06_error_renderers.md) による JSON / XML / HTML / Plain Text 出力）、PSR-3 ロガー（デフォルトは [`Slim\Logger`](01_app_and_factories.md#slim-logger)）へのエラー出力、および PSR-7 `ResponseInterface` の生成を一貫して担います。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 可視性 | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `$defaultErrorRendererContentType` | `protected` | `string` | `'text/html'` | コンテンツネゴシエーションで登録済み MIME タイプに一致しなかった場合に使用される `Content-type` ヘッダ値です。 |
| `$defaultErrorRenderer` | `protected` | `ErrorRendererInterface\|string\|callable` | `HtmlErrorRenderer::class` | `$contentType` が `null` または未登録の際、[`CallableResolverInterface`](08_interfaces.md#slim-interfaces-callableresolverinterface) で解決されるデフォルトレンダラです。 |
| `$logErrorRenderer` | `protected` | `ErrorRendererInterface\|string\|callable` | `PlainTextErrorRenderer::class` | `writeToErrorLog()` 内で `$logger->error()` に渡すエラー文字列の整形に使用されるレンダラです。 |
| `$errorRenderers` | `protected` | `array<string, ErrorRendererInterface\|string\|callable>` | 5 種の標準マッピング | MIME タイプ（`application/json`, `application/xml`, `text/xml`, `text/html`, `text/plain`）とエラーレンダラの連想配列です。 |
| `$displayErrorDetails` | `protected` | `bool` | `false` | HTTP レスポンスに例外の型・コード・メッセージ・ファイル・行番号・スタックトレースを含めるかどうかを制御します。 |
| `$logErrors` | `protected` | `bool` | 未初期化 | `__invoke()` 呼び出し時に設定され、`writeToErrorLog()` を実行するかどうかを制御します。 |
| `$logErrorDetails` | `protected` | `bool` | `false` | `__invoke()` 呼び出し時に設定され、`$logErrorRenderer` の第 2 引数として渡されます。 |
| `$contentType` | `protected` | `?string` | `null` | 現在のエラーレスポンスに対してネゴシエーションまたは強制指定された MIME タイプです。 |
| `$isContentTypeForced` | `protected` | `bool` | `false` | `true` の場合、`__invoke()` 時に `determineContentType($request)` をスキップして強制指定された `$contentType` を維持します。 |
| `$method` | `protected` | `?string` | `null` | `__invoke()` 時に `$request->getMethod()` から取得された HTTP メソッドです。 |
| `$request` | `protected` | `ServerRequestInterface` | 未初期化 | `__invoke()` に渡された最新の PSR-7 リクエストインスタンスです。 |
| `$exception` | `protected` | `Throwable` | 未初期化 | `__invoke()` に渡された捕捉済み例外またはエラーです。 |
| `$statusCode` | `protected` | `int` | 未初期化 | 決定された HTTP ステータスコード（`OPTIONS` は `200`、[`HttpException`](07_exceptions.md#slim-exception-httpexception) は `$exception->getCode()`、それ以外は `500`）です。 |
| `$callableResolver` | `protected` | `CallableResolverInterface` | コンストラクタ注入 | レンダラのクラス名やコンテナ ID を呼び出し可能な `callable` に解決します。 |
| `$responseFactory` | `protected` | `ResponseFactoryInterface` | コンストラクタ注入 | `respond()` でベースとなる PSR-7 `ResponseInterface` を生成します。 |
| `$logger` | `protected` | `LoggerInterface` | `new Logger()` | `logError()` でエラーログを受け取る PSR-3 ロガーインスタンスです。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `CallableResolverInterface $callableResolver`, `ResponseFactoryInterface $responseFactory`, `?LoggerInterface $logger = null` | `void` | ハンドラを初期化します。`$logger` が `null` の場合は `getDefaultLogger()`（[`Slim\Logger`](01_app_and_factories.md#slim-logger)）を使用します。 |
| `__invoke` | `ServerRequestInterface $request`, `Throwable $exception`, `bool $displayErrorDetails`, `bool $logErrors`, `bool $logErrorDetails` | `ResponseInterface` | 実行状態を保持し、ステータスコードとコンテンツタイプを決定（強制時を除く）し、必要に応じてエラーログを出力して `respond()` を返します。 |
| `forceContentType` | `?string $contentType` | `void` | すべてのエラーレスポンスの MIME タイプ（例：`'application/json'`）を強制します。`null` を渡すと `Accept` ヘッダによるネゴシエーションに戻ります。 |
| `registerErrorRenderer` | `string $contentType`, `ErrorRendererInterface\|string\|callable $errorRenderer` | `void` | 指定した `$contentType` に対するエラーレンダラを `$errorRenderers[$contentType]` に登録または上書きします。 |
| `setDefaultErrorRenderer` | `string $contentType`, `ErrorRendererInterface\|string\|callable $errorRenderer` | `void` | ネゴシエーション不一致時に使用される `$defaultErrorRendererContentType` と `$defaultErrorRenderer` を設定します。 |
| `setLogErrorRenderer` | `ErrorRendererInterface\|string\|callable $logErrorRenderer` | `void` | `writeToErrorLog()` でログ文字列のフォーマットに使用するレンダラを設定します。 |
| `determineStatusCode` | *(なし)* | `int` | `protected`。`$this->method === 'OPTIONS'` なら `200`、`instanceof HttpException` なら `$this->exception->getCode()`、それ以外は `500` を返します。 |
| `determineContentType` | `ServerRequestInterface $request` | `?string` | `protected`。カンマ区切りの `Accept` ヘッダと `array_keys($this->errorRenderers)` の共通部分を検査（複数一致時は `text/plain` 以外を優先）し、さらに `/\+(json\|xml)/` 形式のサブタイプを判定します。 |
| `determineRenderer` | *(なし)* | `callable` | `protected`。`$this->contentType` が登録済みなら対応するレンダラ、未登録なら `$this->defaultErrorRenderer` を選択し、`$this->callableResolver->resolve()` で解決して返します。 |
| `writeToErrorLog` | *(なし)* | `void` | `protected`。`$this->logErrorRenderer` を解決して例外をフォーマットし、`PlainTextErrorRenderer` かつ `!$this->displayErrorDetails` の場合はヒント文を追記して `logError()` を呼び出します。 |
| `logError` | `string $error` | `void` | `protected`。`$this->logger->error($error)` に委譲します。 |
| `getDefaultLogger` | *(なし)* | `LoggerInterface` | `protected`。新しい [`Slim\Logger`](01_app_and_factories.md#slim-logger) インスタンスを生成して返します。 |
| `respond` | *(なし)* | `ResponseInterface` | `protected`。`$this->statusCode` でレスポンスを生成し、`Content-type` ヘッダ（および [`HttpMethodNotAllowedException`](07_exceptions.md#slim-exception-httpmethodnotallowedexception) の場合は `Allow` ヘッダ）を設定し、レンダラ出力をボディに書き込んで返します。 |

### 使用例

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

// クライアントの Accept ヘッダに関わらず常に JSON でエラーを返すよう設定
$errorHandler->forceContentType('application/json');
$errorHandler->setDefaultErrorRenderer('application/json', JsonErrorRenderer::class);

$errorMiddleware = $app->addErrorMiddleware(true, true, true);
$errorMiddleware->setDefaultErrorHandler($errorHandler);
```

---

## ルートコールバック実行ストラテジー (Invocation Strategies)

[`Route`](03_routing.md#slim-routing-route) がリクエストにマッチすると、ルートコールバックの実行は [`InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) 実装クラスに委譲されます。ストラテジーは `RouteCollector::setDefaultInvocationStrategy()` でアプリケーション全体に一括設定するか、`Route::setInvocationStrategy()` でルート単位に個別設定できます。

```drawlib align=center code=fold file=p2_handlers_invocation_strategies_ja.png caption="Slim の 4 つの実行ストラテジーにおけるルート引数のディスパッチ方式"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.lines import line
from drawlib.shapes import rectangle
from drawlib.styles import Styles
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

- **ソースファイル**: `Slim/Handlers/Strategies/RequestResponse.php`
- **名前空間**: `Slim\Handlers\Strategies`
- **実装インターフェース**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponse` は、[`RouteCollector`](03_routing.md#slim-routing-routecollector) の初期化時に設定される Slim 4 のデフォルト実行ストラテジーです。コールバックを呼び出す前に `$routeArguments` の各キーと値を `$request->withAttribute($k, $v)` で PSR-7 リクエスト属性にセットし、`($request, $response, $routeArguments)` の 3 引数でコールバックを実行します。

### クラスシグネチャ

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

### プロパティ

`RequestResponse` にはクラスプロパティはありません。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | `$routeArguments` の各要素を `withAttribute($k, $v)` で `$request` に付与し、`$callable($request, $response, $routeArguments)` を呼び出して返します。 |

### 使用例

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponse;

$app = AppFactory::create();
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestResponse());

$app->get('/users/{id}', function (Request $request, Response $response, array $args): Response {
    // $args['id'] と $request->getAttribute('id') の両方から取得可能
    $userId = $args['id'];
    $response->getBody()->write("User ID: {$userId}");
    return $response;
});
```

---

## `class` Slim\Handlers\Strategies\RequestResponseArgs

- **ソースファイル**: `Slim/Handlers/Strategies/RequestResponseArgs.php`
- **名前空間**: `Slim\Handlers\Strategies`
- **実装インターフェース**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponseArgs` は、`...array_values($routeArguments)` を用いてルートパラメータを `$request` と `$response` に続く個別の位置引数として展開します。[`RequestResponse`](#slim-handlers-strategies-requestresponse) とは異なり、`$request` の属性（attributes）への自動セットは行いません。

### クラスシグネチャ

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

### プロパティ

`RequestResponseArgs` にはクラスプロパティはありません。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | `$callable($request, $response, ...array_values($routeArguments))` を呼び出して返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Handlers/Strategies/RequestResponseNamedArgs.php`
- **名前空間**: `Slim\Handlers\Strategies`
- **実装インターフェース**: [`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface)

`RequestResponseNamedArgs` は、連想配列 `$routeArguments` をそのまま `...$routeArguments` で展開し、PHP 8.0 以降の名前付き引数としてコールバックに渡します。ルートパターン内のプレースホルダ名（例：`{id}`, `{tab}`）とコールバックの仮引数名が一致している必要があり、`$request`, `$response` 以降の引数定義順序には依存しません。[`RequestResponseArgs`](#slim-handlers-strategies-requestresponseargs) と同様、`$request` 属性への自動セットは行いません。

### クラスシグネチャ

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

### プロパティ

`RequestResponseNamedArgs` にはクラスプロパティはありません。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | PHP の名前付き引数展開を用いて `$callable($request, $response, ...$routeArguments)` を呼び出して返します。 |

### 使用例

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestResponseNamedArgs;

$app = AppFactory::create();
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestResponseNamedArgs());

// プレースホルダ名と一致していれば、$tab と $id の宣言順序を入れ替えても正しく渡されます
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

- **ソースファイル**: `Slim/Handlers/Strategies/RequestHandler.php`
- **名前空間**: `Slim\Handlers\Strategies`
- **実装インターフェース**: [`Slim\Interfaces\RequestHandlerInvocationStrategyInterface`](08_interfaces.md#slim-interfaces-requesthandlerinvocationstrategyinterface)（[`Slim\Interfaces\InvocationStrategyInterface`](08_interfaces.md#slim-interfaces-invocationstrategyinterface) を継承）

`RequestHandler` は、PSR-15 の `RequestHandlerInterface` シグネチャに準拠した単一引数コールバック `$callable($request): ResponseInterface` として呼び出します（事前生成された `$response` は渡されません）。コンストラクタ引数 `$appendRouteArgumentsToRequestAttributes` に `true` を指定すると、`$callable($request)` の呼び出し前に `$routeArguments` の各キーと値を `$request->withAttribute($k, $v)` でリクエスト属性へ注入します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 可視性 | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `$appendRouteArgumentsToRequestAttributes` | `protected` | `bool` | `false` | `true` の場合、`$callable($request)` を呼び出す前に `$routeArguments` の各要素を `$request->withAttribute($k, $v)` でリクエスト属性へ追加します。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__construct` | `bool $appendRouteArgumentsToRequestAttributes = false` | `void` | ルートパラメータを `$request` の属性に自動追加するかどうかを設定します。 |
| `__invoke` | `callable $callable`, `ServerRequestInterface $request`, `ResponseInterface $response`, `array<string, string> $routeArguments` | `ResponseInterface` | オプションで `$routeArguments` を `$request` 属性にセットし、`$callable($request)` を呼び出して返します。 |

### 使用例

```php
<?php

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;
use Slim\Handlers\Strategies\RequestHandler;

$app = AppFactory::create();

// PSR-15 ハンドラ内でプレースホルダを取得できるよう属性注入を有効化
$app->getRouteCollector()->setDefaultInvocationStrategy(new RequestHandler(true));

$app->get('/articles/{slug}', function (Request $request) use ($app): Response {
    $slug = $request->getAttribute('slug');
    $response = $app->getResponseFactory()->createResponse(200);
    $response->getBody()->write("Article: {$slug}");
    return $response;
});
```
