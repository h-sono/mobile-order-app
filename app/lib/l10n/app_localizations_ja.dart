// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'モバイルオーダー';

  @override
  String get cartEmpty => 'カートが空です';

  @override
  String get menuTitle => 'メニュー';

  @override
  String get cartTitle => 'カート';

  @override
  String get orderComplete => '注文完了';

  @override
  String get addToCart => 'カートに追加';

  @override
  String get removeFromCart => 'カートから削除';

  @override
  String get total => '合計';

  @override
  String get placeOrder => '注文する';

  @override
  String get orderNumber => '注文番号';

  @override
  String get pickupTime => '受取時間';

  @override
  String get selectPickupTime => '受取時間を選択';

  @override
  String get confirm => '確認';

  @override
  String get cancel => 'キャンセル';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get retry => '再試行';

  @override
  String get noMenuItems => 'メニューがありません';

  @override
  String get slotFull => 'この時間は満席です。別の時間を選択してください。';

  @override
  String get networkError => 'ネットワークエラーです。接続を確認して再試行してください。';

  @override
  String get orderConfirmation => '注文確認';

  @override
  String get orderDetails => '注文詳細';

  @override
  String get quantity => '数量';

  @override
  String get price => '価格';

  @override
  String get home => 'ホーム';

  @override
  String get menu => 'メニュー';

  @override
  String get cart => 'カート';

  @override
  String get orders => '注文履歴';

  @override
  String get language => '言語';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get noOrderFound => '注文が見つかりません';

  @override
  String get pleaseOrderFirst => 'まず注文を行ってください';

  @override
  String get orderPlacedSuccessfully => '注文が正常に完了しました！';

  @override
  String get thankYouMessage => 'ご注文ありがとうございます。選択された時間に準備いたします。';

  @override
  String get orderQrCode => '注文QRコード';

  @override
  String get showQrCode => '受け取り時にこのQRコードを提示してください';

  @override
  String get orderItems => '注文商品';

  @override
  String get orderMore => '追加注文';

  @override
  String get backToHome => 'ホームに戻る';
}
