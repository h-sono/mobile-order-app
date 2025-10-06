<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Carbon\Carbon;

class Slot extends Model
{
    protected $fillable = [
        'date',
        'start_time',
        'end_time',
        'max_capacity',
        'current_bookings',
        'is_available',
    ];

    protected $casts = [
        'date' => 'date',
        'start_time' => 'datetime:H:i',
        'end_time' => 'datetime:H:i',
        'is_available' => 'boolean',
    ];

    // Check if slot is available for booking
    public function isBookable(): bool
    {
        return $this->is_available && 
               $this->current_bookings < $this->max_capacity &&
               $this->date >= Carbon::today();
    }

    // Get remaining capacity
    public function getRemainingCapacityAttribute(): int
    {
        return $this->max_capacity - $this->current_bookings;
    }

    // Format time slot display
    public function getTimeSlotAttribute(): string
    {
        return $this->start_time->format('H:i') . ' - ' . $this->end_time->format('H:i');
    }
}
