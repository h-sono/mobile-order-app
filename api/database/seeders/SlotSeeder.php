<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Slot;
use Carbon\Carbon;

class SlotSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Generate slots for the next 7 days
        $startDate = Carbon::today();
        $endDate = $startDate->copy()->addDays(7);

        // Time slots for each day
        $timeSlots = [
            ['start' => '09:00', 'end' => '09:30'],
            ['start' => '09:30', 'end' => '10:00'],
            ['start' => '10:00', 'end' => '10:30'],
            ['start' => '10:30', 'end' => '11:00'],
            ['start' => '11:00', 'end' => '11:30'],
            ['start' => '11:30', 'end' => '12:00'],
            ['start' => '12:00', 'end' => '12:30'],
            ['start' => '12:30', 'end' => '13:00'],
            ['start' => '13:00', 'end' => '13:30'],
            ['start' => '13:30', 'end' => '14:00'],
            ['start' => '14:00', 'end' => '14:30'],
            ['start' => '14:30', 'end' => '15:00'],
            ['start' => '15:00', 'end' => '15:30'],
            ['start' => '15:30', 'end' => '16:00'],
            ['start' => '16:00', 'end' => '16:30'],
            ['start' => '16:30', 'end' => '17:00'],
            ['start' => '17:00', 'end' => '17:30'],
            ['start' => '17:30', 'end' => '18:00'],
        ];

        $currentDate = $startDate->copy();
        while ($currentDate->lte($endDate)) {
            foreach ($timeSlots as $timeSlot) {
                // Skip past time slots for today
                if ($currentDate->isToday()) {
                    $slotTime = Carbon::createFromFormat('H:i', $timeSlot['start']);
                    if ($slotTime->lt(Carbon::now())) {
                        continue;
                    }
                }

                Slot::create([
                    'date' => $currentDate->format('Y-m-d'),
                    'start_time' => $timeSlot['start'],
                    'end_time' => $timeSlot['end'],
                    'max_capacity' => rand(8, 15), // Random capacity between 8-15
                    'current_bookings' => rand(0, 3), // Some slots already have bookings
                    'is_available' => true,
                ]);
            }
            $currentDate->addDay();
        }
    }
}
