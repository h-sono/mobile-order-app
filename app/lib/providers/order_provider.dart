import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

// Order state
class OrderState {
  final Order? currentOrder;
  final bool isLoading;
  final String? error;
  
  const OrderState({
    this.currentOrder,
    this.isLoading = false,
    this.error,
  });
  
  OrderState copyWith({
    Order? currentOrder,
    bool? isLoading,
    String? error,
  }) {
    return OrderState(
      currentOrder: currentOrder ?? this.currentOrder,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Order provider
class OrderNotifier extends StateNotifier<OrderState> {
  final ApiService _apiService;
  
  OrderNotifier(this._apiService) : super(const OrderState());
  
  Future<void> createOrder({
    required int slotId,
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required List<CartItem> items,
    String? specialInstructions,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final order = await _apiService.createOrder(
        slotId: slotId,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        items: items,
        specialInstructions: specialInstructions,
      );
      
      state = state.copyWith(
        currentOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadOrder(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final order = await _apiService.getOrder(orderId);
      state = state.copyWith(
        currentOrder: order,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearOrder() {
    state = const OrderState();
  }
}

final orderProvider = StateNotifierProvider<OrderNotifier, OrderState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return OrderNotifier(apiService);
});