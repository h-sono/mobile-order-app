# Tech Document

## モバイルアプリ
- Flutter 3.x
- ライブラリ: Riverpod / GoRouter / Freezed / Dio / intl / qr_flutter

## API
- Laravel 11（PHP 8.3）
- DB: 開発は SQLite、 本番は MySQL（Amazon RDS 可）
- キャッシュ: Laravel Cache（開発=File、本番=Redis）
- 認証: 店側APIのみ APIキー方式 → 将来は Sanctum/Cognito に拡張

## インフラ（本番）
- AWS EC2 (Amazon Linux 2023) + Nginx + PHP-FPM + MySQL/RDS
- Redis (任意)
- デプロイ: Git + GitHub Actions（任意）→ EC2（SSHデプロイ）

## ローカル開発
- Laravel Sail (Docker) または直インストール
- 最短は SQLite + 直インストール
