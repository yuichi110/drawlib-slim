# Slim Framework 4 User Guide, API Reference, Architecture & PNI501 Audit (`drawlib-slim`)

> **Unofficial Multi-Portal Documentation & Diagnostic Suite — Built with [Drawlib](https://www.drawlib.com/) & [PNI501](https://pypi.org/project/pni501/)**
>
> This repository hosts an **independent, unofficial** four-portal documentation, PSR-7/PSR-15/PSR-11 API catalog, internal architecture guide, and software diagnostic site covering **[Slim Framework 4](https://www.slimframework.com/)** (`v4.15.3`, tag `4.15.3` / commit `3675bf6b`).
> For official Slim Framework documentation, release notes, and issue tracking, always visit **[https://www.slimframework.com/](https://www.slimframework.com/)**.

---

## Live Portals (`https://slim.drawlib.com/`)

1. **Slim 4 User Guide (`docs_src/` -> `docs/`)**: [https://slim.drawlib.com/](https://slim.drawlib.com/) (English & 日本語)
   - Practical user guide, enterprise PSR-7 / PSR-15 / PSR-11 application patterns, FastRoute routing & route groups, concentric middleware pipeline, PHP-DI dependency injection, error handling & content-negotiated renderers, and PHPUnit testing recipes backed by `v4.15.3` examples.
2. **Slim 4 API Reference Catalog (`api_src/` -> `docs/api/`)**: [https://slim.drawlib.com/api/](https://slim.drawlib.com/api/) (English & 日本語)
   - Searchable symbol catalog (`type = "catalog"`) covering every public PHP class and interface across `Slim\App`, `Slim\Factory\*` (`AppFactory`, `ServerRequestCreatorFactory`, PSR-17 providers), `Slim\Routing\*` (`RouteCollectorProxy`, `RouteCollector`, `Route`, `RouteGroup`, `RouteContext`, `RouteParser`, `RouteRunner`, `FastRouteDispatcher`), `Slim\Middleware\*` (`ErrorMiddleware`, `BodyParsingMiddleware`, `RoutingMiddleware`, `ContentLengthMiddleware`, `MethodOverrideMiddleware`, `OutputBufferingMiddleware`), `Slim\Handlers\*`, `Slim\Error\Renderers\*`, `Slim\Exception\Http*Exception`, and `Slim\Interfaces\*`.
3. **Slim 4 Internal Architecture Guide (`architecture_src/` -> `docs/architecture/`)**: [https://slim.drawlib.com/architecture/](https://slim.drawlib.com/architecture/) (English & 日本語)
   - Source-level walkthrough of how Slim `v4.15.3` (`Slim\`) works internally: PSR-7/11/15/17 package topology, `AppFactory` & `Psr17FactoryProvider` auto-discovery bootstrap, `MiddlewareDispatcher` LIFO concentric onion wrapping and deferred callable/container resolution, `RouteCollector` & `FastRouteDispatcher` regex compilation and `RouteRunner` + `RequestHandlerInvocationStrategyInterface` dispatch, `ErrorMiddleware` & `ErrorHandler` content negotiation across JSON/XML/HTML/PlainText renderers, and `ResponseEmitter` chunked stream emission.
4. **PNI501 Engineering & Architecture Diagnostic Report (`reports_src/pni501_src/` -> `docs/reports/pni501/`)**: [https://slim.drawlib.com/reports/pni501/](https://slim.drawlib.com/reports/pni501/) ([PDF](https://slim.drawlib.com/reports/pni501/pni501.pdf))
   - Deterministic 15-stage PHP AST, namespace dependency DAG, PSR library hygiene, hermetic PHPUnit + PCOV container runtime, and supply-chain diagnostic audit.

---

## Repository Layout

```text
drawlib-slim/
├── Slim/                     # Upstream Slim v4.15.3 PHP source (MIT License, unmodified)
├── tests/                    # Upstream Slim v4.15.3 PHPUnit test suite (MIT License, unmodified)
├── composer.json             # Upstream Slim v4.15.3 Composer manifest (unmodified)
├── composer.lock             # Deterministic Composer lockfile for offline verification & supply-chain audit
├── phpunit.xml.dist          # Upstream PHPUnit configuration (unmodified)
├── phpstan.neon.dist         # Upstream PHPStan static analysis configuration (unmodified)
├── phpcs.xml.dist            # Upstream PHP_CodeSniffer PSR-12 configuration (unmodified)
├── psalm.xml                 # Upstream Psalm configuration (unmodified)
├── LICENSE-SLIM              # Upstream MIT License (Copyright (c) 2011-2026 Josh Lockhart)
├── LICENSE                   # Apache-2.0 License for original documentation, diagrams & audit assets
├── .pni/                     # PNI501 workflow & PHP audit configuration
├── docs_src/                 # Portal 1: Slim 4 User Guide source (bilingual en/ja, type = "site")
├── api_src/                  # Portal 2: Slim 4 API Reference source (bilingual en/ja, type = "catalog")
├── architecture_src/         # Portal 3: Slim 4 Internal Architecture Guide source (bilingual en/ja, type = "site")
├── reports_src/
│   └── pni501_src/           # Portal 4: PNI501 diagnostic report source (type = "doc")
└── docs/                     # Unified compiled GitHub Pages output (CNAME: slim.drawlib.com)
    ├── index.html            # User Guide root
    ├── api/                  # API Reference Catalog
    ├── architecture/         # Internal Architecture Guide
    └── reports/
        └── pni501/           # PNI501 HTML & PDF report
```

---

## Installation & Quickstart (Slim Framework 4)

Install Slim 4 and a PSR-7 implementation (such as `slim/psr7` or `nyholm/psr7`) via Composer:

```bash
composer require slim/slim:"4.*" slim/psr7
```

Create `public/index.php` using `AppFactory::create()`:

```php
<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Slim\Factory\AppFactory;

require __DIR__ . '/../vendor/autoload.php';

$app = AppFactory::create();

$app->addBodyParsingMiddleware();
$app->addRoutingMiddleware();
$app->addErrorMiddleware(true, true, true);

$app->get('/hello/{name}', function (Request $request, Response $response, array $args): Response {
    $name = $args['name'];
    $response->getBody()->write(json_encode(['message' => "Hello, {$name}!"], JSON_THROW_ON_ERROR));
    return $response->withHeader('Content-Type', 'application/json');
});

$app->run();
```

---

## Reproducing Locally with `uvx`

`Slim/`, `tests/`, `composer.json`, and `phpunit.xml.dist` remain unmodified from upstream Slim `v4.15.3`; `drawlib` and `pni501` run ephemerally via `uvx` without polluting the PHP repository with Python virtual environments:

```bash
# Build all 4 portals (User Guide + API Catalog + Internal Architecture + PNI501 HTML/PDF) & check links
./build.sh

# Or build each portal individually:
./docs_src/build_html.sh
./api_src/build_html.sh
./architecture_src/build_html.sh
uvx --default-index https://pypi.org/simple --from pni501 pni report build pni501 \
  --src-dir reports_src \
  --html-output-dir docs/reports/pni501 \
  --output-dir docs/reports/pni501 \
  -f html -f pdf

# Preview locally & verify zero broken links
uvx --default-index https://pypi.org/simple drawlib@0.3.9 serve docs/ --check
uvx --default-index https://pypi.org/simple drawlib@0.3.9 serve docs/

# Run upstream Slim 4.15.3 PHPUnit test suite, PHPCS & PHPStan
composer test
```

---

## Testing, Contributing & Security

- **Automated Test Suite**: See [`tests/`](./tests/) and [`phpunit.xml.dist`](./phpunit.xml.dist) for the upstream PHPUnit test suite, [`phpstan.neon.dist`](./phpstan.neon.dist) for PHPStan static analysis, and [`phpcs.xml.dist`](./phpcs.xml.dist) for PSR-12 coding standards.
- **Contributing Guidelines**: See [`CONTRIBUTING.md`](./CONTRIBUTING.md) and [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).
- **Security Policy**: See [`SECURITY.md`](./SECURITY.md) for vulnerability disclosure procedures.

---

## Licensing & Attribution Notice

- **Upstream Slim Framework Snapshot (`Slim/`, `tests/`, `composer.json`, `phpunit.xml.dist`, `phpstan.neon.dist`, `phpcs.xml.dist`, `psalm.xml`)**:
  Copyright (c) 2011-2026 Josh Lockhart. Distributed under the **MIT License** — see [`LICENSE-SLIM`](./LICENSE-SLIM).
- **Original Documentation, API Catalog, Diagrams & PNI501 Audit (`docs_src/`, `api_src/`, `architecture_src/`, `reports_src/`, `docs/`, `.pni/`, build scripts)**:
  Copyright (c) 2026 Yuichi Ito. Distributed under the **Apache License, Version 2.0** — see [`LICENSE`](./LICENSE).
- **Attribution**:
  Slim Framework is created and maintained by Josh Lockhart and the Slim Framework team. This repository is an independent community documentation and architecture study built with [Drawlib](https://www.drawlib.com/) and [PNI501](https://pypi.org/project/pni501/) and is not affiliated with, sponsored by, or endorsed by the official Slim Framework project.