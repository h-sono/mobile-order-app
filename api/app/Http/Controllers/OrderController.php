<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\MenuItem;
use App\Models\Slot;
use Carbon\Carbon;

class OrderController extends Controller
{
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'slot_id' => 'required|exists:slots,id',
            'customer_name' => 'required|string|max:255',
            'customer_email' => 'nullable|email|max:255',
            'customer_phone' => 'nullable|string|max:20',
            'items' => 'required|array|min:1',
            'items.*.menu_item_id' => 'required|exists:menu_items,id',
            'items.*.quantity' => 'required|integer|min:1',
            'special_instructions' => 'nullable|string|max:1000',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            return DB::transaction(function () use ($request) {
                // Check slot availability
                $slot = Slot::findOrFail($request->slot_id);
                
                if (!$slot->isBookable()) {
                    return response()->json([
                        'success' => false,
                        'message' => 'Selected time slot is no longer available',
                    ], 400);
                }

                // Calculate order totals
                $subtotal = 0;
                $orderItemsData = [];

                foreach ($request->items as $itemData) {
                    $menuItem = MenuItem::findOrFail($itemData['menu_item_id']);
                    
                    if (!$menuItem->is_available) {
                        return response()->json([
                            'success' => false,
                            'message' => "Menu item '{$menuItem->name}' is no longer available",
                        ], 400);
                    }

                    $quantity = $itemData['quantity'];
                    $unitPrice = $menuItem->price;
                    $totalPrice = $unitPrice * $quantity;
                    $subtotal += $totalPrice;

                    $orderItemsData[] = [
                        'menu_item_id' => $menuItem->id,
                        'quantity' => $quantity,
                        'unit_price' => $unitPrice,
                        'total_price' => $totalPrice,
                    ];
                }

                // Calculate tax（10%）
                $tax = $subtotal * 0.1;
                $total = $subtotal + $tax;

                // Create order
                $order = Order::create([
                    'slot_id' => $request->slot_id,
                    'customer_name' => $request->customer_name,
                    'customer_email' => $request->customer_email,
                    'customer_phone' => $request->customer_phone,
                    'subtotal' => $subtotal,
                    'tax' => $tax,
                    'total' => $total,
                    'special_instructions' => $request->special_instructions,
                    'pickup_time' => Carbon::parse($slot->date->format('Y-m-d') . ' ' . $slot->start_time->format('H:i:s')),
                ]);

                // Create order items
                foreach ($orderItemsData as $itemData) {
                    $itemData['order_id'] = $order->id;
                    OrderItem::create($itemData);
                }

                // Update slot booking count
                $slot->increment('current_bookings');

                // Load relationships for response
                $order->load(['orderItems.menuItem', 'slot']);

                return response()->json([
                    'success' => true,
                    'message' => 'Order created successfully',
                    'data' => [
                        'order' => [
                            'id' => $order->id,
                            'order_number' => $order->order_number,
                            'status' => $order->status,
                            'customer_name' => $order->customer_name,
                            'subtotal' => $order->subtotal,
                            'tax' => $order->tax,
                            'total' => $order->total,
                            'pickup_time' => $order->pickup_time->format('Y-m-d H:i:s'),
                            'special_instructions' => $order->special_instructions,
                            'slot' => [
                                'id' => $order->slot->id,
                                'date' => $order->slot->date->format('Y-m-d'),
                                'time_slot' => $order->slot->time_slot,
                            ],
                            'items' => $order->orderItems->map(function ($orderItem) {
                                return [
                                    'menu_item_id' => $orderItem->menu_item_id,
                                    'name' => $orderItem->menuItem->name,
                                    'quantity' => $orderItem->quantity,
                                    'unit_price' => $orderItem->unit_price,
                                    'total_price' => $orderItem->total_price,
                                ];
                            }),
                            'created_at' => $order->created_at->format('Y-m-d H:i:s'),
                        ],
                    ],
                ], 201);
            });
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to create order',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function show(Order $order): JsonResponse
    {
        $order->load(['orderItems.menuItem', 'slot']);

        return response()->json([
            'success' => true,
            'data' => [
                'order' => [
                    'id' => $order->id,
                    'order_number' => $order->order_number,
                    'status' => $order->status,
                    'customer_name' => $order->customer_name,
                    'customer_email' => $order->customer_email,
                    'customer_phone' => $order->customer_phone,
                    'subtotal' => $order->subtotal,
                    'tax' => $order->tax,
                    'total' => $order->total,
                    'pickup_time' => $order->pickup_time->format('Y-m-d H:i:s'),
                    'special_instructions' => $order->special_instructions,
                    'slot' => [
                        'id' => $order->slot->id,
                        'date' => $order->slot->date->format('Y-m-d'),
                        'time_slot' => $order->slot->time_slot,
                    ],
                    'items' => $order->orderItems->map(function ($orderItem) {
                        return [
                            'menu_item_id' => $orderItem->menu_item_id,
                            'name' => $orderItem->menuItem->name,
                            'description' => $orderItem->menuItem->description,
                            'quantity' => $orderItem->quantity,
                            'unit_price' => $orderItem->unit_price,
                            'total_price' => $orderItem->total_price,
                        ];
                    }),
                    'created_at' => $order->created_at->format('Y-m-d H:i:s'),
                    'updated_at' => $order->updated_at->format('Y-m-d H:i:s'),
                ],
            ],
        ]);
    }

    public function updateStatus(Request $request, Order $order): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:pending,accepted,cooking,ready,completed,canceled',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        $order->update(['status' => $request->status]);

        return response()->json([
            'success' => true,
            'message' => 'Order status updated successfully',
            'data' => [
                'id' => $order->id,
                'status' => $order->status,
                'updated_at' => $order->updated_at->format('Y-m-d H:i:s'),
            ],
        ]);
    }
}
