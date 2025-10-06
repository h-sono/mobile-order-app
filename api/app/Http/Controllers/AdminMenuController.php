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
        // Include soft deleted items for admin view
        $menuItems = MenuItem::withTrashed()
            ->orderBy('category')
            ->orderBy('name')
            ->get();

        $stats = [
            'total_items' => $menuItems->count(),
            'active_items' => $menuItems->whereNull('deleted_at')->count(),
            'available_items' => $menuItems->where('is_available', true)->whereNull('deleted_at')->count(),
            'unavailable_items' => $menuItems->where('is_available', false)->whereNull('deleted_at')->count(),
            'deleted_items' => $menuItems->whereNotNull('deleted_at')->count(),
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
                                'is_deleted' => $item->deleted_at !== null,
                                'deleted_at' => $item->deleted_at?->format('Y-m-d H:i:s'),
                                'updated_at' => $item->updated_at->format('Y-m-d H:i:s'),
                            ];
                        })->values(),
                    ];
                })->values(),
            ],
        ]);
    }

    public function destroy(MenuItem $menuItem): JsonResponse
    {
        try {
            $menuItem->delete(); // Soft delete

            return response()->json([
                'success' => true,
                'message' => 'Menu item deleted successfully',
                'data' => [
                    'id' => $menuItem->id,
                    'name' => $menuItem->name,
                    'deleted_at' => $menuItem->deleted_at->format('Y-m-d H:i:s'),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to delete menu item',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function restore(int $id): JsonResponse
    {
        try {
            $menuItem = MenuItem::withTrashed()->findOrFail($id);
            $menuItem->restore();

            return response()->json([
                'success' => true,
                'message' => 'Menu item restored successfully',
                'data' => [
                    'id' => $menuItem->id,
                    'name' => $menuItem->name,
                    'restored_at' => now()->format('Y-m-d H:i:s'),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to restore menu item',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function forceDelete(int $id): JsonResponse
    {
        try {
            $menuItem = MenuItem::withTrashed()->findOrFail($id);
            $name = $menuItem->name;
            $menuItem->forceDelete(); // Permanent delete

            return response()->json([
                'success' => true,
                'message' => 'Menu item permanently deleted',
                'data' => [
                    'id' => $id,
                    'name' => $name,
                    'permanently_deleted_at' => now()->format('Y-m-d H:i:s'),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to permanently delete menu item',
                'error' => $e->getMessage(),
            ], 500);
        }
    }
}
