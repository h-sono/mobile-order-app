class Order {
  final int id;
  final String orderNumber;
  final String status;
  final String customerName;
  final String? customerEmail;
  final String? customerPhone;
  final double subtotal;
  final double tax;
  final double total;
  final String pickupTime;
  final String? specialInstructions;
  final SlotInfo slot;
  final List<OrderItem> items;
  final String createdAt;

  Order({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.customerName,
    this.customerEmail,
    this.customerPhone,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.pickupTime,
    this.specialInstructions,
    required this.slot,
    required this.items,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    final orderData = json['order'] as Map<String, dynamic>;

    return Order(
      id: orderData['id'] as int,
      orderNumber: orderData['order_number'] as String,
      status: orderData['status'] as String,
      customerName: orderData['customer_name'] as String,
      customerEmail: orderData['customer_email'] as String?,
      customerPhone: orderData['customer_phone'] as String?,
      subtotal: double.parse(orderData['subtotal'].toString()),
      tax: double.parse(orderData['tax'].toString()),
      total: double.parse(orderData['total'].toString()),
      pickupTime: orderData['pickup_time'] as String,
      specialInstructions: orderData['special_instructions'] as String?,
      slot: SlotInfo.fromJson(orderData['slot']),
      items: (orderData['items'] as List<dynamic>)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      createdAt: orderData['created_at'] as String,
    );
  }

  bool get isPending => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isPreparing => status == 'preparing';
  bool get isReady => status == 'ready';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

class OrderItem {
  final int menuItemId;
  final String name;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menu_item_id'] as int,
      name: json['name'] as String,
      quantity: json['quantity'] as int,
      unitPrice: double.parse(json['unit_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
    );
  }
}

class SlotInfo {
  final int id;
  final String date;
  final String timeSlot;

  SlotInfo({required this.id, required this.date, required this.timeSlot});

  factory SlotInfo.fromJson(Map<String, dynamic> json) {
    return SlotInfo(
      id: json['id'] as int,
      date: json['date'] as String,
      timeSlot: json['time_slot'] as String,
    );
  }
}
