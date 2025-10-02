# Tech Document

## モバイルアプリ
- Flutter 3.x
- ライブラリ: Riverpod / GoRouter / Freezed / Dio / intl / qr_flutter

## API
- Laravel 11（PHP 8.3）
- DB: 開発は SQLite（最短）/ MySQL（XAMPP の MariaDB も可）、本番は MySQL（Amazon RDS 可）
- キャッシュ: Laravel Cache（開発=File、本番=Redis）
- 認証: 店側APIのみ APIキー方式 → 将来は Sanctum/Cognito に拡張

## インフラ（本番）
- AWS EC2 (Amazon Linux 2023) + Nginx + PHP-FPM + MySQL/RDS
- Redis (任意)
- デプロイ: Git + GitHub Actions（任意）→ EC2（SSHデプロイ）

## ローカル開発（API）
### A. まずは最短: PHP 内蔵サーバで起動
- 前提: `composer install` 済み、`.env` は `DB_CONNECTION=sqlite`
- 起動: `php artisan serve --host=127.0.0.1 --port=8000`
- Flutter からのベースURL:
  - Android エミュ: `http://10.0.2.2:8000`
  - iOS/Chrome: `http://localhost:8000`
- 備考: CORS は `config/cors.php` の `paths: ['api/*']` を有効化

### B. XAMPP（Apache+PHP）で起動（既存XAMPP利用）
- 要件:
  - **PHP 8.3 相当の XAMPP** を使用（Laravel 11 互換）。古い場合は内蔵サーバ（A）推奨。
- 配置:
  - プロジェクトを `htdocs/mobile-order-api` 等に配置
  - **ドキュメントルートは必ず `public/`** を指す（例: Apache vhost）
    ```
    <VirtualHost *:80>
      ServerName mobile-order.test
      DocumentRoot "C:/xampp/htdocs/mobile-order-api/public"
      <Directory "C:/xampp/htdocs/mobile-order-api/public">
        AllowOverride All
        Require all granted
      </Directory>
    </VirtualHost>
    ```
- .env（例: SQLite）
APP_URL=http://mobile-order.test
DB_CONNECTION=sqlite
DB_DATABASE=database/database.sqlite
（MySQL を使う場合は `DB_CONNECTION=mysql` とし、XAMPP の MySQL/MariaDB に合わせて `DB_HOST/DB_PORT/DB_DATABASE/DB_USERNAME/DB_PASSWORD` を設定）
- CORS: `config/cors.php` で `paths: ['api/*']`、`allowed_*` は最初は広めで可

## ローカル開発（Flutter）
- 開発コマンド: `flutter run -d chrome` もしくは `flutter run -d <emulator>`
- API のベースURLは Provider or `--dart-define` で切替
- 例: `flutter run -d chrome --dart-define API_BASE_URL=http://localhost:8000`
