# Data Flow Diagram Overview

## 注文システム全体のデータフロー図

このドキュメントでは、モバイルオーダーアプリの注文作成から決済、確定、通知までの全体的なデータフローをMermaidのDFD（Data Flow Diagram）で表現します。

## システム概要

注文システムは以下の主要プロセスで構成されています：
1. **注文作成** - 顧客情報とカート内容から注文を生成
2. **決済処理** - 決済サービスとの連携（将来実装予定）
3. **注文確定** - 在庫確認と最終確定
4. **通知送信** - 顧客・店舗への通知（将来実装予定）

## Level 0 DFD - システム全体概要

```mermaid
flowchart TD
    %% External Entities
    Customer[顧客<br/>Customer]
    Restaurant[レストラン<br/>Restaurant Staff]
    PaymentGateway[決済ゲートウェイ<br/>Payment Gateway]
    NotificationService[通知サービス<br/>Notification Service]
    
    %% Main Process
    OrderSystem[注文システム<br/>Mobile Order System]
    
    %% Data Flows
    Customer -->|注文情報<br/>Order Info| OrderSystem
    Customer -->|決済情報<br/>Payment Info| OrderSystem
    
    OrderSystem -->|注文確認<br/>Order Confirmation| Customer
    OrderSystem -->|QRコード<br/>QR Code| Customer
    
    OrderSystem -->|注文詳細<br/>Order Details| Restaurant
    OrderSystem -->|ステータス更新<br/>Status Updates| Restaurant
    
    OrderSystem -->|決済要求<br/>Payment Request| PaymentGateway
    PaymentGateway -->|決済結果<br/>Payment Result| OrderSystem
    
    OrderSystem -->|通知要求<br/>Notification Request| NotificationService
    NotificationService -->|配信結果<br/>Delivery Status| OrderSystem
    
    %% Styling
    classDef entity fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef process fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    
    class Customer,Restaurant,PaymentGateway,NotificationService entity
    class OrderSystem process
```

## Level 1 DFD - 注文システム詳細

```mermaid
flowchart TD
    %% External Entities
    Customer[顧客]
    Restaurant[レストラン]
    PaymentAPI[決済API]
    NotificationAPI[通知API]
    
    %% Data Stores
    MenuDB[(メニューDB<br/>Menu Database)]
    OrderDB[(注文DB<br/>Order Database)]
    SlotDB[(スロットDB<br/>Slot Database)]
    
    %% Processes
    P1[1.0<br/>注文作成<br/>Create Order]
    P2[2.0<br/>決済処理<br/>Process Payment]
    P3[3.0<br/>注文確定<br/>Confirm Order]
    P4[4.0<br/>通知送信<br/>Send Notifications]
    
    %% Data Flows from Customer
    Customer -->|カート情報<br/>Cart Items| P1
    Customer -->|顧客情報<br/>Customer Info| P1
    Customer -->|時間スロット選択<br/>Time Slot Selection| P1
    Customer -->|決済情報<br/>Payment Details| P2
    
    %% Data Flows to Customer
    P1 -->|注文番号<br/>Order Number| Customer
    P3 -->|注文確認<br/>Order Confirmation| Customer
    P3 -->|QRコード<br/>QR Code| Customer
    P4 -->|通知<br/>Notifications| Customer
    
    %% Data Flows from Restaurant
    Restaurant -->|ステータス更新<br/>Status Update| P3
    Restaurant -->|メニュー管理<br/>Menu Management| MenuDB
    
    %% Data Flows to Restaurant
    P3 -->|新規注文<br/>New Orders| Restaurant
    P4 -->|注文通知<br/>Order Notifications| Restaurant
    
    %% Process Interactions
    P1 -->|注文データ<br/>Order Data| P2
    P2 -->|決済結果<br/>Payment Result| P3
    P3 -->|確定注文<br/>Confirmed Order| P4
    
    %% External API Interactions
    P2 -->|決済要求<br/>Payment Request| PaymentAPI
    PaymentAPI -->|決済応答<br/>Payment Response| P2
    
    P4 -->|通知要求<br/>Notification Request| NotificationAPI
    NotificationAPI -->|配信状況<br/>Delivery Status| P4
    
    %% Database Interactions
    P1 -.->|メニュー参照<br/>Menu Lookup| MenuDB
    P1 -.->|スロット確認<br/>Slot Check| SlotDB
    P1 -->|注文保存<br/>Save Order| OrderDB
    
    P2 -.->|注文参照<br/>Order Lookup| OrderDB
    P2 -->|決済情報更新<br/>Update Payment| OrderDB
    
    P3 -.->|注文参照<br/>Order Lookup| OrderDB
    P3 -->|ステータス更新<br/>Update Status| OrderDB
    P3 -->|スロット更新<br/>Update Slot| SlotDB
    
    P4 -.->|注文参照<br/>Order Lookup| OrderDB
    P4 -->|通知履歴<br/>Notification Log| OrderDB
    
    %% Styling
    classDef entity fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef process fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef datastore fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class Customer,Restaurant,PaymentAPI,NotificationAPI entity
    class P1,P2,P3,P4 process
    class MenuDB,OrderDB,SlotDB datastore
```

## Level 2 DFD - 注文作成プロセス詳細

```mermaid
flowchart TD
    %% External Entities
    Customer[顧客]
    
    %% Data Stores
    MenuDB[(メニューDB)]
    OrderDB[(注文DB)]
    SlotDB[(スロットDB)]
    
    %% Sub-processes
    P11[1.1<br/>カート検証<br/>Validate Cart]
    P12[1.2<br/>スロット確認<br/>Check Slot Availability]
    P13[1.3<br/>価格計算<br/>Calculate Pricing]
    P14[1.4<br/>注文生成<br/>Generate Order]
    
    %% Data Flows from Customer
    Customer -->|カートアイテム<br/>Cart Items| P11
    Customer -->|選択スロット<br/>Selected Slot| P12
    Customer -->|顧客情報<br/>Customer Details| P14
    
    %% Data Flows to Customer
    P14 -->|注文番号<br/>Order Number| Customer
    P14 -->|エラーメッセージ<br/>Error Messages| Customer
    
    %% Process Flow
    P11 -->|検証済みアイテム<br/>Validated Items| P13
    P12 -->|確認済みスロット<br/>Confirmed Slot| P14
    P13 -->|計算済み価格<br/>Calculated Prices| P14
    
    %% Database Interactions
    P11 -.->|メニュー確認<br/>Menu Validation| MenuDB
    P12 -.->|スロット状態<br/>Slot Status| SlotDB
    P12 -->|予約カウント<br/>Booking Count| SlotDB
    P14 -->|注文保存<br/>Save Order| OrderDB
    
    %% Error Flows
    P11 -->|検証エラー<br/>Validation Error| Customer
    P12 -->|スロット満席<br/>Slot Full Error| Customer
    
    %% Styling
    classDef entity fill:#e1f5fe,stroke:#01579b,stroke-width:2px
    classDef process fill:#f3e5f5,stroke:#4a148c,stroke-width:2px
    classDef datastore fill:#e8f5e8,stroke:#2e7d32,stroke-width:2px
    
    class Customer entity
    class P11,P12,P13,P14 process
    class MenuDB,OrderDB,SlotDB datastore
```

## データストア詳細

### 1. メニューDB (Menu Database)
- **格納データ**: メニューアイテム、価格、カテゴリ、多言語翻訳
- **アクセスパターン**: 読み取り中心、管理者による更新
- **整合性**: 論理削除による履歴保持

### 2. 注文DB (Order Database)
- **格納データ**: 注文情報、顧客情報、注文アイテム、ステータス
- **アクセスパターン**: 作成・更新・参照
- **整合性**: トランザクション制御、外部キー制約

### 3. スロットDB (Slot Database)
- **格納データ**: 時間スロット、容量、現在予約数
- **アクセスパターン**: 頻繁な更新（予約カウント）
- **整合性**: 楽観的ロック、容量制限チェック

## プロセス詳細

### 1.0 注文作成 (Create Order)
- **入力**: カート情報、顧客情報、時間スロット
- **処理**: バリデーション、価格計算、注文生成
- **出力**: 注文番号、エラーメッセージ
- **例外処理**: 在庫切れ、スロット満席、バリデーションエラー

### 2.0 決済処理 (Process Payment)
- **入力**: 注文データ、決済情報
- **処理**: 決済API呼び出し、結果処理
- **出力**: 決済結果、トランザクションID
- **例外処理**: 決済失敗、タイムアウト、ネットワークエラー

### 3.0 注文確定 (Confirm Order)
- **入力**: 決済結果、注文データ
- **処理**: 最終確認、ステータス更新、スロット確定
- **出力**: 注文確認、QRコード
- **例外処理**: 決済失敗時のロールバック

### 4.0 通知送信 (Send Notifications)
- **入力**: 確定注文情報
- **処理**: 通知メッセージ生成、配信
- **出力**: 通知結果、配信ステータス
- **例外処理**: 配信失敗、リトライ処理

## 現在の実装状況

### ✅ 実装済み
- 注文作成プロセス (1.0)
- 基本的な注文確定 (3.0の一部)
- データベース設計

### 🚧 部分実装
- 注文ステータス管理
- エラーハンドリング

### ⏳ 未実装（将来予定）
- 決済処理 (2.0)
- 通知送信 (4.0)
- 高度なエラー処理
- リアルタイム更新

## セキュリティ考慮事項

### データ保護
- 顧客情報の暗号化
- 決済情報の非保持
- アクセスログの記録

### 整合性保証
- トランザクション制御
- 楽観的ロック
- データバリデーション

### 可用性確保
- エラー処理とリトライ
- フェイルセーフ機能
- 監視とアラート

---

**参考資料**
- API契約書: `api_contracts.md`
- データモデル: `data_model.md`
- モバイルフロー: `mobile_flows.md`