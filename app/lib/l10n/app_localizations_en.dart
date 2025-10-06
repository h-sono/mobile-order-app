// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Mobile Order';

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String get menuTitle => 'Menu';

  @override
  String get cartTitle => 'Cart';

  @override
  String get orderComplete => 'Order Complete';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get removeFromCart => 'Remove from Cart';

  @override
  String get total => 'Total';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get orderNumber => 'Order Number';

  @override
  String get pickupTime => 'Pickup Time';

  @override
  String get selectPickupTime => 'Select Pickup Time';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get noMenuItems => 'No menu items available';

  @override
  String get slotFull => 'This time slot is full. Please choose another time.';

  @override
  String get networkError =>
      'Network error. Please check your connection and try again.';

  @override
  String get orderConfirmation => 'Order Confirmation';

  @override
  String get orderDetails => 'Order Details';

  @override
  String get quantity => 'Quantity';

  @override
  String get price => 'Price';

  @override
  String get home => 'Home';

  @override
  String get menu => 'Menu';

  @override
  String get cart => 'Cart';

  @override
  String get orders => 'Orders';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get japanese => 'Japanese';

  @override
  String get noOrderFound => 'No order found';

  @override
  String get pleaseOrderFirst => 'Please place an order first';

  @override
  String get orderPlacedSuccessfully => 'Order Placed Successfully!';

  @override
  String get thankYouMessage =>
      'Thank you for your order. We\'ll have it ready for pickup at your selected time.';

  @override
  String get orderQrCode => 'Order QR Code';

  @override
  String get showQrCode => 'Show this QR code when picking up your order';

  @override
  String get orderItems => 'Order Items';

  @override
  String get orderMore => 'Order More';

  @override
  String get backToHome => 'Back to Home';
}
