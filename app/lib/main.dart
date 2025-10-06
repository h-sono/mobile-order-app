import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';

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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mobile Order App',
      debugShowCheckedModeBanner: false, // DEBUGバナーを非表示
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
