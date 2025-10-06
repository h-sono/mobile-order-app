# モバイルオーダーアプリ

## 起動手順
### Laravel（APIなど）
- 以下で起動。

```bash
cd mobile-order-app/api
php artisan serve --host=127.0.0.1 --port=8000
```

- http://127.0.0.1:8000/api/menu にアクセスして空リストがブランチに表示されればOK（初期）。

### DB
- ローカル環境での開発時はSQLiteを使用。
- A5SQLで接続する場合。
  - データベースはSQLiteを選択。
  - 「データベース」にC:\Users\sonob_cpfrkiu\mobile-app\mobile-order-app\api\database\database.sqlite を指定。
  - テスト接続してOKなら接続成功。
  - ユーザー名、パスワード不要。

### 管理画面
- 以下でLaravelを起動しておく。

```bash
cd mobile-order-app/api
php artisan serve --host=127.0.0.1 --port=8000
```
- http://localhost:8000/admin/orders でアクセス。

### Flutter
- 以下で起動。

```bash
cd mobile-order-app/app
flutter analyze
# Chromeで確認する場合
flutter run -d chrome --dart-define API_BASE_URL=http://localhost:8000
```
