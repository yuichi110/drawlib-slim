# HTTP 例外 (`Slim\Exception\*`)

`Slim\Exception` 名前空間（`Slim/Exception/` 配下の全 `11` ファイル・`11` クラス）は、PHP SPL の `RuntimeException` を基底とする型安全な HTTP 例外階層を提供します。すべての例外は発生時の PSR-7 `ServerRequestInterface` インスタンスを保持するとともに、[`ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware)・[`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler)・[`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) が参照する `$title` および `$description` メタデータを備えています。

```drawlib align=center code=fold file=api_exceptions_hierarchy_ja.png caption="Slim\Exception クラス階層 — RuntimeException から HttpException・HttpSpecializedException・9 種の具象 HTTP ステータス例外まで"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=90, dpi=150)

# Left Panel: Inheritance Spine (RuntimeException -> HttpException -> HttpSpecializedException)
p_left = Panel(
    "例外継承階層 (Slim\\Exception\\*)",
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
    "\\Throwable を実装する PHP 標準の実行時例外",
    badge_text="SPL",
    icon=phosphor.code,
)
cl_spine.add(
    "HttpException (基底クラス)",
    "request・title・description の保持と Fluent セッタ",
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
    "3 引数 __construct(request, message, previous)",
    badge_text="Abs",
    icon=phosphor.git_merge,
    style=Styles.PrimaryNeutral,
)
cl_spine.add(
    "9 種の具象 HTTP ステータス例外",
    "code (400–501)・message・title を事前定義",
    badge_text="9x",
    icon=phosphor.stack,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl_spine.draw(xy=lx, width=lw, height=lh)

# Right Panel: 9 Concrete HTTP Status Exception Classes
p_right = Panel(
    "9 種の具象ステータス例外 (400–501)",
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
    "400 · 401 · 403 入力検証・認証認可",
    "BadRequest (400) · Unauthorized · Forbidden",
    badge_text="4xx",
    icon=phosphor.shield_warning,
)
cl.add(
    "404 NotFound & 405 MethodNotAllowed",
    "ルータが送出・405 は allowedMethods を保持",
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
    "恒久削除リソース (410) とレート制限超過 (429)",
    badge_text="4xx",
    icon=phosphor.clock_countdown,
    style=Styles.PrimaryNeutral,
)
cl.add(
    "500 InternalError & 501 NotImplemented",
    "サーバ内部障害 (500) と未実装機能 (501)",
    badge_text="5xx",
    icon=phosphor.bug,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.White.patch(shape_line_color=Colors.Gray4),
    badge_text_style=Styles.DarkBold.patch(text_size=10.0),
)
cl.draw(xy=rx, width=rw, height=rh)

save()
```

### `Slim\Exception\*` 全 11 クラス一覧表

| クラス | ソースファイル | HTTP `$code` | 既定 `$message` | 既定 `$title` | 固有プロパティ・メソッド |
| :--- | :--- | :--- | :--- | :--- | :--- |
| [`HttpException`](#slim-exception-httpexception) | `Slim/Exception/HttpException.php` | `0` (引数) | `''` (引数) | `''` | `$request`, `$title`, `$description` のゲッタ／セッタ |
| [`HttpSpecializedException`](#slim-exception-httpspecializedexception) | `Slim/Exception/HttpSpecializedException.php` | *(abstract)* | *(abstract)* | *(継承)* | 3 引数 `__construct($request, ?$message, ?$previous)` |
| [`HttpBadRequestException`](#slim-exception-httpbadrequestexception) | `Slim/Exception/HttpBadRequestException.php` | `400` | `'Bad request.'` | `'400 Bad Request'` | — |
| [`HttpUnauthorizedException`](#slim-exception-httpunauthorizedexception) | `Slim/Exception/HttpUnauthorizedException.php` | `401` | `'Unauthorized.'` | `'401 Unauthorized'` | — |
| [`HttpForbiddenException`](#slim-exception-httpforbiddenexception) | `Slim/Exception/HttpForbiddenException.php` | `403` | `'Forbidden.'` | `'403 Forbidden'` | — |
| [`HttpNotFoundException`](#slim-exception-httpnotfoundexception) | `Slim/Exception/HttpNotFoundException.php` | `404` | `'Not found.'` | `'404 Not Found'` | [`RoutingMiddleware`](04_middleware.md#slim-middleware-routingmiddleware) が自動送出 |
| [`HttpMethodNotAllowedException`](#slim-exception-httpmethodnotallowedexception) | `Slim/Exception/HttpMethodNotAllowedException.php` | `405` | `'Method not allowed.'` | `'405 Method Not Allowed'` | `$allowedMethods`, `getAllowedMethods()`, `setAllowedMethods()` |
| [`HttpGoneException`](#slim-exception-httpgoneexception) | `Slim/Exception/HttpGoneException.php` | `410` | `'Gone.'` | `'410 Gone'` | — |
| [`HttpTooManyRequestsException`](#slim-exception-httptoomanyrequestsexception) | `Slim/Exception/HttpTooManyRequestsException.php` | `429` | `'Too many requests.'` | `'429 Too Many Requests'` | — |
| [`HttpInternalServerErrorException`](#slim-exception-httpinternalservererrorexception) | `Slim/Exception/HttpInternalServerErrorException.php` | `500` | `'Internal server error.'` | `'500 Internal Server Error'` | — |
| [`HttpNotImplementedException`](#slim-exception-httpnotimplementedexception) | `Slim/Exception/HttpNotImplementedException.php` | `501` | `'Not implemented.'` | `'501 Not Implemented'` | — |

```drawlib align=center code=fold file=api_exceptions_propagation_flow_ja.png caption="HTTP 例外の伝播フロー — 送出箇所から ErrorMiddleware 捕捉境界・ErrorRenderer メタデータ抽出まで"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel
from drawlib.styles import Colors, Styles

setup(width=196, height=84, dpi=150)

# Left Panel: Exception Origin & Throw Sites
p_left = Panel(
    "フェーズ 1 · 例外の送出箇所とメタデータ付与",
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
    "404 NotFound または 405 MethodNotAllowed を送出",
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
    "アプリミドルウェア・ルートハンドラ",
    "400 BadRequest・401 Unauthorized 等を送出",
    badge_text="T2",
    icon=phosphor.code,
    style=Styles.PrimaryNeutral,
)
cl_left.add(
    "タイトル・説明文の動的カスタマイズ",
    "setTitle()・setDescription() で表示文言を上書き",
    badge_text="T3",
    icon=phosphor.pencil_simple,
)
cl_left.draw(xy=lx, width=lw, height=lh)

# Right Panel: ErrorMiddleware Catch & ErrorHandler Rendering
p_right = Panel(
    "フェーズ 2 · ErrorMiddleware 捕捉と描画",
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
    "完全一致またはサブクラス対応ハンドラへ委譲",
    badge_text="E1",
    icon=phosphor.funnel,
)
cl_right.add(
    "ErrorHandler ステータス・Allow 付与",
    "getCode() を取得し 405 時は Allow ヘッダを設定",
    badge_text="E2",
    icon=phosphor.scales,
    style=Styles.SecondaryNeutral,
)
cl_right.add(
    "AbstractErrorRenderer ペイロード出力",
    "getTitle()・getDescription() を安全に出力",
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

- **ソースファイル**: `Slim/Exception/HttpException.php`
- **名前空間**: `Slim\Exception`
- **継承元 (`extends`)**: `\RuntimeException`（`\Throwable` を実装）
- **直接のサブクラス**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception)
- **主な参照元**: [`Slim\Middleware\ErrorMiddleware`](04_middleware.md#slim-middleware-errormiddleware), [`Slim\Handlers\ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler), [`Slim\Error\AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer)

`HttpException` は Slim 4 におけるすべての HTTP 例外の基底クラスです。例外送出時の PSR-7 `ServerRequestInterface` インスタンスを保持し、`$displayErrorDetails = false`（本番環境）であっても [`AbstractErrorRenderer`](06_error_renderers.md#slim-error-abstracterrorrenderer) が安全に利用者向けエラー画面・JSON を出力できるよう `$title` と `$description` の Fluent ゲッタ／セッタを提供します。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ・メソッド一覧

| メンバ | 可視性・型 | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `$request` | `protected ServerRequestInterface` | — | — | 例外送出時に処理中だった PSR-7 サーバリクエスト。 |
| `$title` | `protected string` | — | — | 人間が判読可能なエラータイトル（既定値 `''`）。 |
| `$description` | `protected string` | — | — | エラーの詳細説明文（既定値 `''`）。 |
| `__construct()` | `public` | `ServerRequestInterface $request`, `string $message = ''`, `int $code = 0`, `?Throwable $previous = null` | `void` | `parent::__construct($message, $code, $previous)` を呼び出し、`$this->request = $request` を保存します。 |
| `getRequest()` | `public` | *(なし)* | `ServerRequestInterface` | 保持している PSR-7 `ServerRequestInterface` を返します。 |
| `getTitle()` | `public` | *(なし)* | `string` | [`AbstractErrorRenderer::getErrorTitle()`](06_error_renderers.md#slim-error-abstracterrorrenderer) が使用するタイトル文字列を返します。 |
| `setTitle()` | `public` | `string $title` | `self` | エラータイトルを上書きし、Fluent チェーン用に `$this` を返します。 |
| `getDescription()` | `public` | *(なし)* | `string` | [`AbstractErrorRenderer::getErrorDescription()`](06_error_renderers.md#slim-error-abstracterrorrenderer) が使用する説明文を返します。 |
| `setDescription()` | `public` | `string $description` | `self` | エラー説明文を上書きし、Fluent チェーン用に `$this` を返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpSpecializedException.php`
- **名前空間**: `Slim\Exception`
- **継承元 (`extends`)**: [`Slim\Exception\HttpException`](#slim-exception-httpexception)
- **クラス修飾子**: `abstract class`
- **直接のサブクラス**: [`HttpBadRequestException`](#slim-exception-httpbadrequestexception), [`HttpUnauthorizedException`](#slim-exception-httpunauthorizedexception), [`HttpForbiddenException`](#slim-exception-httpforbiddenexception), [`HttpNotFoundException`](#slim-exception-httpnotfoundexception), [`HttpMethodNotAllowedException`](#slim-exception-httpmethodnotallowedexception), [`HttpGoneException`](#slim-exception-httpgoneexception), [`HttpTooManyRequestsException`](#slim-exception-httptoomanyrequestsexception), [`HttpInternalServerErrorException`](#slim-exception-httpinternalservererrorexception), [`HttpNotImplementedException`](#slim-exception-httpnotimplementedexception)

`HttpSpecializedException` は HTTP ステータスコード別の具象例外クラス群の抽象中間基底クラスです。コンストラクタ引数を `($request, ?$message = null, ?$previous = null)` の 3 引数に簡略化し、サブクラス側で宣言された `$this->code` と既定 `$this->message` を親クラス [`HttpException::__construct()`](#slim-exception-httpexception) へ自動転送します。

### PHP クラスシグネチャ

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

### コンストラクタ仕様

| メンバ | 可視性・型 | 引数 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `__construct()` | `public` | `ServerRequestInterface $request`, `?string $message = null`, `?Throwable $previous = null` | `void` | `$message !== null` の場合のみ `$this->message` を上書きし、`parent::__construct($request, $this->message, $this->code, $previous)` を呼び出します。 |

### 使用例

```php
use Slim\Exception\HttpSpecializedException;

// アプリ固有の 409 Conflict 例外を定義する例:
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

- **ソースファイル**: `Slim/Exception/HttpBadRequestException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

リクエスト構文、クエリパラメータ、またはリクエストボディのバリデーション失敗時に送出する **HTTP `400 Bad Request`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `400` | HTTP ステータスコード `400`。 |
| `$message` | `protected string` | `'Bad request.'` | `$message` 引数省略時の既定例外メッセージ。 |
| `$title` | `protected string` | `'400 Bad Request'` | [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) が描画する既定タイトル。 |
| `$description` | `protected string` | `'The server cannot or will not process the request due to an apparent client error.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpUnauthorizedException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

有効な認証資格情報（Bearer トークンやセッション等）が欠落・失効している場合に送出する **HTTP `401 Unauthorized`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `401` | HTTP ステータスコード `401`。 |
| `$message` | `protected string` | `'Unauthorized.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'401 Unauthorized'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The request requires valid user authentication.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpForbiddenException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

認証済みユーザに対象操作の実行権限（ロール・スコープ）がない場合に送出する **HTTP `403 Forbidden`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `403` | HTTP ステータスコード `403`。 |
| `$message` | `protected string` | `'Forbidden.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'403 Forbidden'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'You are not permitted to perform the requested operation.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpNotFoundException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`
- **自動送出元**: `RoutingResults::getRouteStatus()` が `RoutingResults::NOT_FOUND` (`0`) の際に [`Slim\Middleware\RoutingMiddleware::performRouting()`](04_middleware.md#slim-middleware-routingmiddleware) が自動送出するほか、ルートハンドラ内でのエンティティ未検出時にも利用されます。

リクエスト URI に一致するルートが存在しない場合や、対象リソースが存在しない場合に送出する **HTTP `404 Not Found`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `404` | HTTP ステータスコード `404`。 |
| `$message` | `protected string` | `'Not found.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'404 Not Found'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The requested resource could not be found. Please verify the URI and try again.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpMethodNotAllowedException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`
- **自動送出元**: `RoutingResults::getRouteStatus()` が `RoutingResults::METHOD_NOT_ALLOWED` (`2`) の際に [`Slim\Middleware\RoutingMiddleware::performRouting()`](04_middleware.md#slim-middleware-routingmiddleware) が自動送出します。
- **`ErrorHandler` での特別処理**: [`ErrorHandler::createResponse()`](05_handlers_and_strategies.md#slim-handlers-errorhandler) は `$this->exception instanceof HttpMethodNotAllowedException` を判定し、`getAllowedMethods()` の内容を HTTP レスポンスの `Allow` ヘッダへ自動出力します。

URI パターンは一致したものの、リクエストされた HTTP メソッドが許可されていない場合に送出される **HTTP `405 Method Not Allowed`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ・メソッド一覧

| メンバ | 可視性・型 | 引数／既定値 | 戻り値型 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `$allowedMethods` | `protected string[]` | `[]` | — | 当該 URI パターンで許可されている HTTP メソッド配列。 |
| `$code` | `protected int` | `405` | — | HTTP ステータスコード `405`。 |
| `$message` | `protected string` | `'Method not allowed.'` | — | 既定メッセージ（`setAllowedMethods()` 呼び出し時に自動更新）。 |
| `$title` | `protected string` | `'405 Method Not Allowed'` | — | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The request method is not supported for the requested resource.'` | — | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | `void` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |
| `getAllowedMethods()` | `public` | *(なし)* | `string[]` | 許可されている HTTP メソッド配列（例: `['GET', 'POST']`）を返します。 |
| `setAllowedMethods()` | `public` | `string[] $methods` | `self` | `$this->allowedMethods = $methods` を保存し、`$this->message` を `'Method not allowed. Must be one of: ' . implode(', ', $methods)` に更新して `$this` を返します。 |

### 使用例

```php
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpMethodNotAllowedException;

$exception = new HttpMethodNotAllowedException($request);
$exception->setAllowedMethods(['GET', 'HEAD', 'POST']);
// $exception->getMessage() === 'Method not allowed. Must be one of: GET, HEAD, POST'
throw $exception;
```

---

## `class` Slim\Exception\HttpGoneException

- **ソースファイル**: `Slim/Exception/HttpGoneException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

対象リソースがオリジンサーバから恒久的に廃止・削除されたことを示す **HTTP `410 Gone`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `410` | HTTP ステータスコード `410`。 |
| `$message` | `protected string` | `'Gone.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'410 Gone'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The target resource is no longer available at the origin server.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpTooManyRequestsException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

クライアントが一定期間内のリクエスト上限（レートリミット）を超過した際に送出する **HTTP `429 Too Many Requests`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `429` | HTTP ステータスコード `429`。 |
| `$message` | `protected string` | `'Too many requests.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'429 Too Many Requests'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The client application has surpassed its rate limit, or number of requests they can send in a given period of time.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpInternalServerErrorException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

予期しない内部状態や下流システム障害によりリクエスト処理を継続できない場合に送出する **HTTP `500 Internal Server Error`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `500` | HTTP ステータスコード `500`。 |
| `$message` | `protected string` | `'Internal server error.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'500 Internal Server Error'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'Unexpected condition encountered preventing server from fulfilling request.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

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

- **ソースファイル**: `Slim/Exception/HttpNotImplementedException.php`
- **名前空間**: `Slim\Exception`
- **継承階層**: [`Slim\Exception\HttpSpecializedException`](#slim-exception-httpspecializedexception) -> [`Slim\Exception\HttpException`](#slim-exception-httpexception) -> `\RuntimeException`

リクエストを処理するための機能がサーバ側でまだサポート・実装されていない場合に送出する **HTTP `501 Not Implemented`** 例外です。

### PHP クラスシグネチャ

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

### プロパティ・コンストラクタ

| メンバ | 可視性・型 | 既定値／シグネチャ | 説明 |
| :--- | :--- | :--- | :--- |
| `$code` | `protected int` | `501` | HTTP ステータスコード `501`。 |
| `$message` | `protected string` | `'Not implemented.'` | 既定の例外メッセージ。 |
| `$title` | `protected string` | `'501 Not Implemented'` | 既定のエラータイトル。 |
| `$description` | `protected string` | `'The server does not support the functionality required to fulfill the request.'` | 既定の説明文。 |
| `__construct()` | `public` | `ServerRequestInterface $request, ?string $message = null, ?Throwable $previous = null` | [`HttpSpecializedException`](#slim-exception-httpspecializedexception) から継承。 |

### 使用例

```php
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Exception\HttpNotImplementedException;

$app->post('/reports/pdf', function (Request $request, Response $response): Response {
    throw new HttpNotImplementedException($request, 'Direct PDF export is not yet implemented.');
});
```
