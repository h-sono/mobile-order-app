# Spec: mobile-order-app
- workspace_root: .
- languages: [flutter, php]
- branch_naming: feature/kiro-{date}-{slug}
- done_definition:
  - 変更ファイルにlintエラーがない
  - `flutter pub get` / `npm ci` / `composer install` が通る
  - 指定の verify コマンドが成功

## Architecture Overview

### システム構成
```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Frontend                         │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   UI Layer      │  │  State Mgmt     │  │   Router    │ │
│  │  (Screens)      │  │  (Riverpod)     │  │ (GoRouter)  │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │    Models       │  │   Providers     │  │  Services   │ │
│  │ (Data Objects)  │  │ (State Logic)   │  │ (API Client)│ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
                            HTTP/REST
                                │
┌─────────────────────────────────────────────────────────────┐
│                    Laravel Backend                          │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │  Controllers    │  │     Models      │  │   Routes    │ │
│  │ (HTTP Handlers) │  │ (Eloquent ORM)  │  │ (API/Web)   │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   Middleware    │  │   Providers     │  │    Jobs     │ │
│  │ (Auth/CORS etc) │  │ (DI Container)  │  │ (Queue)     │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
                                │
                            SQLite
                                │
┌─────────────────────────────────────────────────────────────┐
│                      Database                               │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────┐ │
│  │   menu_items    │  │     orders      │  │    slots    │ │
│  │   translations  │  │   order_items   │  │    users    │ │
│  └─────────────────┘  └─────────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### 層別詳細

#### Flutter UI層 (app/)
- **UI Components**: Screens, Widgets (Material Design)
- **State Management**: Riverpod (Provider pattern)
- **Routing**: GoRouter (宣言的ルーティング)
- **Localization**: flutter_localizations (多言語対応)
- **HTTP Client**: http package (REST API通信)

#### Laravel Controller層 (api/app/Http/)
- **Controllers**: HTTP リクエスト処理、レスポンス生成
- **Middleware**: 認証、CORS、リクエスト前処理
- **Routes**: API エンドポイント定義 (routes/api.php)

#### Laravel Domain層 (api/app/Models/)
- **Models**: Eloquent ORM (MenuItem, Order, OrderItem, Slot, User)
- **Business Logic**: モデル内のビジネスルール
- **Relationships**: モデル間のリレーション定義

#### Laravel Infrastructure層 (api/)
- **Database**: SQLite (開発環境)
- **Queue**: Database driver (非同期処理)
- **Cache**: Database driver (キャッシュ)
- **Session**: Database driver (セッション管理)

#### Jobs・外部連携層
- **Queue Jobs**: 非同期処理 (注文処理、通知送信等)
- **Payment Integration**: 決済サービス連携 (未実装)
- **Notification Services**: プッシュ通知、メール送信 (未実装)

### 環境変数注入ポイント

#### Laravel Backend (api/.env)
```bash
# アプリケーション設定
APP_NAME=Laravel
APP_ENV=local|production
APP_DEBUG=true|false
APP_URL=http://localhost

# データベース
DB_CONNECTION=sqlite|mysql|pgsql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=database_name
DB_USERNAME=username
DB_PASSWORD=password

# 決済サービス
STRIPE_KEY=pk_test_xxx
STRIPE_SECRET=sk_test_xxx
PAYPAL_CLIENT_ID=xxx
PAYPAL_CLIENT_SECRET=xxx

# 通知サービス
MAIL_MAILER=smtp|log
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=xxx
MAIL_PASSWORD=xxx

FCM_SERVER_KEY=xxx
PUSHER_APP_ID=xxx
PUSHER_APP_KEY=xxx
PUSHER_APP_SECRET=xxx

# AWS/クラウドサービス
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
AWS_DEFAULT_REGION=ap-northeast-1
AWS_BUCKET=xxx

# キャッシュ・セッション
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

#### Flutter Frontend (app/.env)
```bash
# API設定
API_BASE_URL=http://localhost:8000
API_TIMEOUT=30000

# 決済設定
STRIPE_PUBLISHABLE_KEY=pk_test_xxx
PAYPAL_CLIENT_ID=xxx

# 分析・監視
FIREBASE_PROJECT_ID=xxx
GOOGLE_ANALYTICS_ID=xxx
SENTRY_DSN=xxx

# 機能フラグ
ENABLE_PUSH_NOTIFICATIONS=true
ENABLE_OFFLINE_MODE=false
DEBUG_MODE=true
```

## Reference
- `app/pubspec.yaml` - Flutter依存関係とプロジェクト設定
- `api/composer.json` - Laravel依存関係とスクリプト
- `app/lib/` - Flutterアプリケーションコード
- `api/app/` - Laravelアプリケーションコード
- `api/.env.example` - Laravel環境変数テンプレート
- `app/.env` - Flutter環境変数設定
- `README.md` - プロジェクト起動手順
