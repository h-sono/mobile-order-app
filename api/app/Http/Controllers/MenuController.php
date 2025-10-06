<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use App\Models\MenuItem;

class MenuController extends Controller
{
    public function index(): JsonResponse
    {
        $menuItems = MenuItem::where('is_available', true)
            ->whereNull('deleted_at') // 明示的に削除されていないアイテムのみ
            ->orderBy('category')
            ->orderBy('name')
            ->get();

        return response()->json($menuItems);
    }

    public function show(MenuItem $menuItem): JsonResponse
    {
        return response()->json($menuItem);
    }
}