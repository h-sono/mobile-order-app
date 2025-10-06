import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'router/app_router.dart';
import 'providers/language_provider.dart';
import 'l10n/app_localizations.dart';

void main() {
  // オーバーフロー警告を非表示にする
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception is FlutterError) {
      final error = details.exception as FlutterError;
      if (error.message.contains('overflowed')) {
        return; // オーバーフロー警告を無視
      }
    }
    FlutterError.presentError(details);
  };
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    
    return MaterialApp.router(
      title: 'Mobile Order App',
      debugShowCheckedModeBanner: false, // DEBUGバナーを非表示
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ja'),
      ],
      routerConfig: appRouter,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
