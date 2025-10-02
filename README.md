# モバイルオーダーアプリ

## 起動手順
### API（Laravel）
- 以下で起動。

```bash
cd mobile-order-app/api
php artisan serve --host=127.0.0.1 --port=8000
```

- http://127.0.0.1:8000/api/menu にアクセスして空リストがブランチに表示されればOK（初期）。

### Flutter
- 以下で起動。

```bash
cd app
flutter analyze
# Chromeで確認する場合
flutter run -d chrome --dart-define API_BASE_URL=http://localhost:8000
```
