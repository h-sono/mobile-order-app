import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/menu_item.dart';

// Menu state
class MenuState {
  final List<MenuItem> items;
  final bool isLoading;
  final String? error;

  const MenuState({this.items = const [], this.isLoading = false, this.error});

  MenuState copyWith({List<MenuItem>? items, bool? isLoading, String? error}) {
    return MenuState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Menu provider
class MenuNotifier extends StateNotifier<MenuState> {
  final ApiService _apiService;
  String? _currentLocale;

  MenuNotifier(this._apiService) : super(const MenuState());

  Future<void> loadMenu({String? locale}) async {
    state = state.copyWith(isLoading: true, error: null);
    _currentLocale = locale;

    try {
      final items = await _apiService.getMenu(locale: locale);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load menu. Please check your connection and try again.',
      );
    }
  }

  // Reload menu when language changes
  Future<void> reloadForLocale(String locale) async {
    if (_currentLocale != locale) {
      await loadMenu(locale: locale);
    }
  }
}

final menuProvider = StateNotifierProvider<MenuNotifier, MenuState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return MenuNotifier(apiService);
});
