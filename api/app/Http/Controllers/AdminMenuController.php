<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Validator;
use App\Models\MenuItem;

class AdminMenuController extends Controller
{
    public function updateAvailability(Request $request, MenuItem $menuItem): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'isAvailable' => 'required|boolean',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation failed',
                'errors' => $validator->errors(),
            ], 422);
        }

        try {
            $menuItem->update([
                'is_available' => $request->isAvailable
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Menu item availability updated successfully',
                'data' => [
                    'id' => $menuItem->id,
                    'name' => $menuItem->name,
                    'isAvailable' => $menuItem->is_available,
                    'updated_at' => $menuItem->updated_at->format('Y-m-d H:i:s'),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to update menu item availability',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function index(): JsonResponse
    {
        $menuItems = MenuItem::orderBy('category')
            ->orderBy('name')
            ->get();

        $stats = [
            'total_items' => $menuItems->count(),
            'available_items' => $menuItems->where('is_available', true)->count(),
            'unavailable_items' => $menuItems->where('is_available', false)->count(),
        ];

        $groupedItems = $menuItems->groupBy('category');

        return response()->json([
            'success' => true,
            'data' => [
                'stats' => $stats,
                'menu_items' => $groupedItems->map(function ($items, $category) {
                    return [
                        'category' => $category,
                        'items' => $items->map(function ($item) {
                            return [
                                'id' => $item->id,
                                'name' => $item->name,
                                'description' => $item->description,
                                'price' => $item->price,
                                'category' => $item->category,
                                'image_url' => $item->image_url,
                                'is_available' => $item->is_available,
                                'updated_at' => $item->updated_at->format('Y-m-d H:i:s'),
                            ];
                        })->values(),
                    ];
                })->values(),
            ],
        ]);
    }
}
