### F-01：ホームへ戻るボタンを設置
---
Spec: mobile-order-app
Task: F-01 App: Global "Back to Home" action
Branch: feature/f01-back-to-home

Please implement F-01 as defined.

Scope:
- workspace_root: .
- target: app/

Steps:
- create widgets/app_scaffold.dart with AppScaffold(title, child, showHomeAction=true)
- add AppBar with a Home IconButton that calls context.go('/')
- update non-Home screens to use AppScaffold; Home sets showHomeAction=false

Verify:
- run: cd app && flutter analyze
- manually navigate to non-Home pages and click Home icon to return to '/'
Output:
- commit to feature/f01-back-to-home
- PR title: "F-01: Add global Home action to non-Home screens"
---

### F-02：Menu List からカートに入れられるようにする
---
Spec: mobile-order-app
Task: F-02 App: Enable add-to-cart from Menu List
Branch: feature/f02-menu-add-to-cart

Please implement F-02.

Scope:
- workspace_root: .
- target: app/

Steps:
- create providers/cart_provider.dart with CartNotifier (add/increment/decrement/remove) and selectors (count/total)
- update screens/menu_list.dart to show an add-to-cart IconButton per row that calls cartProvider.notifier.add(item) and shows a SnackBar
- (optional) add a cart badge button in AppBar that navigates to /cart

Verify:
- run: cd app && flutter analyze
- run the app, add items from Menu List, and confirm cart count/total increases
Output:
- commit to feature/f02-menu-add-to-cart
- PR title: "F-02: Add-to-cart from Menu List with provider wiring"
---

### F-03：操作ガイド画面の追加（ヘルプ）
---
Spec: mobile-order-app
Task: F-03 App: Help/Guide screen and header action
Branch: feature/f03-help-screen

Please implement F-03.

Scope:
- workspace_root: .
- target: app/

Steps:
- add /help route and create screens/help.dart with step-by-step usage guide
- add a Help IconButton in AppScaffold AppBar actions to navigate to /help
- (if i18n exists) add strings into l10n ARB files

Verify:
- run: cd app && flutter analyze
- open /help from the header Help icon and review the guide content
Output:
- commit to feature/f03-help-screen
- PR title: "F-03: Add Help screen and header Help action"
---

### F-04：金額単位をドルから円に修正
- vibeにて以下を指示。
---
メニュー（/menu）画面の金額をドルではなく「円」表記にしてください。
---
- 結果：全画面を確認して修正してくれた。

### F-05：日本語モードでも英語のままの箇所を修正
- vibeにて以下を指示。
---
日本語モードでも英語のままの箇所がありますので修正してください。
以下が対象画面になります。
- Help & Guide（/help）
- Select Pickup Time（/slot-selection）
- Order Confirmation（/order-confirmation）
---
- 結果
  - ヘルプ画面の詳細説明のみ英語表記のままだった。
  - メニュー一覧（DBから取得）がDBに保存しているデータに依存するため日本語・英語の切り替えができない。
- 対象画面を指定してもぬけが出る。もっと具体的に。

↓
やり直し
---
- Help & Guide（/help）のconst Textの部分が日本語・英語の切り替えができていないので切り替えできるよう修正する。
- Menu（/menu）のデータを日本語または英語でmenu_itemsテーブルに登録しているため、日本語・英語の切り替えができていない。メニュー一覧も日本語・英語の切り替えができるよう修正する。
---
- 結果
  - ヘルプ画面は設計通りになった。
  - メニューに関してはDBから取得したデータの言語切り替えなので一旦要件をまとめなおしてKiroに依頼する必要がある。

↓
やり直し
---
Menu（/menu）画面に表示するデータはmenu_itemsテーブルで管理しているためテーブルに保存されている言語に依存してしまう。言語切り替えに対応した形に修正する。
以下のようにする。ただし今現在の構成にあったベストプラクティスがあるのであればそちらを採用すること。
↓
Goal:
 - menu_items の文言（name, description 等）を ja/en で管理。
 -API は Accept-Language/X-Locale を受けて 翻訳解決＋フォールバックして返す。
 - Flutter は言語切替時に再フェッチして画面反映。

Tasks:
DB スキーマ（翻訳テーブル方式）
- 新規テーブル menu_item_translations を作成
  - columns: id, menu_item_id (FK), locale (index), name, description, created_at, updated_at
  - unique: (menu_item_id, locale)
- 既存 menu_items に翻訳不要の共通属性のみを残す（価格、画像、カテゴリ、在庫 等）

Eloquent モデル
 - MenuItem に translations() リレーション（hasMany）
 - MenuItemTranslation モデルを作成
 - 取得用に MenuItem::with('translations') を基本とし、スコープ withLocale($locale, $fallback='ja') を用意
  - 優先ロケールが無ければ既定ロケールへフォールバック
  - 返却用 DTO/Resource に解決済みテキストを詰める

API
- エンドポイント：GET /api/menu-items?category_id=...
- リクエストヘッダ X-Locale（なければ Accept-Language、最終 ja）を判定
- レスポンス例

[
  {
    "id": 1,
    "name": "唐揚げ定食",
    "description": "サクサクの唐揚げ",
    "price": 980,
    "currency": "JPY",
    "image_url": "...",
    "locale_resolved": "ja",
    "locale_fallback": false
  }
]


Seeder / データ移行
- 既存 menu_items の name/description を ja として menu_item_translations へ移行
- 必要に応じて en を投入（仮訳でOK）

Flutter
- API クライアントに locale ヘッダを追加（X-Locale: ja|en）
- 言語切替時に Repository が再フェッチ→状態更新→UI再描画
-（任意）locale_fallback=true の場合は小さなインフォ表示
---
- 結果：APIを翻訳テーブル方式に修正してくれなかった。

↓
やり直し
---
Tasks
- APIを翻訳テーブル方式にする。
- APIが利用できない場合のローカルダミーデータについては、本番環境で表示しないようにしてほしい。本番環境で実際とは異なるメニューが表示されることでオーダーミスが発生するため。
---

↓
やり直し
---
メニュー画面に関して以下の修正を実施。

Tasks
- 開発・本番環境に関係なくmenu_itemsテーブルのデータを必ず参照する。
- ダミーデータは事故の元なので廃止。
---