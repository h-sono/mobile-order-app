<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use App\Models\Slot;
use Carbon\Carbon;

class SlotController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Slot::where('is_available', true)
            ->where('date', '>=', Carbon::today());

        // Filter by specific date if provided
        if ($request->has('date')) {
            $query->where('date', $request->date);
        }

        // Only show bookable slots (not full and not in the past)
        $slots = $query->get()->filter(function ($slot) {
            return $slot->isBookable();
        });

        // Group slots by date for easier frontend handling
        $groupedSlots = $slots->groupBy(function ($slot) {
            return $slot->date->format('Y-m-d');
        })->map(function ($daySlots) {
            return $daySlots->map(function ($slot) {
                return [
                    'id' => $slot->id,
                    'date' => $slot->date->format('Y-m-d'),
                    'start_time' => $slot->start_time->format('H:i'),
                    'end_time' => $slot->end_time->format('H:i'),
                    'time_slot' => $slot->time_slot,
                    'max_capacity' => $slot->max_capacity,
                    'current_bookings' => $slot->current_bookings,
                    'remaining_capacity' => $slot->remaining_capacity,
                    'is_available' => $slot->is_available,
                ];
            })->values();
        });

        return response()->json([
            'slots' => $groupedSlots,
            'total_available' => $slots->count(),
        ]);
    }

    public function show(Slot $slot): JsonResponse
    {
        return response()->json([
            'id' => $slot->id,
            'date' => $slot->date->format('Y-m-d'),
            'start_time' => $slot->start_time->format('H:i'),
            'end_time' => $slot->end_time->format('H:i'),
            'time_slot' => $slot->time_slot,
            'max_capacity' => $slot->max_capacity,
            'current_bookings' => $slot->current_bookings,
            'remaining_capacity' => $slot->remaining_capacity,
            'is_available' => $slot->is_available,
            'is_bookable' => $slot->isBookable(),
        ]);
    }
}
