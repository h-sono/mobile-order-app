# Tasks Document

## Phase 1：スケルトン（Week1–2）

## T-01 Flutter: プロジェクト生成
- deps: []
- outcome: Flutter プロジェクトが `app/` に生成され、`flutter analyze` が通る
- files:
  - app/ (新規生成)
- steps:
  - run: flutter create app --org com.example.mobileorder
  - run: cd app && flutter pub get
- verify:
  - run: cd app && flutter analyze

## T-02 Flutter: 依存の追加
- deps: [T-01]
- outcome: riverpod / go_router / http を追加し、ビルドが通る
- files:
  - app/pubspec.yaml
  - app/lib/main.dart
- steps:
  - edit pubspec.yaml に以下追加（dev_dependenciesは触らない）
    - flutter_riverpod:^2
    - go_router:^14
    - http:^1
  - run: cd app && flutter pub get
  - edit app/lib/main.dart を最小の MaterialApp + GoRouter で起動できるコードに置換
- verify:
  - run: cd app && flutter analyze
  - run: cd app && flutter build web --debug

## T-03 Flutter: ルーティングのスケルトン
- deps: [T-02]
- outcome: /, /menu, /menu/:id, /cart, /order-complete をGoRouterで定義
- files:
  - app/lib/router/app_router.dart (新規)
  - app/lib/screens/{home,menu_list,menu_detail,cart,order_complete}.dart (新規 5 ファイル)
- verify:
  - run: cd app && flutter analyze

## T-04 API: Laravel プロジェクト生成
- deps: []
- outcome: `api/` に Laravel 11 プロジェクトが生成され、ローカルで migrate が通る
- files:
  - api/ (新規生成)
- steps:
  - run: composer create-project laravel/laravel api
  - run: cd api && cp .env.example .env && php -r "file_put_contents('database/database.sqlite','');"
  - edit: api/.env にて DB_CONNECTION=sqlite を設定
  - run: cd api && php artisan migrate
- verify:
  - run: cd api && php artisan tinker --execute="DB::connection()->getPdo(); echo 'ok';"
- edit: api/config/cors.php の以下を確認/調整
  - paths: ['api/*']
  - allowed_origins: ['*']
  - allowed_methods: ['*']
  - allowed_headers: ['*']

### T-04 Kiro依頼文
Spec: mobile-order-app
Task: T-04 API: Laravel プロジェクト生成
Branch: feature/kiro-t04-api-init

Use the existing empty directory `api/` at repository root.

Scope:
- workspace_root: .
- use existing ./api (empty)
- Do NOT touch app/

Steps:
- run: cd api && composer create-project laravel/laravel .
- run: cd api && cp .env.example .env && php -r "file_put_contents('database/database.sqlite','');"
- edit: api/.env → DB_CONNECTION=sqlite / DB_DATABASE=database/database.sqlite
- run: cd api && php artisan key:generate
- run: cd api && php artisan migrate
- edit: api/config/cors.php → paths:['api/*'], allowed_*: ['*']

Verify:
- run: cd api && php artisan tinker --execute="DB::connection()->getPdo(); echo 'ok';"

Notes:
- Keep everything inside api/

## T-05 API: /api/menu の雛形
- deps: [T-04]
- outcome: GET /api/menu が 200 を返し、空配列を返す
- files:
  - api/routes/api.php
  - api/app/Http/Controllers/MenuController.php (新規)
- steps:
  - edit routes/api.php に Route::get('/menu', [MenuController::class, 'index']);
  - implement MenuController@index: return response()->json([]);
- verify:
  - run: cd api && php artisan route:list | grep api/menu

### T-05 Kiro依頼文
Spec: mobile-order-app
Task: T-05 API: /api/menu の雛形
Branch: feature/kiro-t05-menu-endpoint

Please execute T-05 exactly as defined in tasks.md.

Scope:
- workspace_root: .
- target files:
  - api/routes/api.php
  - api/app/Http/Controllers/MenuController.php (new)

Steps:
- edit api/routes/api.php to add:
  Route::get('/menu', [\App\Http\Controllers\MenuController::class, 'index']);
- create api/app/Http/Controllers/MenuController.php with:
  namespace App\Http\Controllers;
  use Illuminate\Http\JsonResponse;
  class MenuController extends Controller {
      public function index(): JsonResponse {
          return response()->json([]);
      }
  }

Verify:
- run: cd api && php artisan route:list
  (Windows: `cd api && php artisan route:list | findstr /I "api/menu"`)
  (Unix:    `cd api && php artisan route:list | grep api/menu`)

Output:
- commit to `feature/kiro-t05-menu-endpoint`
- PR title: "T-05: add GET /api/menu (empty array)"
- If any step fails, stop and keep logs.

## T-06 Connect: メニュー取得サービス
- deps: [T-03, T-05]
- outcome: app から http で GET /api/menu に到達し、空配列を安全に処理
- files:
  - app/lib/services/api_service.dart (新規)
  - app/lib/providers/menu_provider.dart (新規)
  - app/lib/screens/menu_list.dart (更新: providerを使って表示)
- assumptions:
  - ローカルAPIは http://10.0.2.2:8000 （Android エミュレータ）/ http://localhost:8000（iOS/Chrome）
- verify:
  - run: cd app && flutter analyze
- create: app/lib/providers/config_provider.dart
- edit: api_service.dart は apiBaseUrlProvider を参照
- note: iOS/Chrome は http://localhost:8000 を --dart-define で渡す

### T-06 Kiro依頼文
Spec: mobile-order-app
Task: T-06 Connect: メニュー取得サービス
Branch: feature/kiro-t06-connect-menu

Please execute T-06 exactly as defined in tasks.md.

Scope:
- workspace_root: .
- target (create/update only under app/):
  - app/lib/providers/config_provider.dart (new)
  - app/lib/services/api_service.dart (new)
  - app/lib/providers/menu_provider.dart (new)
  - app/lib/screens/menu_list.dart (update to use provider)

Notes:
- api_service.dart must read base URL from apiBaseUrlProvider.
- For Web/iOS we pass API_BASE_URL via --dart-define (http://localhost:8000).
- For Android emulator default to http://10.0.2.2:8000.

Verify:
- run: cd app && flutter analyze

Output:
- commit to branch `feature/kiro-t06-connect-menu`
- PR title: "T-06: connect app to GET /api/menu (safe empty handling)"
- If any step fails, stop and keep logs/diff.

---

## 回す順番
- T-01 → T-02 → T-03（Flutterの骨）
- T-04 → T-05（APIの骨）
- T-06（接続確認）

## Phase 2：メニュー＆カート（Week3–4）
- **[App]**  
  - `GET /menu` からのデータ取得 → メニュー一覧/詳細UI実装  
  - Riverpodによるカート状態管理（追加・削除・合計）  
- **[API]**  
  - `GET /menu` 実装（Laravel + SQLite）  
  - メニューSeederでダミーデータ投入  
  - キャッシュ（FileCache）導入、CDN利用想定の設計  

---

## Phase 3：スロット＆注文（Week5–6）
- **[API]**  
  - `GET /slots` 実装（受取枠データをDBに保持）  
  - `POST /orders` 実装（在庫引当、バリデーション、注文保存）  
  - 注文IDはUUID生成  
- **[App]**  
  - 受取時刻スロット選択UI  
  - 注文確定処理 → `POST /orders` 呼び出し  
  - 注文番号とQRコード表示（`qr_flutter` 利用）  

---

## Phase 4：ステータス表示＆店側画面（Week7–8）
- **[API]**  
  - `GET /orders/{id}` 実装（注文詳細・ステータス返却）  
  - `PATCH /orders/{id}/status` 実装（店側用、APIキー認証）  
- **[Web/Admin]**  
  - Laravel Blade または簡易Vue/Reactで管理画面を作成  
  - 当日注文一覧、状態変更（受付 → 調理中 → 受け取り待ち → 完了）  
  - 売切れ切替・スロット超過の警告表示  

---

## Phase 5：磨き込み（Week9–10）
- **[App]**  
  - i18n対応（intl：日本語/英語切替）  
  - アクセシビリティ改善（スクリーンリーダー対応、コントラスト）  
  - 空状態UI（メニューなし・カート空・注文履歴なし）  
  - エラーハンドリング（ネットワーク失敗、スロット満杯時など）  
- **[API/Infra]**  
  - MySQL移行（RDS想定）  
  - Redis導入検討（キャッシュ・セッション）  
  - GitHub Actions → EC2へデプロイ（SSH or CI/CD）  

---

## Phase 6：テスト＆リリース準備（Week11–12）
- **[Testing]**  
  - E2Eシナリオ（Flutter integration test + Laravel Feature Test）  
  - 負荷試験（並行注文：軽めのシナリオをArtillery/JMeterで）  
- **[Ops/Docs]**  
  - 運用ドキュメント作成（障害対応・スロット設定・売切れ切替手順）  
  - デモ動画作成（注文～管理画面操作の流れ）  
