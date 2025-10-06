# Internationalization (i18n) Implementation

This directory contains the internationalization setup for the Mobile Order App.

## Files

- `intl_en.arb` - English translations (template file)
- `intl_ja.arb` - Japanese translations
- `app_localizations.dart` - Generated localization class
- `app_localizations_en.dart` - Generated English localizations
- `app_localizations_ja.dart` - Generated Japanese localizations

## Usage

To use localized strings in your widgets:

```dart
import '../l10n/app_localizations.dart';

// In your widget build method:
final l10n = AppLocalizations.of(context)!;
Text(l10n.appTitle)
```

## Language Switching

The app includes a language toggle widget that allows users to switch between English and Japanese. The current language is managed by the `languageProvider` using Riverpod.

## Adding New Strings

1. Add the new key-value pair to `intl_en.arb`
2. Add the corresponding translation to `intl_ja.arb`
3. Run `flutter gen-l10n` to regenerate the localization files
4. Use the new string in your code with `l10n.yourNewKey`

## Supported Languages

- English (en)
- Japanese (ja)

The app defaults to Japanese and allows users to switch to English via the language toggle in the app bar.