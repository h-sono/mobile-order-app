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
        final dynamic responseData = json.decode(response.body);

        // Handle different response formats
        Map<String, dynamic> data;
        if (responseData is Map<String, dynamic>) {
          data = responseData;
        } else {
          throw Exception(
            'Invalid response format: expected Map but got ${responseData.runtimeType}',
          );
        }

        // Check if slots data exists and is in the expected format
        if (!data.containsKey('slots')) {
          throw Exception('Response missing slots data');
        }

        final dynamic slotsData = data['slots'];
        final Map<String, List<Slot>> groupedSlots = {};

        if (slotsData is Map<String, dynamic>) {
          // Handle grouped slots format: {"2025-01-01": [...], "2025-01-02": [...]}
          slotsData.forEach((dateKey, slots) {
            if (slots is List<dynamic>) {
              try {
                groupedSlots[dateKey] = slots
                    .where((item) => item is Map<String, dynamic>)
                    .map((json) => Slot.fromJson(json as Map<String, dynamic>))
                    .toList();
              } catch (e) {
                print('Error parsing slots for date $dateKey: $e');
                groupedSlots[dateKey] = [];
              }
            }
          });
        } else if (slotsData is List<dynamic>) {
          // Handle flat list format: [{"date": "2025-01-01", ...}, ...]
          for (final item in slotsData) {
            if (item is Map<String, dynamic>) {
              try {
                final slot = Slot.fromJson(item);
                final dateKey = slot.date;
                if (!groupedSlots.containsKey(dateKey)) {
                  groupedSlots[dateKey] = [];
                }
                groupedSlots[dateKey]!.add(slot);
              } catch (e) {
                print('Error parsing slot: $e');
              }
            }
          }
        } else {
          throw Exception(
            'Invalid slots data format: expected Map or List but got ${slotsData.runtimeType}',
          );
        }

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
      final requestBody = <String, dynamic>{
        'slot_id': slotId,
        'customer_name': customerName,
        'items': items
            .map(
              (item) => {
                'menu_item_id': item.menuItem.id,
                'quantity': item.quantity,
              },
            )
            .toList(),
      };

      // Only add optional fields if they are not null or empty
      if (customerEmail != null && customerEmail.isNotEmpty) {
        requestBody['customer_email'] = customerEmail;
      }
      if (customerPhone != null && customerPhone.isNotEmpty) {
        requestBody['customer_phone'] = customerPhone;
      }
      if (specialInstructions != null && specialInstructions.isNotEmpty) {
        requestBody['special_instructions'] = specialInstructions;
      }

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
        throw Exception(
          errorData['message'] ??
              'Failed to create order: ${response.statusCode}',
        );
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
