# Slim 4 ユーザーガイド

- [ガイド概要](index.md)

## 1. イントロ & クイックスタート
- [Slim 4 の設計思想と PSR 標準](01_getting_started/overview.md)
- [クイックスタートと基本ミドルウェア](01_getting_started/quickstart.md)

## 2. 実践アーキテクチャ & DI 設計
- [モジュラー設計と Action コントローラ](02_enterprise_architecture/modular_design.md)
- [PSR-11 コンテナと Callable 解決](02_enterprise_architecture/di_and_containers.md)

## 3. ルーティング・グループ・呼び出し戦略
- [FastRoute パターン・グループ・キャッシュ](03_routing_and_handlers/routing_and_groups.md)
- [呼び出し戦略（Strategy）と RouteContext](03_routing_and_handlers/strategies_and_context.md)

## 4. PSR-7 メッセージ & ミドルウェア
- [PSR-7 リクエスト・レスポンス・ストリーム](04_psr7_and_middleware/requests_and_responses.md)
- [PSR-15 同心円 LIFO ミドルウェアパイプライン](04_psr7_and_middleware/middleware_pipeline.md)

## 5. セキュリティ・CORS・例外ハンドリング
- [JWT 認証・RBAC 認可・CORS 設計](05_security_and_errors/auth_and_cors.md)
- [ErrorMiddleware とカスタム ErrorRenderer](05_security_and_errors/error_handling.md)

## 6. 実践テスト & 本番デプロイ運用
- [PHPUnit によるインメモリ HTTP テスト](06_testing_and_deployment/phpunit_testing.md)
- [Nginx + PHP-FPM と常駐ワーカー運用](06_testing_and_deployment/production_deployment.md)

## 関連ガイド & 公式リンク
- [Slim 4 API リファレンス](https://slim.drawlib.com/api/)
- [Slim 4 内部アーキテクチャ解説](https://slim.drawlib.com/architecture/)
- [PNI501 監査レポート](https://slim.drawlib.com/pni501/)
- [Slim 4 公式ドキュメント](https://www.slimframework.com/docs/v4/)
- [GitHub リポジトリ](https://github.com/yuichi110/drawlib-slim)
