<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use App\Models\MenuItem;

class MenuController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        // Get locale from headers (X-Locale or Accept-Language)
        $locale = $this->getLocaleFromRequest($request);
        $fallback = 'ja'; // Default fallback locale

        $menuItems = MenuItem::where('is_available', true)
            ->whereNull('deleted_at')
            ->withLocale($locale, $fallback)
            ->orderBy('category')
            ->get();

        // Transform the data to include localized fields
        $transformedItems = $menuItems->map(function ($item) use ($locale, $fallback) {
            $localizedName = $item->getLocalizedName($locale, $fallback);
            $localizedDescription = $item->getLocalizedDescription($locale, $fallback);
            $isUsingFallback = $item->isUsingFallback($locale, $fallback);

            return [
                'id' => $item->id,
                'name' => $localizedName,
                'description' => $localizedDescription,
                'price' => $item->price,
                'currency' => 'JPY',
                'category' => $item->category,
                'image_url' => $item->image_url,
                'is_available' => $item->is_available,
                'locale_resolved' => $isUsingFallback ? $fallback : $locale,
                'locale_fallback' => $isUsingFallback,
            ];
        });

        return response()->json($transformedItems);
    }

    public function show(Request $request, MenuItem $menuItem): JsonResponse
    {
        // Get locale from headers
        $locale = $this->getLocaleFromRequest($request);
        $fallback = 'ja';

        $menuItem->loadMissing(['translations' => function ($query) use ($locale, $fallback) {
            $locales = array_unique([$locale, $fallback]);
            $query->whereIn('locale', $locales);
        }]);

        $localizedName = $menuItem->getLocalizedName($locale, $fallback);
        $localizedDescription = $menuItem->getLocalizedDescription($locale, $fallback);
        $isUsingFallback = $menuItem->isUsingFallback($locale, $fallback);

        $transformedItem = [
            'id' => $menuItem->id,
            'name' => $localizedName,
            'description' => $localizedDescription,
            'price' => $menuItem->price,
            'currency' => 'JPY',
            'category' => $menuItem->category,
            'image_url' => $menuItem->image_url,
            'is_available' => $menuItem->is_available,
            'locale_resolved' => $isUsingFallback ? $fallback : $locale,
            'locale_fallback' => $isUsingFallback,
        ];

        return response()->json($transformedItem);
    }

    /**
     * Get locale from request headers.
     */
    private function getLocaleFromRequest(Request $request): string
    {
        // Check X-Locale header first
        if ($request->hasHeader('X-Locale')) {
            return $request->header('X-Locale');
        }

        // Check Accept-Language header
        if ($request->hasHeader('Accept-Language')) {
            $acceptLanguage = $request->header('Accept-Language');
            // Extract the primary language (e.g., 'ja' from 'ja-JP,ja;q=0.9,en;q=0.8')
            if (preg_match('/^([a-z]{2})/', $acceptLanguage, $matches)) {
                return $matches[1];
            }
        }

        // Default to Japanese
        return 'ja';
    }
}