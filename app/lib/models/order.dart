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
    try {
      // Handle both direct order data and nested order data
      final orderData = json.containsKey('order') 
          ? json['order'] as Map<String, dynamic>
          : json;

      return Order(
        id: _parseInt(orderData['id']),
        orderNumber: _parseString(orderData['order_number']),
        status: _parseString(orderData['status']),
        customerName: _parseString(orderData['customer_name']),
        customerEmail: _parseNullableString(orderData['customer_email']),
        customerPhone: _parseNullableString(orderData['customer_phone']),
        subtotal: _parseDouble(orderData['subtotal']),
        tax: _parseDouble(orderData['tax']),
        total: _parseDouble(orderData['total']),
        pickupTime: _parseString(orderData['pickup_time']),
        specialInstructions: _parseNullableString(orderData['special_instructions']),
        slot: SlotInfo.fromJson(orderData['slot'] as Map<String, dynamic>),
        items: (orderData['items'] as List<dynamic>)
            .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
            .toList(),
        createdAt: _parseString(orderData['created_at']),
      );
    } catch (e) {
      throw Exception('Failed to parse Order from JSON: $e. JSON: $json');
    }
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    if (value is double) return value.toInt();
    throw Exception('Cannot parse int from $value (${value.runtimeType})');
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    throw Exception('Cannot parse double from $value (${value.runtimeType})');
  }

  static String _parseString(dynamic value) {
    if (value is String) return value;
    if (value != null) return value.toString();
    throw Exception('Cannot parse string from null value');
  }

  static String? _parseNullableString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.isEmpty ? null : value;
    }
    return value.toString();
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
    try {
      return OrderItem(
        menuItemId: Order._parseInt(json['menu_item_id']),
        name: Order._parseString(json['name']),
        quantity: Order._parseInt(json['quantity']),
        unitPrice: Order._parseDouble(json['unit_price']),
        totalPrice: Order._parseDouble(json['total_price']),
      );
    } catch (e) {
      throw Exception('Failed to parse OrderItem from JSON: $e. JSON: $json');
    }
  }
}

class SlotInfo {
  final int id;
  final String date;
  final String timeSlot;

  SlotInfo({required this.id, required this.date, required this.timeSlot});

  factory SlotInfo.fromJson(Map<String, dynamic> json) {
    try {
      return SlotInfo(
        id: Order._parseInt(json['id']),
        date: Order._parseString(json['date']),
        timeSlot: Order._parseString(json['time_slot']),
      );
    } catch (e) {
      throw Exception('Failed to parse SlotInfo from JSON: $e. JSON: $json');
    }
  }
}
