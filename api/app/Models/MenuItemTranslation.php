<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\SoftDeletes;

class MenuItemTranslation extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'menu_item_id',
        'locale',
        'name',
        'description',
    ];

    protected $dates = [
        'deleted_at',
    ];

    /**
     * Get the menu item that owns the translation.
     */
    public function menuItem(): BelongsTo
    {
        return $this->belongsTo(MenuItem::class);
    }
}
