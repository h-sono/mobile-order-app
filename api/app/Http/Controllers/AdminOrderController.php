<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\Order;
use Carbon\Carbon;

class AdminOrderController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        // Get date parameter, default to today
        $date = $request->query('date', Carbon::today()->format('Y-m-d'));
        
        // Validate date format
        try {
            $parsedDate = Carbon::createFromFormat('Y-m-d', $date);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Invalid date format. Use YYYY-MM-DD format.',
            ], 400);
        }

        // Get orders for the specified date
        $orders = Order::with(['orderItems.menuItem', 'slot'])
            ->whereDate('created_at', $parsedDate)
            ->orderBy('created_at', 'desc')
            ->get();

        // Group orders by status for easier management
        $ordersByStatus = $orders->groupBy('status');
        
        // Calculate statistics
        $stats = [
            'total_orders' => $orders->count(),
            'total_revenue' => $orders->sum('total'),
            'status_counts' => [
                'pending' => $ordersByStatus->get('pending', collect())->count(),
                'accepted' => $ordersByStatus->get('accepted', collect())->count(),
                'cooking' => $ordersByStatus->get('cooking', collect())->count(),
                'ready' => $ordersByStatus->get('ready', collect())->count(),
                'completed' => $ordersByStatus->get('completed', collect())->count(),
                'canceled' => $ordersByStatus->get('canceled', collect())->count(),
            ],
        ];

        // Format orders for response
        $formattedOrders = $orders->map(function ($order) {
            return [
                'id' => $order->id,
                'order_number' => $order->order_number,
                'status' => $order->status,
                'customer_name' => $order->customer_name,
                'customer_email' => $order->customer_email,
                'customer_phone' => $order->customer_phone,
                'total' => $order->total,
                'pickup_time' => $order->pickup_time->format('Y-m-d H:i:s'),
                'special_instructions' => $order->special_instructions,
                'slot' => [
                    'id' => $order->slot->id,
                    'date' => $order->slot->date->format('Y-m-d'),
                    'time_slot' => $order->slot->time_slot,
                ],
                'items_count' => $order->orderItems->count(),
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
                'updated_at' => $order->updated_at->format('Y-m-d H:i:s'),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => [
                'date' => $date,
                'stats' => $stats,
                'orders' => $formattedOrders,
            ],
        ]);
    }
}
