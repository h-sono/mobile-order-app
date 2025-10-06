# Tasks Document

## Phase 1：スケルトン

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

## Phase 2：メニュー＆カート
- **[App]**  
  - `GET /menu` からのデータ取得 → メニュー一覧/詳細UI実装  
  - Riverpodによるカート状態管理（追加・削除・合計）  
- **[API]**  
  - `GET /menu` 実装（Laravel + SQLite）  
  - メニューSeederでダミーデータ投入  
  - キャッシュ（FileCache）導入、CDN利用想定の設計  

## Phase 3：スロット＆注文（概要）
---
- **[API]**  
  - `GET /slots` 実装（受取枠データをDBに保持）  
  - `POST /orders` 実装（在庫引当、バリデーション、注文保存）  
  - 注文IDはUUID生成  
- **[App]**  
  - 受取時刻スロット選択UI  
  - 注文確定処理 → `POST /orders` 呼び出し  
  - 注文番号とQRコード表示（`qr_flutter` 利用）  
---

## Phase 3：スロット＆注文（詳細）
### T-07 api：受け取り枠（GET /api/slots）
---
Spec: mobile-order-app
Task: T-07 API: GET /api/slots
Branch: feature/kiro-t07-slots

Please implement T-07 as defined in tasks.md.

Scope:
- workspace_root: .
- target: api/

Steps:
- create migration: api/database/migrations/***_create_slots_table.php
  columns:
    - id (big increments)
    - date (date)
    - time (string, e.g. "10:00")
    - capacity (unsignedInteger)
    - reserved (unsignedInteger, default 0)
    - is_active (boolean, default true)
    - timestamps
- create model: api/app/Models/Slot.php (fillable: date, time, capacity, reserved, is_active)
- seeder: api/database/seeders/SlotSeeder.php
  - generate today ~ +6 days, for each day create sample slots (e.g. 10:00-18:00 / 60min step, capacity 5)
- controller: api/app/Http/Controllers/SlotController.php
  - index(): GET /api/slots?date=YYYY-MM-DD -> return slots of that date as:
    { "data":[ { "id":1,"date":"2025-10-06","time":"10:00","capacity":5,"reserved":1,"isActive":true } ] }
- route: api/routes/api.php
  Route::get('/slots', [\App\Http\Controllers\SlotController::class, 'index']);
- enable date filter; default to today if query not provided.

Verify:
- run: cd api && php artisan migrate:fresh --seed
- run: cd api && php artisan route:list | grep api/slots
- run: curl "http://localhost:8000/api/slots?date=2025-10-06"

Output:
- commit to branch feature/kiro-t07-slots
- PR title: "T-07: add GET /api/slots with seeder"
- If any step fails, stop and keep logs.

---

## T-08 api：注文（POST /api/orders）
---
Spec: mobile-order-app
Task: T-08 API: POST /api/orders (UUID)
Branch: feature/kiro-t08-orders

Please implement T-08 exactly as defined.

Scope:
- workspace_root: .
- target: api/

Steps:
- migration: api/database/migrations/***_create_orders_table.php
  columns:
    - id (uuid, primary)
    - slot_id (foreignId -> slots.id, cascadeOnDelete)
    - total_price (unsignedInteger)
    - items (json)  // [{menuId, name?, price, qty}]
    - status (string, default "pending")
    - timestamps
- model: api/app/Models/Order.php (casts: items->array; keyType uuid; incrementing=false)
- controller: api/app/Http/Controllers/OrderController.php
  POST /api/orders:
    - validate:
      slotId: required|exists:slots,id
      totalPrice: required|integer|min:0
      items: required|array|min:1
      items.*.menuId: required|integer
      items.*.qty: required|integer|min:1
      items.*.price: required|integer|min:0
    - within DB transaction:
      - fetch slot for update (pessimistic lock if available)
      - check slot.is_active and (slot.reserved < slot.capacity)
      - slot.reserved += 1; save
      - create order with id = (string) \Illuminate\Support\Str::uuid()
    - return 201:
      { "orderId":"uuid-string", "slotId":X, "status":"pending" }
- route: api/routes/api.php
  Route::post('/orders', [\App\Http\Controllers\OrderController::class, 'store']);
- (Optional) add simple Feature Test for 201 and capacity check.

Verify:
- run: cd api && php artisan migrate
- run: curl -X POST http://localhost:8000/api/orders \
   -H "Content-Type: application/json" \
   -d '{ "slotId": 1, "items":[{"menuId":1,"qty":2,"price":450}], "totalPrice":900 }'

Output:
- commit to branch feature/kiro-t08-orders
- PR title: "T-08: implement POST /api/orders with UUID and slot reservation"
- If any step fails, stop and keep logs.
---

## T-09 app：スロット選択UI
---
Spec: mobile-order-app
Task: T-09 App: Slot selection UI
Branch: feature/kiro-t09-slot-ui

Please implement T-09.

Scope:
- workspace_root: .
- target (create/update only under app/):
  - app/lib/models/slot.dart
  - app/lib/services/api_service.dart (add fetchSlots(date))
  - app/lib/providers/slot_provider.dart
  - app/lib/screens/slot_select.dart
  - app/lib/router/app_router.dart (add /slots route)

Details:
- slot.dart:
  class Slot { int id; String date; String time; int capacity; int reserved; bool isActive; ... fromJson }
- api_service.dart:
  Future<List<Slot>> fetchSlots(String date) => GET {API_BASE_URL}/api/slots?date=YYYY-MM-DD
- provider:
  FutureProvider.family<List<Slot>, String>(...)  // keyed by date
- screen:
  simple UI: date picker (today default), list of slots with (capacity - reserved) 表示、選択可能
  when selected, save selection in a provider (e.g., selectedSlotProvider) and navigate to /order-confirm

Verify:
- run: cd app && flutter analyze

Output:
- commit to feature/kiro-t09-slot-ui
- PR title: "T-09: slot selection screen wired to GET /api/slots"
---

## T-10 app：注文POST＆QR表示
---
Spec: mobile-order-app
Task: T-10 App: Order POST & QR
Branch: feature/kiro-t10-order-qr

Please implement T-10.

Scope:
- workspace_root: .
- target (create/update only under app/):
  - app/pubspec.yaml (add qr_flutter:^4)
  - app/lib/models/order_request.dart
  - app/lib/services/api_service.dart (add postOrder)
  - app/lib/providers/order_provider.dart
  - app/lib/screens/order_confirm.dart
  - app/lib/screens/order_complete.dart
  - app/lib/router/app_router.dart (add /order-confirm, /order-complete)

Details:
- order_request.dart:
  class OrderRequest { int slotId; List<OrderItem>{menuId, qty, price}; int totalPrice; toJson(); }
- api_service.postOrder(req) => POST {API_BASE_URL}/api/orders; returns {orderId, slotId, status}
- order_confirm.dart:
  show selected slot + cart summary + total; "Place Order" button -> call postOrder -> on success push /order-complete with orderId
- order_complete.dart:
  read orderId; show Text(orderId) and QrImage(data: orderId)
- wire providers to existing cart/menu providers

Verify:
- run: cd app && flutter pub get && flutter analyze

Output:
- commit to feature/kiro-t10-order-qr
- PR title: "T-10: POST /api/orders integration and QR code display"
- If any step fails, stop and keep logs/diff.
---

## Phase 4：ステータス表示＆店側画面（概要）
---
- **[API]**  
  - `GET /orders/{id}` 実装（注文詳細・ステータス返却）  
  - `PATCH /orders/{id}/status` 実装（店側用、APIキー認証）  
- **[Web/Admin]**  
  - Laravel Blade または簡易Vue/Reactで管理画面を作成  
  - 当日注文一覧、状態変更（受付 → 調理中 → 受け取り待ち → 完了）  
  - 売切れ切替・スロット超過の警告表示  
---

## Phase 4：ステータス表示＆店側画面（詳細）
### T-11 API：GET /api/orders/{id}
---
Spec: mobile-order-app
Task: T-11 API: GET /api/orders/{id}
Branch: feature/kiro-t11-order-show

Please implement T-11 as defined in tasks.md.

Scope:
- workspace_root: .
- target: api/

Steps:
- add GET /api/orders/{id} -> OrderController@show
- return order (by UUID) with slot info as JSON (id, slot{...}, items[], totalPrice, status, createdAt)

Verify:
- run: cd api && php artisan route:list | grep api/orders
- run: curl http://localhost:8000/api/orders/<uuid>

Output:
- commit to branch feature/kiro-t11-order-show
- PR title: "T-11: GET /api/orders/{id} returns order detail"
---

### T-12 API：PATCH /api/orders/{id}/status （API Key 認証）
---
Spec: mobile-order-app
Task: T-12 API: PATCH /api/orders/{id}/status (API key)
Branch: feature/kiro-t12-order-status

Please implement T-12 exactly as defined.

Scope:
- workspace_root: .
- target: api/

Steps:
- create ApiKeyMiddleware reading ADMIN_API_KEY; check X-API-KEY
- add PATCH /api/orders/{id}/status (middleware: apikey) -> OrderStatusController@update
- validate status in ["pending","accepted","cooking","ready","completed","canceled"]
- update and return { id, status, updatedAt }

Verify:
- run: curl -X PATCH http://localhost:8000/api/orders/<uuid>/status -H "X-API-KEY: <key>" -H "Content-Type: application/json" -d '{"status":"cooking"}'

Output:
- commit to feature/kiro-t12-order-status
- PR title: "T-12: PATCH /api/orders/{id}/status with API key"
---

### T-13 API：GET /api/admin/orders?date=YYYY-MM-DD（当日一覧）
---
Spec: mobile-order-app
Task: T-13 API: GET /api/admin/orders?date=YYYY-MM-DD
Branch: feature/kiro-t13-admin-orders-list

Please implement T-13.

Scope:
- workspace_root: .
- target: api/

Steps:
- add GET /api/admin/orders (middleware: apikey) -> AdminOrderController@index
- return list for given date (default today) with slot info and meta

Verify:
- run: curl -H "X-API-KEY: <key>" "http://localhost:8000/api/admin/orders?date=2025-10-06"

Output:
- commit to feature/kiro-t13-admin-orders-list
- PR title: "T-13: admin orders list API (by date)"
---

### T-14 Web/Admin（Blade）：当日一覧＋状態変更UI
---
Spec: mobile-order-app
Task: T-14 Web/Admin: Orders dashboard (Blade)
Branch: feature/kiro-t14-admin-blade

Please implement T-14.

Scope:
- workspace_root: .
- target: api/

Steps:
- add GET /admin/orders -> Admin\OrderAdminController@index
- render Blade view with a table shell
- add frontend JS to fetch /api/admin/orders?date=... (X-API-KEY) and render rows
- add buttons to update status via PATCH /api/orders/{id}/status
- show warning if slot.reserved > slot.capacity

Verify:
- open http://localhost:8000/admin/orders

Output:
- commit to feature/kiro-t14-admin-blade
- PR title: "T-14: admin orders dashboard (Blade + API integration)"
---

### T-15 API：メニュー売切れ切替（Optional だが UI 要件に合致）
---
Spec: mobile-order-app
Task: T-15 API: toggle menu availability
Branch: feature/kiro-t15-menu-availability

Please implement T-15.

Scope:
- workspace_root: .
- target: api/

Steps:
- add PATCH /api/admin/menu/{id}/availability (middleware: apikey)
- body: { isAvailable: boolean } -> update menus.is_available
- return { id, isAvailable }

Verify:
- run: curl -X PATCH -H "X-API-KEY: <key>" -H "Content-Type: application/json" -d '{"isAvailable":false}' http://localhost:8000/api/admin/menu/1/availability

Output:
- commit to feature/kiro-t15-menu-availability
- PR title: "T-15: toggle menu availability (sold-out)"
---

## Phase 5：磨き込み（概要）
---
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

## Phase 5：磨き込み（詳細）

## Phase 6：テスト＆リリース準備
- **[Testing]**  
  - E2Eシナリオ（Flutter integration test + Laravel Feature Test）  
  - 負荷試験（並行注文：軽めのシナリオをArtillery/JMeterで）  
- **[Ops/Docs]**  
  - 運用ドキュメント作成（障害対応・スロット設定・売切れ切替手順）  
  - デモ動画作成（注文～管理画面操作の流れ）  
