import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_provider.dart';
import '../models/menu_item.dart';
import '../models/slot.dart';
import '../models/order.dart';
import '../models/cart_item.dart';

class ApiService {
  final String baseUrl;
  
  ApiService(this.baseUrl);
  
  Future<List<MenuItem>> getMenu() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/menu'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => MenuItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load menu: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<MenuItem> getMenuItem(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/menu/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return MenuItem.fromJson(data);
      } else {
        throw Exception('Failed to load menu item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, List<Slot>>> getSlots({String? date}) async {
    try {
      String url = '$baseUrl/api/slots';
      if (date != null) {
        url += '?date=$date';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, dynamic> slotsData = data['slots'] as Map<String, dynamic>;
        
        final Map<String, List<Slot>> groupedSlots = {};
        slotsData.forEach((date, slots) {
          final List<dynamic> slotsList = slots as List<dynamic>;
          groupedSlots[date] = slotsList.map((json) => Slot.fromJson(json)).toList();
        });
        
        return groupedSlots;
      } else {
        throw Exception('Failed to load slots: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Slot> getSlot(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/slots/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Slot.fromJson(data);
      } else {
        throw Exception('Failed to load slot: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Order> createOrder({
    required int slotId,
    required String customerName,
    String? customerEmail,
    String? customerPhone,
    required List<CartItem> items,
    String? specialInstructions,
  }) async {
    try {
      final requestBody = {
        'slot_id': slotId,
        'customer_name': customerName,
        'customer_email': customerEmail,
        'customer_phone': customerPhone,
        'items': items.map((item) => {
          'menu_item_id': item.menuItem.id,
          'quantity': item.quantity,
        }).toList(),
        'special_instructions': specialInstructions,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Order.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to create order');
        }
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Order> getOrder(int orderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/orders/$orderId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true) {
          return Order.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to get order');
        }
      } else {
        throw Exception('Failed to load order: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

final apiServiceProvider = Provider<ApiService>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiService(baseUrl);
});