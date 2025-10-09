# API Contracts Documentation

## Overview
このドキュメントは、モバイルオーダーアプリのLaravel APIエンドポイントの詳細仕様を記載しています。

## Authentication
- **Admin API**: `X-API-KEY` ヘッダーが必要（環境変数 `ADMIN_API_KEY` で設定）
- **User API**: 認証不要（一部エンドポイントを除く）

## Common Headers
- `Content-Type: application/json`
- `Accept: application/json`
- `X-Locale: ja|en` (多言語対応、オプション)
- `Accept-Language: ja-JP,ja;q=0.9,en;q=0.8` (多言語対応、オプション)
- `X-API-KEY: {admin_api_key}` (管理者機能のみ)

---

## Menu APIs

### GET /api/menu
メニュー一覧を取得

#### Parameters
- **Query Parameters**: なし
- **Headers**: 
  - `X-Locale` (optional): `ja|en` - 言語設定
  - `Accept-Language` (optional): ブラウザ言語設定

#### Response Schema

**Success (200)**
```json
[
  {
    "id": 1,
    "name": "ハンバーガー",
    "description": "ジューシーなビーフパティ",
    "price": 800,
    "currency": "JPY",
    "category": "メイン",
    "image_url": "https://example.com/burger.jpg",
    "is_available": true,
    "locale_resolved": "ja",
    "locale_fallback": false
  }
]
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/menu" \
  -H "Accept: application/json" \
  -H "X-Locale: ja"
```

**Reference**: `api/routes/api.php:12`, `api/app/Http/Controllers/MenuController.php:11-44`

---

### GET /api/menu/{menuItem}
特定のメニューアイテムの詳細を取得

#### Parameters
- **Path Parameters**:
  - `menuItem` (required): `integer` - メニューアイテムID
- **Headers**: 
  - `X-Locale` (optional): `ja|en` - 言語設定

#### Response Schema

**Success (200)**
```json
{
  "id": 1,
  "name": "ハンバーガー",
  "description": "ジューシーなビーフパティ",
  "price": 800,
  "currency": "JPY",
  "category": "メイン",
  "image_url": "https://example.com/burger.jpg",
  "is_available": true,
  "locale_resolved": "ja",
  "locale_fallback": false
}
```

**Error (404)**
```json
{
  "message": "No query results for model [App\\Models\\MenuItem] {id}"
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/menu/1" \
  -H "Accept: application/json" \
  -H "X-Locale: ja"
```

**Reference**: `api/routes/api.php:13`, `api/app/Http/Controllers/MenuController.php:46-75`

---

## Slot APIs

### GET /api/slots
利用可能な時間スロット一覧を取得

#### Parameters
- **Query Parameters**:
  - `date` (optional): `YYYY-MM-DD` - 特定日付のスロットをフィルタ

#### Response Schema

**Success (200)**
```json
{
  "slots": {
    "2024-01-15": [
      {
        "id": 1,
        "date": "2024-01-15",
        "start_time": "11:00",
        "end_time": "12:00",
        "time_slot": "11:00-12:00",
        "max_capacity": 10,
        "current_bookings": 3,
        "remaining_capacity": 7,
        "is_available": true
      }
    ]
  },
  "total_available": 5
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/slots?date=2024-01-15" \
  -H "Accept: application/json"
```

**Reference**: `api/routes/api.php:15`, `api/app/Http/Controllers/SlotController.php:11-44`

---

### GET /api/slots/{slot}
特定の時間スロットの詳細を取得

#### Parameters
- **Path Parameters**:
  - `slot` (required): `integer` - スロットID

#### Response Schema

**Success (200)**
```json
{
  "id": 1,
  "date": "2024-01-15",
  "start_time": "11:00",
  "end_time": "12:00",
  "time_slot": "11:00-12:00",
  "max_capacity": 10,
  "current_bookings": 3,
  "remaining_capacity": 7,
  "is_available": true,
  "is_bookable": true
}
```

**Error (404)**
```json
{
  "message": "No query results for model [App\\Models\\Slot] {id}"
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/slots/1" \
  -H "Accept: application/json"
```

**Reference**: `api/routes/api.php:16`, `api/app/Http/Controllers/SlotController.php:46-60`

---

## Order APIs

### POST /api/orders
新しい注文を作成

#### Parameters
- **Body Parameters** (JSON):
  - `slot_id` (required): `integer` - 時間スロットID
  - `customer_name` (required): `string` (max:255) - 顧客名
  - `customer_email` (optional): `email` (max:255) - 顧客メールアドレス
  - `customer_phone` (optional): `string` (max:20) - 顧客電話番号
  - `items` (required): `array` (min:1) - 注文アイテム配列
    - `items.*.menu_item_id` (required): `integer` - メニューアイテムID
    - `items.*.quantity` (required): `integer` (min:1) - 数量
  - `special_instructions` (optional): `string` (max:1000) - 特別な指示

#### Validation Rules
```php
[
    'slot_id' => 'required|exists:slots,id',
    'customer_name' => 'required|string|max:255',
    'customer_email' => 'nullable|email|max:255',
    'customer_phone' => 'nullable|string|max:20',
    'items' => 'required|array|min:1',
    'items.*.menu_item_id' => 'required|exists:menu_items,id',
    'items.*.quantity' => 'required|integer|min:1',
    'special_instructions' => 'nullable|string|max:1000',
]
```

#### Response Schema

**Success (201)**
```json
{
  "success": true,
  "message": "Order created successfully",
  "data": {
    "order": {
      "id": 1,
      "order_number": "ORD-20240115-001",
      "status": "pending",
      "customer_name": "田中太郎",
      "subtotal": 1600,
      "tax": 160,
      "total": 1760,
      "pickup_time": "2024-01-15 11:00:00",
      "special_instructions": "辛さ控えめで",
      "slot": {
        "id": 1,
        "date": "2024-01-15",
        "time_slot": "11:00-12:00"
      },
      "items": [
        {
          "menu_item_id": 1,
          "name": "ハンバーガー",
          "quantity": 2,
          "unit_price": 800,
          "total_price": 1600
        }
      ],
      "created_at": "2024-01-15 10:30:00"
    }
  }
}
```

**Validation Error (422)**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "customer_name": ["The customer name field is required."],
    "items": ["The items field is required."]
  }
}
```

**Business Logic Error (400)**
```json
{
  "success": false,
  "message": "Selected time slot is no longer available"
}
```

**Server Error (500)**
```json
{
  "success": false,
  "message": "Failed to create order",
  "error": "Database connection failed"
}
```

#### Sample Request
```bash
curl -X POST "http://localhost:8000/api/orders" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "slot_id": 1,
    "customer_name": "田中太郎",
    "customer_email": "tanaka@example.com",
    "customer_phone": "090-1234-5678",
    "items": [
      {
        "menu_item_id": 1,
        "quantity": 2
      }
    ],
    "special_instructions": "辛さ控えめで"
  }'
```

**Reference**: `api/routes/api.php:18`, `api/app/Http/Controllers/OrderController.php:13-130`

---

### GET /api/orders/{order}
特定の注文の詳細を取得

#### Parameters
- **Path Parameters**:
  - `order` (required): `integer` - 注文ID

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "data": {
    "order": {
      "id": 1,
      "order_number": "ORD-20240115-001",
      "status": "pending",
      "customer_name": "田中太郎",
      "customer_email": "tanaka@example.com",
      "customer_phone": "090-1234-5678",
      "subtotal": 1600,
      "tax": 160,
      "total": 1760,
      "pickup_time": "2024-01-15 11:00:00",
      "special_instructions": "辛さ控えめで",
      "slot": {
        "id": 1,
        "date": "2024-01-15",
        "time_slot": "11:00-12:00"
      },
      "items": [
        {
          "menu_item_id": 1,
          "name": "ハンバーガー",
          "description": "ジューシーなビーフパティ",
          "quantity": 2,
          "unit_price": 800,
          "total_price": 1600
        }
      ],
      "created_at": "2024-01-15 10:30:00",
      "updated_at": "2024-01-15 10:30:00"
    }
  }
}
```

**Error (404)**
```json
{
  "message": "No query results for model [App\\Models\\Order] {id}"
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/orders/1" \
  -H "Accept: application/json"
```

**Reference**: `api/routes/api.php:19`, `api/app/Http/Controllers/OrderController.php:132-170`

---

### PATCH /api/orders/{order}/status
注文ステータスを更新（管理者用）

#### Parameters
- **Path Parameters**:
  - `order` (required): `integer` - 注文ID
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー
- **Body Parameters** (JSON):
  - `status` (required): `enum` - 注文ステータス
    - 許可値: `pending`, `accepted`, `cooking`, `ready`, `completed`, `canceled`

#### Validation Rules
```php
[
    'status' => 'required|in:pending,accepted,cooking,ready,completed,canceled',
]
```

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "message": "Order status updated successfully",
  "data": {
    "id": 1,
    "status": "accepted",
    "updated_at": "2024-01-15 10:45:00"
  }
}
```

**Validation Error (422)**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "status": ["The selected status is invalid."]
  }
}
```

**Authentication Error (401)**
```json
{
  "success": false,
  "message": "Unauthorized. Valid API key required."
}
```

#### Sample Request
```bash
curl -X PATCH "http://localhost:8000/api/orders/1/status" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key" \
  -d '{
    "status": "accepted"
  }'
```

**Reference**: `api/routes/api.php:20`, `api/app/Http/Controllers/OrderController.php:172-194`

---

## Admin APIs

### GET /api/admin/orders
管理者用注文一覧を取得

#### Parameters
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー
- **Query Parameters**:
  - `date` (optional): `YYYY-MM-DD` - 特定日付の注文をフィルタ（デフォルト: 今日）

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "data": {
    "date": "2024-01-15",
    "stats": {
      "total_orders": 5,
      "total_revenue": 8800,
      "status_counts": {
        "pending": 2,
        "accepted": 1,
        "cooking": 1,
        "ready": 0,
        "completed": 1,
        "canceled": 0
      }
    },
    "orders": [
      {
        "id": 1,
        "order_number": "ORD-20240115-001",
        "status": "pending",
        "customer_name": "田中太郎",
        "customer_email": "tanaka@example.com",
        "customer_phone": "090-1234-5678",
        "total": 1760,
        "pickup_time": "2024-01-15 11:00:00",
        "special_instructions": "辛さ控えめで",
        "slot": {
          "id": 1,
          "date": "2024-01-15",
          "time_slot": "11:00-12:00"
        },
        "items_count": 1,
        "items": [
          {
            "menu_item_id": 1,
            "name": "ハンバーガー",
            "quantity": 2,
            "unit_price": 800,
            "total_price": 1600
          }
        ],
        "created_at": "2024-01-15 10:30:00",
        "updated_at": "2024-01-15 10:30:00"
      }
    ]
  }
}
```

**Date Format Error (400)**
```json
{
  "success": false,
  "message": "Invalid date format. Use YYYY-MM-DD format."
}
```

**Authentication Error (401)**
```json
{
  "success": false,
  "message": "Unauthorized. Valid API key required."
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/admin/orders?date=2024-01-15" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key"
```

**Reference**: `api/routes/api.php:23`, `api/app/Http/Controllers/AdminOrderController.php:11-75`

---

### GET /api/admin/menu
管理者用メニュー一覧を取得（削除済みアイテム含む）

#### Parameters
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "data": {
    "stats": {
      "total_items": 10,
      "active_items": 8,
      "available_items": 7,
      "unavailable_items": 1,
      "deleted_items": 2
    },
    "menu_items": [
      {
        "category": "メイン",
        "items": [
          {
            "id": 1,
            "name": "ハンバーガー",
            "description": "ジューシーなビーフパティ",
            "price": 800,
            "category": "メイン",
            "image_url": "https://example.com/burger.jpg",
            "is_available": true,
            "is_deleted": false,
            "deleted_at": null,
            "updated_at": "2024-01-15 10:00:00"
          }
        ]
      }
    ]
  }
}
```

**Authentication Error (401)**
```json
{
  "success": false,
  "message": "Unauthorized. Valid API key required."
}
```

#### Sample Request
```bash
curl -X GET "http://localhost:8000/api/admin/menu" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key"
```

**Reference**: `api/routes/api.php:24`, `api/app/Http/Controllers/AdminMenuController.php:50-85`

---

### PATCH /api/admin/menu/{menuItem}/availability
メニューアイテムの利用可能状態を更新

#### Parameters
- **Path Parameters**:
  - `menuItem` (required): `integer` - メニューアイテムID
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー
- **Body Parameters** (JSON):
  - `isAvailable` (required): `boolean` - 利用可能状態

#### Validation Rules
```php
[
    'isAvailable' => 'required|boolean',
]
```

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "message": "Menu item availability updated successfully",
  "data": {
    "id": 1,
    "name": "ハンバーガー",
    "isAvailable": false,
    "updated_at": "2024-01-15 11:00:00"
  }
}
```

**Validation Error (422)**
```json
{
  "success": false,
  "message": "Validation failed",
  "errors": {
    "isAvailable": ["The is available field is required."]
  }
}
```

**Server Error (500)**
```json
{
  "success": false,
  "message": "Failed to update menu item availability",
  "error": "Database connection failed"
}
```

#### Sample Request
```bash
curl -X PATCH "http://localhost:8000/api/admin/menu/1/availability" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key" \
  -d '{
    "isAvailable": false
  }'
```

**Reference**: `api/routes/api.php:25`, `api/app/Http/Controllers/AdminMenuController.php:13-48`

---

### DELETE /api/admin/menu/{menuItem}
メニューアイテムを論理削除

#### Parameters
- **Path Parameters**:
  - `menuItem` (required): `integer` - メニューアイテムID
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "message": "Menu item deleted successfully",
  "data": {
    "id": 1,
    "name": "ハンバーガー",
    "deleted_at": "2024-01-15 11:30:00"
  }
}
```

**Server Error (500)**
```json
{
  "success": false,
  "message": "Failed to delete menu item",
  "error": "Database constraint violation"
}
```

#### Sample Request
```bash
curl -X DELETE "http://localhost:8000/api/admin/menu/1" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key"
```

**Reference**: `api/routes/api.php:26`, `api/app/Http/Controllers/AdminMenuController.php:87-105`

---

### POST /api/admin/menu/{id}/restore
削除されたメニューアイテムを復元

#### Parameters
- **Path Parameters**:
  - `id` (required): `integer` - メニューアイテムID
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "message": "Menu item restored successfully",
  "data": {
    "id": 1,
    "name": "ハンバーガー",
    "restored_at": "2024-01-15 12:00:00"
  }
}
```

**Server Error (500)**
```json
{
  "success": false,
  "message": "Failed to restore menu item",
  "error": "Menu item not found"
}
```

#### Sample Request
```bash
curl -X POST "http://localhost:8000/api/admin/menu/1/restore" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key"
```

**Reference**: `api/routes/api.php:27`, `api/app/Http/Controllers/AdminMenuController.php:107-125`

---

### DELETE /api/admin/menu/{id}/force
メニューアイテムを物理削除

#### Parameters
- **Path Parameters**:
  - `id` (required): `integer` - メニューアイテムID
- **Headers**:
  - `X-API-KEY` (required): `string` - 管理者APIキー

#### Response Schema

**Success (200)**
```json
{
  "success": true,
  "message": "Menu item permanently deleted",
  "data": {
    "id": 1,
    "name": "ハンバーガー",
    "permanently_deleted_at": "2024-01-15 12:30:00"
  }
}
```

**Server Error (500)**
```json
{
  "success": false,
  "message": "Failed to permanently delete menu item",
  "error": "Foreign key constraint violation"
}
```

#### Sample Request
```bash
curl -X DELETE "http://localhost:8000/api/admin/menu/1/force" \
  -H "Accept: application/json" \
  -H "X-API-KEY: your-admin-api-key"
```

**Reference**: `api/routes/api.php:28`, `api/app/Http/Controllers/AdminMenuController.php:127-147`

---

## Error Handling

### Common HTTP Status Codes
- **200 OK**: 成功
- **201 Created**: リソース作成成功
- **400 Bad Request**: リクエストエラー（ビジネスロジック）
- **401 Unauthorized**: 認証エラー
- **404 Not Found**: リソースが見つからない
- **422 Unprocessable Entity**: バリデーションエラー
- **500 Internal Server Error**: サーバーエラー

### Error Response Format
```json
{
  "success": false,
  "message": "エラーメッセージ",
  "errors": {
    "field_name": ["詳細なエラーメッセージ"]
  }
}
```

## Environment Variables
- `ADMIN_API_KEY`: 管理者API認証キー
- `APP_URL`: アプリケーションベースURL
- `DB_*`: データベース接続設定

## Rate Limiting
現在実装されていませんが、将来的に以下の制限を検討：
- 一般API: 60リクエスト/分
- 管理者API: 120リクエスト/分