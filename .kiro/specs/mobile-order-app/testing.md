# Testing Plan

## Unit Tests
- Flutter: カート状態管理（add/remove/total）
- Laravel: モデル・バリデーション・注文作成API

## Integration Tests
- API: `GET /menu` → レスポンスJSON確認
- API: `POST /orders` → 在庫引当確認
- Flutter: 注文フロー（メニュー選択→カート→スロット選択→注文完了）

## E2E Tests
- シナリオ: 顧客がメニューを選び → 注文確定 → 店側がステータス更新 → 顧客が完了確認

## 負荷試験
- 並行注文（数十件程度）
- 軽負荷シナリオをJMeter/Artilleryで実施
