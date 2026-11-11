# Slim 4 内部構造

- [アーキテクチャ全体像](index.md)

## 1. パッケージ階層と境界設計
- [5層モジュール構造と依存関係分析](01_package_and_layers/module_hierarchy.md)

## 2. ブートストラップと PSR-17 自動検出
- [AppFactory と Psr17FactoryProvider 内部実装](02_bootstrap_and_psr17/app_factory_internals.md)

## 3. ミドルウェア玉ねぎ構造と Callable 解決
- [MiddlewareDispatcher と CallableResolver 内部実装](03_middleware_and_resolver/middleware_dispatcher_internals.md)

## 4. FastRoute と RouteRunner エンジン
- [FastRouteDispatcher・RouteRunner・実行戦略](04_routing_engine/fastroute_and_runner_internals.md)

## 5. 例外処理サブシステムとレンダラ
- [ErrorMiddleware・ErrorHandler・レンダラ群](05_error_subsystem/error_middleware_and_renderers.md)

## 6. SAPI レスポンス送出機構
- [ResponseEmitter と OutputBuffering 内部実装](06_sapi_emission/response_emitter_internals.md)

## 関連ガイド & 公式リンク
- [Slim 4 ユーザーガイド](https://slim.drawlib.com/user_guide/)
- [Slim 4 API リファレンス](https://slim.drawlib.com/api/)
- [PNI501 診断レポート](https://slim.drawlib.com/pni501/)
- [Slim Framework 公式ドキュメント](https://www.slimframework.com/)
- [GitHub リポジトリ](https://github.com/yuichi110/drawlib-slim)
