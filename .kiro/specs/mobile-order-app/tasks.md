# Tasks Document

## Phase 1：スケルトン（Week1–2）

### 1.1 Flutter プロジェクト初期化
- [ ] 1.1.1 Flutter プロジェクトの作成
  - `flutter create mobile_order_app --org com.example.mobileorder` でプロジェクト作成
  - Flutter 3.x の最新安定版を使用
  - プロジェクト構造の確認とクリーンアップ
  - _Requirements: 全要件の基盤となるプロジェクト構造_

- [ ] 1.1.2 依存関係の追加と設定
  - `pubspec.yaml` に必要なパッケージを追加（riverpod, go_router, http, qr_flutter等）
  - パッケージのバージョン固定と互換性確認
  - `flutter pub get` でパッケージインストール
  - _Requirements: 1.1, 2.1, 3.1, 4.1（各機能に必要なパッケージ）_

- [ ] 1.1.3 プロジェクト構造の構築
  - `lib/` 配下にフォルダ構造作成（screens, widgets, providers, models, services）
  - 各フォルダに `README.md` または初期ファイル配置
  - import パスの統一ルール設定
  - _Requirements: 全要件の実装に必要な構造化_

### 1.2 基本画面とナビゲーション構築
- [ ] 1.2.1 GoRouter の設定
  - `lib/router/app_router.dart` でルーティング設定
  - 基本的な画面遷移パス定義（/, /menu, /menu/:id, /cart, /order-complete）
  - ナビゲーションガードの基本実装
  - _Requirements: 1.1, 2.1, 3.1（画面間遷移）_

- [ ] 1.2.2 基本画面のスケルトン作成
  - `HomeScreen`: アプリのメイン画面
  - `MenuListScreen`: メニュー一覧画面
  - `MenuDetailScreen`: メニュー詳細画面
  - `CartScreen`: カート画面
  - `OrderCompleteScreen`: 注文完了画面
  - 各画面に基本的なAppBarとScaffold構造を実装
  - _Requirements: 1.1, 1.2, 2.1, 3.1, 3.4_

- [ ] 1.2.3 共通ウィジェットの作成
  - `AppBar` の共通コンポーネント
  - `BottomNavigationBar` の実装
  - ローディング表示用の共通ウィジェット
  - エラー表示用の共通ウィジェット
  - _Requirements: 全要件で使用する共通UI要素_

### 1.3 Laravel API プロジェクト初期化
- [ ] 1.3.1 Laravel プロジェクトの作成
  - `composer create-project laravel/laravel mobile-order-api` でプロジェクト作成
  - Laravel 11.x の最新版を使用
  - 基本設定ファイルの確認と調整
  - _Requirements: 全API要件の基盤_

- [ ] 1.3.2 開発環境の設定
  - `.env` ファイルでSQLite設定（`DB_CONNECTION=sqlite`）
  - `database/database.sqlite` ファイル作成
  - `php artisan migrate` で基本テーブル作成確認
  - CORS設定の追加（Flutter アプリからのアクセス用）
  - _Requirements: 1.1, 2.1, 3.1（データベースアクセス）_

- [ ] 1.3.3 API ルートとコントローラーの雛形作成
  - `routes/api.php` に基本ルート定義
  - `MenuController` の作成（`php artisan make:controller MenuController`）
  - `OrderController` の作成（`php artisan make:controller OrderController`）
  - 各コントローラーに基本メソッドの雛形実装
  - _Requirements: 1.1, 1.2, 3.1, 3.2, 6.1_

### 1.4 データベース設計と初期実装
- [ ] 1.4.1 メニューテーブルのマイグレーション作成
  - `php artisan make:migration create_menu_items_table`
  - メニューアイテムの基本カラム定義（name, description, price, category, image_url, is_available）
  - マイグレーション実行とテーブル確認
  - _Requirements: 1.1, 1.2, 1.3, 1.4_

- [ ] 1.4.2 注文関連テーブルのマイグレーション作成
  - `php artisan make:migration create_orders_table`
  - `php artisan make:migration create_order_items_table`
  - 注文とアイテムの関連テーブル設計
  - 受取時刻スロット用のカラム追加
  - _Requirements: 3.1, 3.2, 3.3, 3.4, 6.1, 6.2_

- [ ] 1.4.3 Eloquent モデルの作成
  - `php artisan make:model MenuItem`
  - `php artisan make:model Order`
  - `php artisan make:model OrderItem`
  - モデル間のリレーション定義
  - _Requirements: 1.1, 3.1, 6.1_

### 1.5 基本API エンドポイントの実装
- [ ] 1.5.1 メニュー取得APIの雛形実装
  - `GET /api/menu` エンドポイントの実装
  - 基本的なJSON レスポンス構造の定義
  - エラーハンドリングの基本実装
  - _Requirements: 1.1, 1.2_

- [ ] 1.5.2 注文作成APIの雛形実装
  - `POST /api/orders` エンドポイントの実装
  - リクエストバリデーションの基本実装
  - レスポンス形式の統一
  - _Requirements: 3.1, 3.2, 3.3_

- [ ] 1.5.3 API テスト用のシーダー作成
  - `php artisan make:seeder MenuItemSeeder`
  - サンプルメニューデータの投入
  - `DatabaseSeeder` での呼び出し設定
  - _Requirements: 1.1, 1.2（テスト用データ）_

### 1.6 Flutter と API の接続確認
- [ ] 1.6.1 HTTP サービスクラスの作成
  - `lib/services/api_service.dart` の実装
  - 基本的なHTTP リクエスト処理
  - エラーハンドリングとレスポンス解析
  - _Requirements: 1.1, 3.1（API通信）_

- [ ] 1.6.2 メニューデータ取得の実装
  - Riverpod プロバイダーでのメニューデータ管理
  - API からのデータ取得とキャッシュ
  - メニュー一覧画面での表示確認
  - _Requirements: 1.1, 1.2_

- [ ] 1.6.3 基本的な動作確認
  - Flutter アプリからAPI への接続テスト
  - メニューデータの表示確認
  - 画面遷移の動作確認
  - _Requirements: 1.1, 1.2, 2.1_

### 1.7 開発環境とツールの設定
- [ ] 1.7.1 コード品質ツールの設定
  - Flutter: `analysis_options.yaml` の設定
  - Laravel: PHP CS Fixer または Laravel Pint の設定
  - 両プロジェクトでのlinting ルール統一
  - _Requirements: 全要件の品質保証_

- [ ] 1.7.2 Kiro Hooks の設定
  - `onSave` フック: `flutter format && flutter analyze`
  - `preCommit` フック: `flutter test && php artisan test`
  - フックの動作確認とデバッグ
  - _Requirements: 開発効率向上_

- [ ] 1.7.3 デバッグ環境の構築
  - Flutter のデバッグ設定（VSCode/Android Studio）
  - Laravel のデバッグ設定（Xdebug または dd() 活用）
  - API テスト用のPostman コレクション作成
  - _Requirements: 開発効率向上_

### 1.8 AWS インフラ構成の準備
- [ ] 1.8.1 EC2 インスタンス設定の計画
  - Amazon Linux 2023 での環境構成ドラフト作成
  - 必要なソフトウェアのインストールリスト作成
  - セキュリティグループとネットワーク設定の計画
  - _Requirements: 本番環境での全要件実行_

- [ ] 1.8.2 デプロイメント戦略の策定
  - GitHub Actions を使用したCI/CD パイプライン設計
  - 本番・ステージング環境の分離計画
  - データベース移行戦略（SQLite → MySQL/RDS）
  - _Requirements: 本番環境での安定運用_

- [ ]* 1.8.3 インフラ構成のドキュメント化
  - システム構成図の作成
  - デプロイメント手順書の初版作成
  - 運用監視項目の洗い出し
  - _Requirements: 運用保守性の確保_  

---

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
