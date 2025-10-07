import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mobile Order'**
  String get appTitle;

  /// No description provided for @cartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmpty;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @orderComplete.
  ///
  /// In en, this message translates to:
  /// **'Order Complete'**
  String get orderComplete;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @removeFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove from Cart'**
  String get removeFromCart;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @pickupTime.
  ///
  /// In en, this message translates to:
  /// **'Pickup Time'**
  String get pickupTime;

  /// No description provided for @selectPickupTime.
  ///
  /// In en, this message translates to:
  /// **'Select Pickup Time'**
  String get selectPickupTime;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noMenuItems.
  ///
  /// In en, this message translates to:
  /// **'No menu items available'**
  String get noMenuItems;

  /// No description provided for @slotFull.
  ///
  /// In en, this message translates to:
  /// **'This time slot is full. Please choose another time.'**
  String get slotFull;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection and try again.'**
  String get networkError;

  /// No description provided for @orderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmation'**
  String get orderConfirmation;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @japanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get japanese;

  /// No description provided for @noOrderFound.
  ///
  /// In en, this message translates to:
  /// **'No order found'**
  String get noOrderFound;

  /// No description provided for @pleaseOrderFirst.
  ///
  /// In en, this message translates to:
  /// **'Please place an order first'**
  String get pleaseOrderFirst;

  /// No description provided for @orderPlacedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully!'**
  String get orderPlacedSuccessfully;

  /// No description provided for @thankYouMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your order. We\'ll have it ready for pickup at your selected time.'**
  String get thankYouMessage;

  /// No description provided for @orderQrCode.
  ///
  /// In en, this message translates to:
  /// **'Order QR Code'**
  String get orderQrCode;

  /// No description provided for @showQrCode.
  ///
  /// In en, this message translates to:
  /// **'Show this QR code when picking up your order'**
  String get showQrCode;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// No description provided for @orderMore.
  ///
  /// In en, this message translates to:
  /// **'Order More'**
  String get orderMore;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @helpGuide.
  ///
  /// In en, this message translates to:
  /// **'Help & Guide'**
  String get helpGuide;

  /// No description provided for @welcomeToApp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mobile Order App!'**
  String get welcomeToApp;

  /// No description provided for @helpDescription.
  ///
  /// In en, this message translates to:
  /// **'This guide will help you navigate through the app and place your orders easily.'**
  String get helpDescription;

  /// No description provided for @howToPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'How to Place an Order'**
  String get howToPlaceOrder;

  /// No description provided for @browseMenu.
  ///
  /// In en, this message translates to:
  /// **'Browse Menu'**
  String get browseMenu;

  /// No description provided for @browseMenuDesc.
  ///
  /// In en, this message translates to:
  /// **'Navigate to the menu to see all available items.'**
  String get browseMenuDesc;

  /// No description provided for @addItemsToCart.
  ///
  /// In en, this message translates to:
  /// **'Add Items to Cart'**
  String get addItemsToCart;

  /// No description provided for @addItemsToCartDesc.
  ///
  /// In en, this message translates to:
  /// **'Select your favorite items and add them to your cart.'**
  String get addItemsToCartDesc;

  /// No description provided for @reviewYourCart.
  ///
  /// In en, this message translates to:
  /// **'Review Your Cart'**
  String get reviewYourCart;

  /// No description provided for @reviewYourCartDesc.
  ///
  /// In en, this message translates to:
  /// **'Check your selected items and adjust quantities.'**
  String get reviewYourCartDesc;

  /// No description provided for @selectPickupTimeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose when you want to pick up your order.'**
  String get selectPickupTimeDesc;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @confirmOrderDesc.
  ///
  /// In en, this message translates to:
  /// **'Review everything and place your order.'**
  String get confirmOrderDesc;

  /// No description provided for @helpfulTips.
  ///
  /// In en, this message translates to:
  /// **'Helpful Tips'**
  String get helpfulTips;

  /// No description provided for @needMoreHelp.
  ///
  /// In en, this message translates to:
  /// **'Need More Help?'**
  String get needMoreHelp;

  /// No description provided for @needMoreHelpDesc.
  ///
  /// In en, this message translates to:
  /// **'If you encounter any issues or have questions:'**
  String get needMoreHelpDesc;

  /// No description provided for @selectedTime.
  ///
  /// In en, this message translates to:
  /// **'Selected Time'**
  String get selectedTime;

  /// No description provided for @spotsLeft.
  ///
  /// In en, this message translates to:
  /// **'spots left'**
  String get spotsLeft;

  /// No description provided for @confirmTimeSlot.
  ///
  /// In en, this message translates to:
  /// **'Confirm Time Slot'**
  String get confirmTimeSlot;

  /// No description provided for @errorLoadingTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Error loading time slots'**
  String get errorLoadingTimeSlots;

  /// No description provided for @noTimeSlotsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No time slots available'**
  String get noTimeSlotsAvailable;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get pleaseTryAgainLater;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @customerInformation.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number (optional)'**
  String get phoneOptional;

  /// No description provided for @specialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Special Instructions'**
  String get specialInstructions;

  /// No description provided for @anySpecialRequests.
  ///
  /// In en, this message translates to:
  /// **'Any special requests? (optional)'**
  String get anySpecialRequests;

  /// No description provided for @specialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Extra sauce, no onions, etc.'**
  String get specialRequestsHint;

  /// No description provided for @yourCartIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get yourCartIsEmpty;

  /// No description provided for @pleaseSelectPickupTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a pickup time'**
  String get pleaseSelectPickupTime;

  /// No description provided for @tapMenuFromHome.
  ///
  /// In en, this message translates to:
  /// **'Tap on \"Menu\" from the home screen'**
  String get tapMenuFromHome;

  /// No description provided for @browseDifferentCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse through different categories (Pasta, Sides, Drinks)'**
  String get browseDifferentCategories;

  /// No description provided for @viewItemDetails.
  ///
  /// In en, this message translates to:
  /// **'View item details, prices, and descriptions'**
  String get viewItemDetails;

  /// No description provided for @checkAvailability.
  ///
  /// In en, this message translates to:
  /// **'Check availability status'**
  String get checkAvailability;

  /// No description provided for @tapAddButton.
  ///
  /// In en, this message translates to:
  /// **'Tap the \"Add\" button next to any menu item'**
  String get tapAddButton;

  /// No description provided for @seeConfirmationMessage.
  ///
  /// In en, this message translates to:
  /// **'See confirmation message when item is added'**
  String get seeConfirmationMessage;

  /// No description provided for @watchCartBadge.
  ///
  /// In en, this message translates to:
  /// **'Watch the cart badge update with item count'**
  String get watchCartBadge;

  /// No description provided for @tapCartIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap the cart icon to view your selections'**
  String get tapCartIcon;

  /// No description provided for @viewSelectedItems.
  ///
  /// In en, this message translates to:
  /// **'View all selected items with prices'**
  String get viewSelectedItems;

  /// No description provided for @useAddRemoveButtons.
  ///
  /// In en, this message translates to:
  /// **'Use + and - buttons to adjust quantities'**
  String get useAddRemoveButtons;

  /// No description provided for @removeItemsIfNeeded.
  ///
  /// In en, this message translates to:
  /// **'Remove items if needed'**
  String get removeItemsIfNeeded;

  /// No description provided for @seeTotalCalculation.
  ///
  /// In en, this message translates to:
  /// **'See total price calculation'**
  String get seeTotalCalculation;

  /// No description provided for @tapSelectPickupTime.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Select Pickup Time\" from cart'**
  String get tapSelectPickupTime;

  /// No description provided for @choosePreferredDate.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred date'**
  String get choosePreferredDate;

  /// No description provided for @selectFromTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Select from available time slots'**
  String get selectFromTimeSlots;

  /// No description provided for @seeRemainingCapacity.
  ///
  /// In en, this message translates to:
  /// **'See remaining capacity for each slot'**
  String get seeRemainingCapacity;

  /// No description provided for @reviewOrderSummary.
  ///
  /// In en, this message translates to:
  /// **'Review your order summary'**
  String get reviewOrderSummary;

  /// No description provided for @confirmPickupAndTotal.
  ///
  /// In en, this message translates to:
  /// **'Confirm pickup time and total amount'**
  String get confirmPickupAndTotal;

  /// No description provided for @tapPlaceOrder.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Place Order\" to submit'**
  String get tapPlaceOrder;

  /// No description provided for @receiveOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Receive order confirmation with QR code'**
  String get receiveOrderConfirmation;

  /// No description provided for @orderOffPeakHours.
  ///
  /// In en, this message translates to:
  /// **'Order during off-peak hours for faster preparation'**
  String get orderOffPeakHours;

  /// No description provided for @arriveOnTime.
  ///
  /// In en, this message translates to:
  /// **'Arrive on time for your selected pickup slot'**
  String get arriveOnTime;

  /// No description provided for @keepQrCodeReady.
  ///
  /// In en, this message translates to:
  /// **'Keep your order QR code ready for pickup'**
  String get keepQrCodeReady;

  /// No description provided for @useRefreshButton.
  ///
  /// In en, this message translates to:
  /// **'Use the refresh button if menu items don\'t load'**
  String get useRefreshButton;

  /// No description provided for @tapHomeIcon.
  ///
  /// In en, this message translates to:
  /// **'Tap the home icon to return to main screen anytime'**
  String get tapHomeIcon;

  /// No description provided for @visitRestaurantCounter.
  ///
  /// In en, this message translates to:
  /// **'Visit us at the restaurant counter'**
  String get visitRestaurantCounter;

  /// No description provided for @callDuringBusinessHours.
  ///
  /// In en, this message translates to:
  /// **'Call us during business hours'**
  String get callDuringBusinessHours;

  /// No description provided for @tryRefreshingApp.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing the app if something doesn\'t work'**
  String get tryRefreshingApp;

  /// No description provided for @failedToLoadMenu.
  ///
  /// In en, this message translates to:
  /// **'Failed to load menu. Please check your connection and try again.'**
  String get failedToLoadMenu;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
