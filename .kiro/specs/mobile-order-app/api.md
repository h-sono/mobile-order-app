# API Design (Draft)

## Public API
- GET /menu  
  - メニュー一覧（カテゴリ、説明、価格、品切れフラグ）
- GET /slots?date=YYYY-MM-DD  
  - 指定日の受取スロット一覧
- POST /orders  
  - 新規注文（受取スロット在庫引当）
- GET /orders/{id}  
  - 注文詳細、ステータス

## Admin API (API Key 認証)
- PATCH /orders/{id}/status  
  - 注文状態変更（受付→調理中→受け取り待ち→完了）
- POST /admin/soldout  
  - 商品の売切れ切替
- POST /admin/slots/capacity  
  - 受取スロットのキャパシティ設定
