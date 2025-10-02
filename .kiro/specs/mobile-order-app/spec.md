# Spec: mobile-order-app
- workspace_root: .
- languages: [flutter, php]
- branch_naming: feature/kiro-{date}-{slug}
- done_definition:
  - 変更ファイルにlintエラーがない
  - `flutter pub get` / `npm ci` / `composer install` が通る
  - 指定の verify コマンドが成功
