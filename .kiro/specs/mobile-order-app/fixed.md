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