import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartState {
  final List<CartItem> items;
  final double total;

  const CartState({
    this.items = const [],
    this.total = 0.0,
  });

  CartState copyWith({
    List<CartItem>? items,
    double? total,
  }) {
    return CartState(
      items: items ?? this.items,
      total: total ?? this.total,
    );
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(MenuItem menuItem) {
    final existingIndex = state.items.indexWhere(
      (item) => item.menuItem.id == menuItem.id,
    );

    List<CartItem> updatedItems;
    if (existingIndex >= 0) {
      // Update existing item quantity
      updatedItems = List.from(state.items);
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: updatedItems[existingIndex].quantity + 1,
      );
    } else {
      // Add new item
      updatedItems = [...state.items, CartItem(menuItem: menuItem, quantity: 1)];
    }

    final total = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    state = state.copyWith(items: updatedItems, total: total);
  }

  void removeItem(int menuItemId) {
    final updatedItems = state.items.where((item) => item.menuItem.id != menuItemId).toList();
    final total = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    state = state.copyWith(items: updatedItems, total: total);
  }

  void updateQuantity(int menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    final updatedItems = state.items.map((item) {
      if (item.menuItem.id == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    final total = updatedItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    state = state.copyWith(items: updatedItems, total: total);
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});