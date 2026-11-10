# In-Memory HTTP Testing with PHPUnit

Because `Slim\App` implements **PSR-15** `RequestHandlerInterface` (`public function handle(ServerRequestInterface $request): ResponseInterface`), you can test your entire HTTP pipeline—including `ErrorMiddleware`, `BodyParsingMiddleware`, `RoutingMiddleware`, `JwtAuthenticationMiddleware`, FastRoute parameter extraction, and Single-Action Controllers—**entirely in memory inside PHPUnit** without opening a TCP socket or booting a web server.

```drawlib align=center code=fold file=phpunit_inmemory_testing.png caption="Slim 4 In-Memory HTTP Testing Pipeline — PSR-17 Request Construction, PSR-11 Container Overrides, and $app->handle($request) Assertions"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.shapes import rectangle
from drawlib.smartarts import CardList, ChevronProcess, Panel
from drawlib.styles import Styles
from drawlib.text import text

setup(width=196, height=76, dpi=150)

outer = Panel(
    "Sub-Millisecond In-Memory HTTP Testing via $app->handle(ServerRequestInterface)",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.5),
    icon=phosphor.flask,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
outer.draw((4.0, 4.0), width=188.0, height=68.0)

proc = ChevronProcess(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.2),
    description_style=Styles.Dark.patch(text_size=10.0),
    corner_angle=62.0,
    spacing=1.6,
    flat_left_end=True,
)
proc.add(
    "1. Boot Fresh App",
    description="DI Container + Routes",
    style=Styles.SecondaryNeutral,
)
proc.add(
    "2. Override Mocks",
    description="$container->set(...)",
    style=Styles.PrimaryNeutral,
)
proc.add(
    "3. PSR-17 Request",
    description="Headers + JSON Stream",
    style=Styles.White,
)
proc.add(
    "4. $app->handle()",
    description="Full PSR-15 Pipeline",
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.2),
    description_style=Styles.White.patch(text_size=10.0),
)
proc.add(
    "5. Assert Response",
    description="Status, Headers, JSON",
    style=Styles.SecondaryNeutral,
)
proc.draw(xy=(8.0, 41.5), width=180.0, height=19.5)

cards = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
    direction="horizontal",
    spacing=3.5,
)
cards.add(
    "Zero Network I/O",
    "Bypasses ServerRequestCreator\n& ResponseEmitter sockets",
    badge_text="1ms",
    icon=phosphor.lightning,
)
cards.add(
    "Real Middleware Onion",
    "Tests Auth, RBAC, FastRoute,\nBodyParsing & ErrorHandler",
    badge_text="PSR",
    icon=phosphor.stack,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_size=10.0),
    icon_style=Styles.WhiteBold,
)
cards.add(
    "Isolated Domain Mocks",
    "Swap DB / external APIs via\nPSR-11 Container->set()",
    badge_text="DI",
    icon=phosphor.plugs_connected,
)
cards.draw(xy=(8.0, 8.0), width=180.0, height=29.5)

save()
```

## Why Slim 4 Excels at Sub-Millisecond In-Memory HTTP Testing

In legacy frameworks that read directly from `$_SERVER`, `$_POST`, `php://input`, or emit `header()` and `echo` calls inside controllers, testing an HTTP endpoint requires either heavy process isolation or a live web server. Slim 4 cleanly separates **I/O boundary adapters** (`$app->run()`) from **pure PSR-7/PSR-15 request handling** (`$app->handle($request)`):

| Execution Method | Input Source | Pipeline Executed | Output Destination | Primary Use Case |
| :--- | :--- | :--- | :--- | :--- |
| `$app->run()` | `ServerRequestCreatorFactory` reads `$_SERVER`, `$_GET`, `$_POST`, `$_COOKIE`, `$_FILES` | `MiddlewareDispatcher` -> `RouteRunner` -> `Route` | `ResponseEmitter::emit()` calls `header()` and `echo` | Production PHP-FPM front controller (`public/index.php`) |
| `$app->handle($request)` | Synthetic PSR-7 `ServerRequestInterface` built via PSR-17 factory | Exact same `MiddlewareDispatcher` -> `RouteRunner` -> `Route` | Returns immutable PSR-7 `ResponseInterface` directly to caller | PHPUnit integration tests & worker runtimes (RoadRunner, FrankenPHP) |

## The Slim 4 Testing Pyramid

A well-tested Slim 4 codebase combines three complementary testing tiers so business rules, HTTP middleware wiring, and external infrastructure adapters are verified without brittle end-to-end browser overhead:

```drawlib align=center code=fold file=test_pyramid_slim.png caption="Slim 4 Testing Pyramid — Pure Domain Unit Tests, In-Memory $app->handle($request) Pipeline Tests, and Infrastructure Contract Tests"
from drawlib.canvas import save, setup
from drawlib.icons import phosphor
from drawlib.smartarts import CardList, Panel, Pyramid
from drawlib.styles import Styles

setup(width=196, height=76, dpi=150)

outer = Panel(
    "Slim 4 Testing Pyramid & Verification Scope",
    style=Styles.Neutral.patch(shape_r=2.0),
    header_style=Styles.PrimaryNeutral.patch(shape_line_width=1.2),
    text_style=Styles.DarkBold.patch(text_size=11.5),
    icon=phosphor.chart_bar,
    icon_style=Styles.PrimaryBold,
    header_variant="filled",
    header_height=8.5,
)
outer.draw((4.0, 4.0), width=188.0, height=68.0)

pyr = Pyramid(
    style=Styles.Neutral,
    text_style=Styles.DarkBold.patch(text_size=10.2),
)
pyr.add(
    "3. Contract\nTests (10%)",
    style=Styles.SecondaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=10.0),
)
pyr.add(
    "2. In-Memory HTTP\n$app->handle (35%)",
    style=Styles.PrimaryFlat,
    text_style=Styles.WhiteBold.patch(text_size=10.0),
)
pyr.add(
    "1. Domain & Service\nUnit Tests (55%)",
    style=Styles.PrimaryNeutral,
    text_style=Styles.DarkBold.patch(text_size=10.2),
)
pyr.draw(
    xy=(8.0, 10.0),
    width=80.0,
    height=48.0,
    margin=2.0,
    direction="bottom",
    order="vertex_to_base",
)

details = CardList(
    style=Styles.White,
    text_style=Styles.DarkBold.patch(text_size=10.5),
    description_style=Styles.Dark.patch(text_size=10.0),
    badge_shape="rounded_rect",
    badge_style=Styles.PrimaryNeutral,
    badge_text_style=Styles.PrimaryBold.patch(text_size=10.0),
    icon_style=Styles.PrimaryBold,
    direction="vertical",
    spacing=2.5,
)
details.add(
    "Tier 3 · DB & OpenAPI Contracts",
    "Verify SQL queries & OpenAPI schemas",
    badge_text="10%",
    icon=phosphor.database,
)
details.add(
    "Tier 2 · In-Memory HTTP ($app->handle)",
    "FastRoute, JWT/RBAC, Actions & Errors",
    badge_text="35%",
    icon=phosphor.arrows_left_right,
    style=Styles.SecondaryNeutral,
    badge_style=Styles.PrimaryFlat,
    badge_text_style=Styles.WhiteBold.patch(text_size=10.0),
    icon_style=Styles.WhiteBold,
)
details.add(
    "Tier 1 · Pure Domain & Use Cases",
    "Zero HTTP imports; fast business logic",
    badge_text="55%",
    icon=phosphor.cube,
)
details.draw(xy=(94.0, 9.0), width=94.0, height=50.0)

save()
```

- **Tier 1 — Domain Unit Tests (`55%`)**: Instantiate domain entities, value objects, and application services directly without booting Slim or PHP-DI.
- **Tier 2 — In-Memory HTTP Pipeline Tests (`35%`)**: Boot `App` with real routes and middlewares, override external repositories or gateways in the PSR-11 container, and invoke `$response = $app->handle($request)`.
- **Tier 3 — Infrastructure & Contract Tests (`10%`)**: Verify SQL queries against a test database transaction and validate JSON responses against your OpenAPI 3.1 specification.

## Reusable AppTestTrait for PSR-7 Request Construction & Assertions

Creating a reusable `AppTestTrait` gives every PHPUnit test case ergonomic helper methods for building PSR-7 requests (`createRequest()`, `createJsonRequest()`) using your container's PSR-17 `ServerRequestFactoryInterface` and `StreamFactoryInterface`, plus fluent assertions for JSON payloads:

```php
<?php

declare(strict_types=1);

namespace Tests\Support;

use DI\Container;
use DI\ContainerBuilder;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestFactoryInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Message\StreamFactoryInterface;
use Slim\App;
use Slim\Factory\AppFactory;

trait AppTestTrait
{
    protected Container $container;

    /** @var App<Container> */
    protected App $app;

    protected function setUpApp(): void
    {
        $builder = new ContainerBuilder();
        (require __DIR__ . '/../../config/dependencies.php')($builder);

        $this->container = $builder->build();
        $this->app = AppFactory::createFromContainer($this->container);

        (require __DIR__ . '/../../config/middleware.php')($this->app);
        (require __DIR__ . '/../../config/routes.php')($this->app);
    }

    /**
     * @param array<string, string> $headers
     * @param array<string, mixed>  $queryParams
     * @param array<string, string> $cookies
     */
    protected function createRequest(
        string $method,
        string $path,
        array $headers = ['Accept' => 'application/json'],
        array $queryParams = [],
        array $cookies = []
    ): ServerRequestInterface {
        /** @var ServerRequestFactoryInterface $requestFactory */
        $requestFactory = $this->container->get(ServerRequestFactoryInterface::class);
        $request = $requestFactory
            ->createServerRequest($method, $path)
            ->withQueryParams($queryParams)
            ->withCookieParams($cookies);

        foreach ($headers as $name => $value) {
            $request = $request->withHeader($name, $value);
        }

        return $request;
    }

    /**
     * @param array<string, mixed>  $payload
     * @param array<string, string> $headers
     */
    protected function createJsonRequest(
        string $method,
        string $path,
        array $payload,
        array $headers = []
    ): ServerRequestInterface {
        /** @var StreamFactoryInterface $streamFactory */
        $streamFactory = $this->container->get(StreamFactoryInterface::class);
        $json = json_encode($payload, JSON_THROW_ON_ERROR);

        $request = $this->createRequest(
            $method,
            $path,
            array_merge(
                [
                    'Accept' => 'application/json',
                    'Content-Type' => 'application/json',
                ],
                $headers
            )
        );

        return $request->withBody($streamFactory->createStream($json));
    }

    /**
     * @return array<string, mixed>
     */
    protected function assertJsonResponse(
        ResponseInterface $response,
        int $expectedStatus
    ): array {
        self::assertSame($expectedStatus, $response->getStatusCode());
        self::assertStringContainsString(
            'application/json',
            $response->getHeaderLine('Content-Type')
        );

        $body = (string) $response->getBody();
        /** @var array<string, mixed> $decoded */
        $decoded = json_decode($body, true, 512, JSON_THROW_ON_ERROR);

        return $decoded;
    }
}
```

## Mocking PSR-11 Container Dependencies & Testing Middleware Pipelines

Because Slim's `CallableResolver` and `MiddlewareDispatcher` resolve controllers and middleware classes lazily from the PSR-11 container when `$app->handle($request)` is called, you can override any repository or external gateway in `$this->container->set(...)` right inside your test method before dispatching the request:

```php
<?php

declare(strict_types=1);

namespace Tests\Feature\User;

use App\Domain\User\User;
use App\Domain\User\UserRepositoryInterface;
use App\Security\JwtTokenVerifierInterface;
use PHPUnit\Framework\TestCase;
use Tests\Support\AppTestTrait;

final class CreateUserActionTest extends TestCase
{
    use AppTestTrait;

    protected function setUp(): void
    {
        $this->setUpApp();
    }

    public function testCreateUserReturns201WhenAuthenticatedAsAdmin(): void
    {
        // 1. Override JWT verifier and UserRepository in the PSR-11 container
        $verifier = $this->createStub(JwtTokenVerifierInterface::class);
        $verifier->method('verify')->willReturn([
            'sub' => 'usr_admin_01',
            'roles' => ['admin'],
            'scope' => 'users:write users:read',
        ]);
        $this->container->set(JwtTokenVerifierInterface::class, $verifier);

        $repository = $this->createMock(UserRepositoryInterface::class);
        $repository->expects(self::once())
            ->method('save')
            ->willReturn(new User(id: 42, email: 'alice@example.com', role: 'editor'));
        $this->container->set(UserRepositoryInterface::class, $repository);

        // 2. Build PSR-7 POST request with JSON stream and Bearer header
        $request = $this->createJsonRequest(
            method: 'POST',
            path: '/api/v1/admin/users',
            payload: ['email' => 'alice@example.com', 'role' => 'editor'],
            headers: ['Authorization' => 'Bearer eyJhbGciOiJIUzI1NiJ9.e30.sig']
        );

        // 3. Execute full PSR-15 pipeline in memory (BodyParsingMiddleware -> Routing -> JWT -> RBAC -> Action)
        $response = $this->app->handle($request);

        // 4. Assert status code, headers, and decoded JSON body
        $data = $this->assertJsonResponse($response, 201);
        self::assertSame(42, $data['id']);
        self::assertSame('alice@example.com', $data['email']);
    }

    public function testCreateUserReturns401WhenAuthorizationHeaderIsMissing(): void
    {
        $request = $this->createJsonRequest(
            method: 'POST',
            path: '/api/v1/admin/users',
            payload: ['email' => 'alice@example.com']
        );

        $response = $this->app->handle($request);

        $error = $this->assertJsonResponse($response, 401);
        self::assertSame('401 Unauthorized', $error['message']);
    }

    public function testUnknownRouteReturns404ViaErrorMiddleware(): void
    {
        $request = $this->createRequest('GET', '/api/v1/non-existent-endpoint');

        $response = $this->app->handle($request);

        $error = $this->assertJsonResponse($response, 404);
        self::assertSame('404 Not Found', $error['message']);
    }
}
```

## Running PHPUnit & Static Analysis in CI

Combine fast in-memory PHPUnit tests with static analysis (`phpstan` / `psalm`) and strict coding standards in your continuous integration workflow:

```bash
# Run the full unit and in-memory HTTP test suite
vendor/bin/phpunit --colors=always --testdox

# Run with Xdebug / PCOV line coverage enforcement
XDEBUG_MODE=coverage vendor/bin/phpunit --coverage-text

# Verify strict types and PSR-7/PSR-15 contracts with PHPStan
vendor/bin/phpstan analyse src tests --level=max
```

Once your test suite passes, proceed to **[Nginx, PHP-FPM & Worker Runtimes](production_deployment.md)** to configure Composer classmap optimization, FastRoute caching, PHP-DI compilation, OPcache preloading, and RoadRunner / FrankenPHP workers. For a complete audit of Slim 4's own test suite and static analysis results, see the **[PNI501 Security & Quality Audit Portal](https://slim.drawlib.com/reports/pni501/)** and **[Slim 4 API Reference](https://slim.drawlib.com/api/)**.
