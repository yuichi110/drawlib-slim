# エラーレンダラ (Error Renderers)

`Slim\Error` および `Slim\Error\Renderers` 名前空間は、抽象基底クラス [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) と、[`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) を実装する 4 つの具体的なエラーフォーマッタを提供します。これらは [`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) による `Accept` ヘッダのコンテンツネゴシエーション（またはエラーロガーのフォーマッタ）から呼び出され、`displayErrorDetails` フラグに応じて `Throwable` を JSON・HTML・XML・Plain Text 文字列へとシリアライズします。

```drawlib align=center code=fold file=p2_renderers_class_hierarchy_ja.png caption="Slim\Error クラス階層とデフォルト MIME Content-Type マッピング"
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

## エラーレンダラ一覧

| クラス | 名前空間 | 登録 MIME タイプ | 例外チェーン走査 (`getPrevious()`) | 主な出力フォーマット |
| :--- | :--- | :--- | :--- | :--- |
| [`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) | `Slim\Error` | *(抽象基底クラス)* | なし | `HttpException` のタイトル・説明文、またはデフォルト文字列を解決します。 |
| [`JsonErrorRenderer`](#slim-error-renderers-jsonerrorrenderer) | `Slim\Error\Renderers` | `application/json`, `*+json` | あり (`do ... while`) | `message` とオプションの `exception` 配列を持つ整形済み JSON オブジェクト。 |
| [`HtmlErrorRenderer`](#slim-error-renderers-htmlerrorrenderer) | `Slim\Error\Renderers` | `text/html` *(デフォルト HTTP)* | 先頭の `Throwable` のみ | インライン CSS とスタックトレースを含む完全な HTML5 ドキュメント (`<!doctype html>`)。 |
| [`XmlErrorRenderer`](#slim-error-renderers-xmlerrorrenderer) | `Slim\Error\Renderers` | `application/xml`, `text/xml`, `*+xml` | あり (`do ... while`) | `<error>` ルート要素に `<message>` CDATA と `<exception>` 要素を含む UTF-8 XML。 |
| [`PlainTextErrorRenderer`](#slim-error-renderers-plaintexterrorrenderer) | `Slim\Error\Renderers` | `text/plain` *(デフォルトロガー)* | あり (`while`) | タイトル、`Type`/`Code`/`Message`/`File`/`Line`/`Trace`、および `Previous Error:` ブロックを含むテキスト。 |

```drawlib align=center code=fold file=p2_renderers_payload_flow_ja.png caption="エラーレンダラの出力モード比較：本番モード (displayErrorDetails = false) と診断モード (displayErrorDetails = true)"
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

- **ソースファイル**: `Slim/Error/AbstractErrorRenderer.php`
- **名前空間**: `Slim\Error`
- **実装インターフェース**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`AbstractErrorRenderer` は、すべての Slim 標準エラーレンダラが継承する抽象基底クラスです。通常の `Throwable` に対してはデフォルトのエラータイトルと説明文を返し、例外が [`HttpException`](07_exceptions.md#slim-exception-httpexception)（またはそのサブクラス）である場合は HTTP ステータス固有のタイトル（`getTitle()`）と説明文（`getDescription()`）を自動的に抽出する共通ヘルパーメソッドを提供します。

### クラスシグネチャ

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

### プロパティ

| プロパティ | 可視性 | 型 | デフォルト値 | 説明 |
| :--- | :--- | :--- | :--- | :--- |
| `$defaultErrorTitle` | `protected` | `string` | `'Slim Application Error'` | `$exception` が [`HttpException`](07_exceptions.md#slim-exception-httpexception) でない場合に `getErrorTitle()` が返すデフォルトのタイトル文字列です。 |
| `$defaultErrorDescription` | `protected` | `string` | `'A website error has occurred. Sorry for the temporary inconvenience.'` | `$exception` が [`HttpException`](07_exceptions.md#slim-exception-httpexception) でない場合に `getErrorDescription()` が返すデフォルトの説明文です。 |

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | [`ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface) から継承される抽象メソッド契約です。具象サブクラスで実装されます。 |
| `getErrorTitle` | `Throwable $exception` | `string` | `protected`。`$exception instanceof HttpException` の場合は `$exception->getTitle()` を返し、それ以外は `$this->defaultErrorTitle` を返します。 |
| `getErrorDescription` | `Throwable $exception` | `string` | `protected`。`$exception instanceof HttpException` の場合は `$exception->getDescription()` を返し、それ以外は `$this->defaultErrorDescription` を返します。 |

### 使用例

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

- **ソースファイル**: `Slim/Error/Renderers/JsonErrorRenderer.php`
- **名前空間**: `Slim\Error\Renderers`
- **継承元**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **実装インターフェース**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`JsonErrorRenderer` は、捕捉された例外を整形済み JSON オブジェクト（`JSON_INVALID_UTF8_SUBSTITUTE | JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES`）へシリアライズします。[`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) では `'application/json'` に登録されているほか、正規表現 `/\+json/` にマッチするベンダーメディアタイプ（`'application/problem+json'` や `'application/vnd.api+json'` など）でも選択されます。

`$displayErrorDetails` が `false` の場合は `{"message": "<ErrorTitle>"}` のみを出力します。`$displayErrorDetails` が `true` の場合は、先頭の例外および `$exception->getPrevious()` チェーン全体を格納した `"exception"` 配列が追加されます。

### クラスシグネチャ

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

### プロパティ

[`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) から `$defaultErrorTitle` および `$defaultErrorDescription` を継承します。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | `['message' => $this->getErrorTitle($exception)]` を構築し、`$displayErrorDetails` が `true` の場合は `getPrevious()` チェーンを走査して `['exception' => [...]]` を追加し、JSON エンコード文字列を返します。 |
| `formatExceptionFragment` | `Throwable $exception` | `array<string, string\|int>` | `private` ヘルパー。単一の `Throwable` から `['type' => get_class($exception), 'code' => $code, 'message' => $exception->getMessage(), 'file' => $exception->getFile(), 'line' => $exception->getLine()]` を生成します。 |

### 使用例

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\JsonErrorRenderer;

$renderer = new JsonErrorRenderer();
$exception = new RuntimeException('Database connection timed out', 1045);

// 1. 本番出力 ($displayErrorDetails = false):
// {
//     "message": "Slim Application Error"
// }
$prodJson = $renderer($exception, false);

// 2. 詳細出力 ($displayErrorDetails = true):
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

- **ソースファイル**: `Slim/Error/Renderers/HtmlErrorRenderer.php`
- **名前空間**: `Slim\Error\Renderers`
- **継承元**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **実装インターフェース**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`HtmlErrorRenderer` は、`text/html` に登録されている Slim のデフォルト HTTP エラーレンダラ（`$defaultErrorRenderer = HtmlErrorRenderer::class`）です。最小限のインライン CSS と `Go Back` リンク（`onclick="window.history.go(-1)"`）を備えた自己完結型の HTML5 ドキュメントを出力します。

`$displayErrorDetails` が `false` の場合は、`getErrorDescription($exception)` を `htmlspecialchars(..., ENT_QUOTES | ENT_SUBSTITUTE, 'UTF-8')` でエスケープして `<p>` タグ内に出力します。`$displayErrorDetails` が `true` の場合は、`<h2>Details</h2>` セクション（`Type`, `Code`, `Message`, `File`, `Line`）と `<h2>Trace</h2><pre>...</pre>` を出力します。

### クラスシグネチャ

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

### プロパティ

[`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) から `$defaultErrorTitle` および `$defaultErrorDescription` を継承します。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | 内部 HTML フラグメント（例外詳細 + トレース、またはエスケープ済み説明文）を構築し、`renderHtmlBody()` で HTML5 ドキュメントにラップして返します。 |
| `renderHtmlBody` | `string $title = ''`, `string $html = ''` | `string` | `public` ヘルパー。`$title` をエスケープし、`<h1>{$title}</h1>`、`<div>{$html}</div>`、`Go Back` リンクを含む完全な `<!doctype html><html lang="en">...</html>` 文字列を返します。 |
| `renderExceptionFragment` | `Throwable $exception` | `string` | `private` ヘルパー。`$exception` の `Type`、`Code`、HTML エンコードされた `Message`、`File`、`Line`、および `<pre>` スタックトレースを整形します。 |

### 使用例

```php
<?php

use Slim\Error\Renderers\HtmlErrorRenderer;
use Slim\Factory\AppFactory;

$app = AppFactory::create();
$renderer = new HtmlErrorRenderer();

// renderHtmlBody() を直接呼び出してカスタム HTML エラー画面を生成
$customHtml = $renderer->renderHtmlBody(
    '404 Not Found',
    '<p>指定されたリソースはサーバー上に存在しません。</p>'
);
```

---

## `class` Slim\Error\Renderers\XmlErrorRenderer

- **ソースファイル**: `Slim/Error/Renderers/XmlErrorRenderer.php`
- **名前空間**: `Slim\Error\Renderers`
- **継承元**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **実装インターフェース**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`XmlErrorRenderer` は、例外を `<error>` ルート要素を持つ UTF-8 XML ドキュメント（`<?xml version="1.0" encoding="UTF-8" standalone="yes"?>`）へシリアライズします。[`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) では `'application/xml'` と `'text/xml'` の両方に登録されており、正規表現 `/\+(json|xml)/` により `+xml` で終わるベンダーメディアタイプにもマッチします。

メッセージ文字列（`<message>`）は `createCdataSection()` によって `<![CDATA[...]]>` セクションでラップされ、文字列内に含まれる `]]>` シーケンスは安全に `]]]]><![CDATA[>` へと分割エスケープされます。`$displayErrorDetails` が `true` の場合は、先頭の例外および `$exception->getPrevious()` チェーンを走査して各例外の `<exception>` ブロックを出力します。

### クラスシグネチャ

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

### プロパティ

[`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) から `$defaultErrorTitle` および `$defaultErrorDescription` を継承します。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | `<message>` CDATA 要素を持つ `<error>` XML を生成し、`$displayErrorDetails` が `true` の場合はチェーン内の各 `Throwable` ごとに `<exception>` 要素を追加して返します。 |
| `createCdataSection` | `string $content` | `string` | `private` ヘルパー。`$content` 内の `]]>` をエスケープした上で `<![CDATA[...]]>` セクション文字列を返します。 |

### 使用例

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\XmlErrorRenderer;

$renderer = new XmlErrorRenderer();
$xml = $renderer(new RuntimeException('Invalid XML payload', 422), true);

/*
出力結果:
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

- **ソースファイル**: `Slim/Error/Renderers/PlainTextErrorRenderer.php`
- **名前空間**: `Slim\Error\Renderers`
- **継承元**: [`Slim\Error\AbstractErrorRenderer`](#slim-error-abstracterrorrenderer)
- **実装インターフェース**: [`Slim\Interfaces\ErrorRendererInterface`](08_interfaces.md#slim-interfaces-errorrendererinterface)

`PlainTextErrorRenderer` は、例外を可読性の高いプレーンテキスト形式にフォーマットします。[`ErrorHandler`](05_handlers_and_strategies.md#slim-handlers-errorhandler) において以下の 2 つの役割を担います：
1. `Accept: text/plain` を要求する HTTP クライアント向けに `$errorRenderers['text/plain']` として登録。
2. `ErrorHandler::writeToErrorLog()` が PSR-3 [`LoggerInterface`](01_app_and_factories.md#slim-logger) にエラー文字列を出力する際のデフォルト `$logErrorRenderer` として使用。

`$displayErrorDetails`（またはログ出力時の `$logErrorDetails`）が `true` の場合は、先頭の例外の `Type`, `Code`, `Message`, `File`, `Line`, `Trace` を出力した後、`$exception->getPrevious()` チェーンが存在する限り `Previous Error:` セクションを連結して出力します。

### クラスシグネチャ

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

### プロパティ

[`AbstractErrorRenderer`](#slim-error-abstracterrorrenderer) から `$defaultErrorTitle` および `$defaultErrorDescription` を継承します。

### メソッドとパラメータ

| メソッド | パラメータと型 | 戻り値の型 | 説明 |
| :--- | :--- | :--- | :--- |
| `__invoke` | `Throwable $exception`, `bool $displayErrorDetails` | `string` | `"{$this->getErrorTitle($exception)}\n"` を返し、`$displayErrorDetails` が `true` の場合は先頭例外と各 `getPrevious()` の `formatExceptionFragment()` を連結して返します。 |
| `formatExceptionFragment` | `Throwable $exception` | `string` | `private` ヘルパー。単一の `Throwable` に対して `Type:`, `Code:`, `Message:`, `File:`, `Line:`, `Trace:` の各行を整形して返します。 |

### 使用例

```php
<?php

use RuntimeException;
use Slim\Error\Renderers\PlainTextErrorRenderer;
use Slim\Factory\AppFactory;

$app = AppFactory::create();

// PlainTextErrorRenderer をエラーログ出力用レンダラとして明示的に設定
$errorMiddleware = $app->addErrorMiddleware(false, true, true);
$errorHandler = $errorMiddleware->getDefaultErrorHandler();
$errorHandler->setLogErrorRenderer(PlainTextErrorRenderer::class);

$renderer = new PlainTextErrorRenderer();
$logEntry = $renderer(new RuntimeException('Cache backend unreachable', 503), true);
```
