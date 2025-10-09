# 注文確定シーケンス図

## カート→注文確定→決済API→結果反映のシーケンス

このドキュメントでは、モバイルオーダーアプリの注文確定プロセスを詳細なシーケンス図で表現し、成功系・失敗系の両方のフローを明示します。

## 基本注文フロー（成功系）

```mermaid
sequenceDiagram
    participant U as 顧客<br/>(User)
    participant A as モバイルアプリ<br/>(Flutter App)
    participant API as Laravel API<br/>(Backend)
    participant DB as データベース<br/>(Database)
    participant Pay as 決済API<br/>(Payment Gateway)
    participant Notify as 通知サービス<br/>(Notification Service)

    Note over U,Notify: 注文確定プロセス開始

    %% 1. カート確認・顧客情報入力
    U->>A: 注文確認画面表示
    A->>A: カート内容検証
    A->>A: 選択スロット確認
    
    U->>A: 顧客情報入力<br/>(名前、メール、電話番号)
    A->>A: フォームバリデーション
    
    U->>A: 「注文確定」ボタンタップ
    
    %% 2. 注文作成API呼び出し
    A->>API: POST /api/orders<br/>{slot_id, customer_info, items}
    
    Note over API,DB: 注文作成処理
    
    %% 3. バリデーション・在庫確認
    API->>DB: BEGIN TRANSACTION
    API->>DB: SELECT * FROM slots WHERE id = ?
    DB-->>API: スロット情報
    
    alt スロット満席の場合
        API-->>A: 400 Bad Request<br/>{"message": "スロット満席"}
        A-->>U: エラーメッセージ表示
    else スロット利用可能
        API->>DB: SELECT * FROM menu_items WHERE id IN (?)
        DB-->>API: メニューアイテム情報
        
        alt メニューアイテム無効
            API-->>A: 400 Bad Request<br/>{"message": "メニューアイテム無効"}
            A-->>U: エラーメッセージ表示
        else メニューアイテム有効
            %% 4. 価格計算・注文作成
            API->>API: 価格計算<br/>(小計、税額、合計)
            API->>DB: INSERT INTO orders (...)
            DB-->>API: 注文ID
            API->>DB: INSERT INTO order_items (...)
            API->>DB: UPDATE slots SET current_bookings = current_bookings + 1
            
            %% 5. 決済処理（将来実装）
            Note over API,Pay: 決済処理（現在は未実装）
            
            alt 決済API実装時
                API->>Pay: POST /payment/charge<br/>{amount, customer, order_id}
                
                alt 決済成功
                    Pay-->>API: 200 OK<br/>{"status": "success", "transaction_id": "xxx"}
                    API->>DB: UPDATE orders SET payment_status = 'paid'
                else 決済失敗
                    Pay-->>API: 400 Bad Request<br/>{"status": "failed", "error": "card_declined"}
                    API->>DB: ROLLBACK TRANSACTION
                    API-->>A: 400 Bad Request<br/>{"message": "決済失敗"}
                    A-->>U: 決済エラー表示
                else 決済タイムアウト
                    Note over Pay: 30秒タイムアウト
                    API->>DB: ROLLBACK TRANSACTION
                    API-->>A: 408 Timeout<br/>{"message": "決済タイムアウト"}
                    A-->>U: タイムアウトエラー表示
                end
            end
            
            %% 6. 注文確定
            API->>DB: COMMIT TRANSACTION
            API->>DB: SELECT order with relations
            DB-->>API: 完全な注文データ
            
            %% 7. 通知送信（将来実装）
            Note over API,Notify: 通知送信（現在は未実装）
            
            alt 通知サービス実装時
                API->>Notify: POST /notifications/send<br/>{type: "order_created", order_id}
                
                alt 通知成功
                    Notify-->>API: 200 OK<br/>{"status": "sent"}
                    API->>DB: INSERT INTO notification_logs
                else 通知失敗
                    Notify-->>API: 500 Error<br/>{"status": "failed"}
                    Note over API: 通知失敗はログのみ<br/>（注文処理は継続）
                end
            end
            
            %% 8. 成功レスポンス
            API-->>A: 201 Created<br/>{"success": true, "data": order}
            
            %% 9. UI更新・画面遷移
            A->>A: カート状態クリア
            A->>A: スロット選択クリア
            A->>A: 注文状態更新
            A-->>U: 注文完了画面表示<br/>(QRコード含む)
        end
    end
```

## エラーハンドリング詳細シーケンス

```mermaid
sequenceDiagram
    participant U as 顧客
    participant A as アプリ
    participant API as Laravel API
    participant DB as データベース
    participant Pay as 決済API

    Note over U,Pay: エラーケース詳細

    U->>A: 注文確定ボタンタップ
    A->>API: POST /api/orders

    %% ケース1: バリデーションエラー
    alt バリデーションエラー
        API->>API: リクエストバリデーション
        API-->>A: 422 Unprocessable Entity<br/>{"errors": {"customer_name": ["必須項目"]}}
        A->>A: フォームエラー表示
        A-->>U: 入力エラーメッセージ
        U->>A: エラー修正・再送信
        A->>API: POST /api/orders (再試行)
    
    %% ケース2: スロット競合
    else スロット競合エラー
        API->>DB: BEGIN TRANSACTION
        API->>DB: SELECT * FROM slots WHERE id = ? FOR UPDATE
        DB-->>API: スロット情報 (current_bookings = max_capacity)
        API->>DB: ROLLBACK TRANSACTION
        API-->>A: 400 Bad Request<br/>{"message": "選択した時間は満席です"}
        A-->>U: スロット満席エラー
        U->>A: 別スロット選択
        A->>A: スロット選択画面に戻る
    
    %% ケース3: ネットワークエラー
    else ネットワークエラー
        Note over API: サーバー応答なし
        A->>A: タイムアウト検出 (30秒)
        A-->>U: 「接続エラー。再試行してください」
        U->>A: 再試行ボタンタップ
        A->>API: POST /api/orders (リトライ)
    
    %% ケース4: サーバーエラー
    else サーバー内部エラー
        API->>DB: データベース操作
        DB-->>API: エラー (接続失敗等)
        API-->>A: 500 Internal Server Error<br/>{"message": "サーバーエラー"}
        A-->>U: 「一時的なエラーです。しばらく後に再試行してください」
        
        Note over A: 自動リトライ (最大3回)
        loop 最大3回リトライ
            A->>A: 指数バックオフ待機<br/>(2秒, 4秒, 8秒)
            A->>API: POST /api/orders (自動リトライ)
            alt リトライ成功
                API-->>A: 201 Created
                break
            else リトライ失敗
                API-->>A: 500 Error
            end
        end
        
        alt 全リトライ失敗
            A-->>U: 「エラーが継続しています。サポートにお問い合わせください」
        end
    
    %% ケース5: 決済エラー（将来実装）
    else 決済関連エラー
        API->>DB: 注文作成成功
        API->>Pay: 決済要求
        
        alt カード情報エラー
            Pay-->>API: 400 Bad Request<br/>{"error": "invalid_card"}
            API->>DB: ROLLBACK TRANSACTION
            API-->>A: 400 Bad Request<br/>{"message": "カード情報が無効です"}
            A-->>U: カード情報エラー表示
        
        else 残高不足
            Pay-->>API: 400 Bad Request<br/>{"error": "insufficient_funds"}
            API->>DB: ROLLBACK TRANSACTION
            API-->>A: 400 Bad Request<br/>{"message": "残高不足です"}
            A-->>U: 残高不足エラー表示
        
        else 決済サービス障害
            Pay-->>API: 503 Service Unavailable
            API->>DB: ROLLBACK TRANSACTION
            API-->>A: 503 Service Unavailable<br/>{"message": "決済サービス一時停止"}
            A-->>U: 「決済サービスが一時的に利用できません」
        end
    end
```

## 状態管理とUI更新シーケンス

```mermaid
sequenceDiagram
    participant U as ユーザー
    participant UI as UI Component
    participant P as Provider<br/>(OrderNotifier)
    participant API as API Service
    participant S as State<br/>(OrderState)

    Note over U,S: Riverpod状態管理フロー

    %% 1. 注文開始
    U->>UI: 注文確定ボタンタップ
    UI->>P: createOrder() 呼び出し
    
    %% 2. ローディング状態
    P->>S: state = OrderState(isLoading: true)
    S-->>UI: 状態変更通知
    UI-->>U: ローディングインジケーター表示
    
    %% 3. API呼び出し
    P->>API: createOrder(orderData)
    
    alt API成功
        API-->>P: Order オブジェクト
        P->>S: state = OrderState(<br/>  currentOrder: order,<br/>  isLoading: false<br/>)
        S-->>UI: 状態変更通知
        UI->>UI: 画面遷移準備
        UI-->>U: 注文完了画面表示
        
    else API失敗
        API-->>P: Exception
        P->>S: state = OrderState(<br/>  error: errorMessage,<br/>  isLoading: false<br/>)
        S-->>UI: 状態変更通知
        UI-->>U: エラーメッセージ表示
        
        %% エラー後の操作
        U->>UI: リトライボタンタップ
        UI->>P: createOrder() 再呼び出し
    end
```

## 並行処理・競合状態の処理

```mermaid
sequenceDiagram
    participant U1 as ユーザー1
    participant U2 as ユーザー2
    participant A1 as アプリ1
    participant A2 as アプリ2
    participant API as Laravel API
    participant DB as データベース

    Note over U1,DB: 同一スロットへの同時注文

    %% 同時に注文開始
    par ユーザー1の注文
        U1->>A1: 注文確定
        A1->>API: POST /api/orders<br/>(slot_id: 1)
    and ユーザー2の注文
        U2->>A2: 注文確定  
        A2->>API: POST /api/orders<br/>(slot_id: 1)
    end

    %% データベーストランザクション競合
    par API処理1
        API->>DB: BEGIN TRANSACTION
        API->>DB: SELECT * FROM slots WHERE id = 1 FOR UPDATE
        Note over DB: ユーザー1がロック取得
        DB-->>API: スロット情報 (remaining: 1)
        API->>API: 在庫確認OK
        API->>DB: INSERT INTO orders
        API->>DB: UPDATE slots SET current_bookings = current_bookings + 1
        API->>DB: COMMIT TRANSACTION
        API-->>A1: 201 Created (成功)
        A1-->>U1: 注文完了
        
    and API処理2
        API->>DB: BEGIN TRANSACTION
        API->>DB: SELECT * FROM slots WHERE id = 1 FOR UPDATE
        Note over DB: ユーザー2は待機<br/>(ロック待ち)
        DB-->>API: スロット情報 (remaining: 0)
        API->>API: 在庫確認NG
        API->>DB: ROLLBACK TRANSACTION
        API-->>A2: 400 Bad Request<br/>「満席」
        A2-->>U2: スロット満席エラー
    end
```

## パフォーマンス最適化シーケンス

```mermaid
sequenceDiagram
    participant A as アプリ
    participant Cache as キャッシュ
    participant API as Laravel API
    participant DB as データベース

    Note over A,DB: キャッシュ活用による最適化

    %% メニューデータのキャッシュ利用
    A->>Cache: メニューデータ確認
    alt キャッシュヒット
        Cache-->>A: キャッシュされたメニューデータ
        Note over A: API呼び出し不要
    else キャッシュミス
        A->>API: GET /api/menu
        API->>DB: SELECT * FROM menu_items
        DB-->>API: メニューデータ
        API-->>A: メニューデータ
        A->>Cache: メニューデータをキャッシュ
    end

    %% バッチ処理による最適化
    Note over A,DB: 注文作成時のバッチ処理
    
    A->>API: POST /api/orders (複数アイテム)
    
    %% 単一トランザクションで複数操作
    API->>DB: BEGIN TRANSACTION
    
    par 並列バリデーション
        API->>DB: SELECT * FROM menu_items WHERE id IN (1,2,3)
    and
        API->>DB: SELECT * FROM slots WHERE id = ?
    end
    
    DB-->>API: バリデーション結果
    
    %% バッチINSERT
    API->>DB: INSERT INTO orders VALUES (...)
    API->>DB: INSERT INTO order_items VALUES<br/>(item1), (item2), (item3)
    API->>DB: UPDATE slots SET current_bookings = current_bookings + 1
    
    API->>DB: COMMIT TRANSACTION
    API-->>A: 注文完了
```

## 監視・ログ出力シーケンス

```mermaid
sequenceDiagram
    participant A as アプリ
    participant API as Laravel API
    participant Log as ログシステム
    participant Monitor as 監視システム

    Note over A,Monitor: 監視・ログ出力フロー

    A->>API: POST /api/orders
    
    %% リクエストログ
    API->>Log: INFO: Order creation started<br/>{user_id, items_count, slot_id}
    
    alt 正常処理
        API->>API: 注文処理実行
        API->>Log: INFO: Order created successfully<br/>{order_id, total_amount, processing_time}
        API->>Monitor: メトリクス送信<br/>{success_count: +1, response_time: 250ms}
        API-->>A: 201 Created
        
    else エラー発生
        API->>API: エラー処理
        API->>Log: ERROR: Order creation failed<br/>{error_type, error_message, stack_trace}
        API->>Monitor: メトリクス送信<br/>{error_count: +1, error_type: "validation"}
        
        alt 重大エラー
            API->>Monitor: アラート送信<br/>{severity: "high", message: "DB connection failed"}
        end
        
        API-->>A: 4xx/5xx Error
    end
    
    %% パフォーマンス監視
    Note over Monitor: しきい値チェック
    alt レスポンス時間超過
        Monitor->>Monitor: アラート生成<br/>「API応答時間が3秒を超過」
    end
    
    alt エラー率上昇
        Monitor->>Monitor: アラート生成<br/>「エラー率が5%を超過」
    end
```

## 実装状況と将来拡張

### ✅ 現在実装済み
- 基本的な注文作成フロー
- バリデーション処理
- データベーストランザクション
- エラーハンドリング（基本）

### 🚧 部分実装
- 状態管理（Riverpod）
- UI エラー表示
- リトライ機能

### ⏳ 将来実装予定
- 決済API連携
- 通知サービス連携
- 高度な監視・ログ
- パフォーマンス最適化
- リアルタイム更新

### 🔧 技術的改善点
- 楽観的ロックの実装
- キャッシュ戦略の最適化
- 非同期処理の改善
- セキュリティ強化

---

**関連ドキュメント**
- DFD概要: `dfd_overview.md`
- API契約書: `../specs/api_contracts.md`
- モバイルフロー: `../specs/mobile_flows.md`