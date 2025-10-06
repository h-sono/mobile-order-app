import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  final int quantity;

  CartItem({
    required this.menuItem,
    required this.quantity,
  });

  CartItem copyWith({
    MenuItem? menuItem,
    int? quantity,
  }) {
    return CartItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => menuItem.price * quantity;

  Map<String, dynamic> toJson() {
    return {
      'menu_item': menuItem.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menu_item']),
      quantity: json['quantity'] as int,
    );
  }
}