import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

final apiBaseUrlProvider = Provider<String>((ref) {
  // Check for --dart-define API_BASE_URL first
  const String dartDefineUrl = String.fromEnvironment('API_BASE_URL');
  
  if (dartDefineUrl.isNotEmpty) {
    return dartDefineUrl;
  }
  
  // Default URLs based on platform
  if (Platform.isAndroid) {
    // Android emulator default
    return 'http://10.0.2.2:8000';
  } else {
    // iOS/Web default
    return 'http://localhost:8000';
  }
});