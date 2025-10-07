<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Builder;

class MenuItem extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'price',
        'category',
        'image_url',
        'is_available',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'is_available' => 'boolean',
    ];

    protected $dates = [
        'deleted_at',
    ];

    /**
     * Get the translations for the menu item.
     */
    public function translations(): HasMany
    {
        return $this->hasMany(MenuItemTranslation::class);
    }

    /**
     * Scope to include translations for a specific locale with fallback.
     */
    public function scopeWithLocale(Builder $query, string $locale, string $fallback = 'ja'): Builder
    {
        // Load all translations and sort them in PHP instead of SQL
        return $query->with(['translations' => function ($query) use ($locale, $fallback) {
            $locales = array_unique([$locale, $fallback]);
            $query->whereIn('locale', $locales);
        }]);
    }

    /**
     * Get the localized name for the given locale.
     */
    public function getLocalizedName(string $locale, string $fallback = 'ja'): ?string
    {
        $translation = $this->translations
            ->where('locale', $locale)
            ->first();

        if (!$translation && $locale !== $fallback) {
            $translation = $this->translations
                ->where('locale', $fallback)
                ->first();
        }

        return $translation?->name;
    }

    /**
     * Get the localized description for the given locale.
     */
    public function getLocalizedDescription(string $locale, string $fallback = 'ja'): ?string
    {
        $translation = $this->translations
            ->where('locale', $locale)
            ->first();

        if (!$translation && $locale !== $fallback) {
            $translation = $this->translations
                ->where('locale', $fallback)
                ->first();
        }

        return $translation?->description;
    }

    /**
     * Check if the translation is using fallback locale.
     */
    public function isUsingFallback(string $locale, string $fallback = 'ja'): bool
    {
        $hasRequestedLocale = $this->translations
            ->where('locale', $locale)
            ->isNotEmpty();

        return !$hasRequestedLocale && $locale !== $fallback;
    }
}
