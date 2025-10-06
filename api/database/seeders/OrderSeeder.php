<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\MenuItem;
use App\Models\Slot;
use Carbon\Carbon;

class OrderSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get some menu items and slots for testing
        $menuItems = MenuItem::take(4)->get();
        $slots = Slot::take(6)->get();

        if ($menuItems->isEmpty() || $slots->isEmpty()) {
            $this->command->warn('Please run MenuItemSeeder and SlotSeeder first');
            return;
        }

        $statuses = ['pending', 'accepted', 'cooking', 'ready', 'completed'];
        $customers = [
            ['name' => 'John Doe', 'email' => 'john@example.com', 'phone' => '123-456-7890'],
            ['name' => 'Jane Smith', 'email' => 'jane@example.com', 'phone' => '098-765-4321'],
            ['name' => 'Bob Johnson', 'email' => 'bob@example.com', 'phone' => '555-123-4567'],
            ['name' => 'Alice Brown', 'email' => 'alice@example.com', 'phone' => '444-987-6543'],
            ['name' => 'Charlie Wilson', 'email' => 'charlie@example.com', 'phone' => '333-555-7777'],
        ];

        // Create orders for today and yesterday
        $dates = [Carbon::today(), Carbon::yesterday()];

        foreach ($dates as $date) {
            for ($i = 0; $i < 5; $i++) {
                $customer = $customers[$i];
                $slot = $slots->random();
                
                // Calculate order totals
                $orderItems = [];
                $subtotal = 0;
                
                // Add 1-3 random items to each order
                $itemCount = rand(1, 3);
                for ($j = 0; $j < $itemCount; $j++) {
                    $menuItem = $menuItems->random();
                    $quantity = rand(1, 3);
                    $unitPrice = $menuItem->price;
                    $totalPrice = $unitPrice * $quantity;
                    $subtotal += $totalPrice;
                    
                    $orderItems[] = [
                        'menu_item_id' => $menuItem->id,
                        'quantity' => $quantity,
                        'unit_price' => $unitPrice,
                        'total_price' => $totalPrice,
                    ];
                }
                
                $tax = $subtotal * 0.08;
                $total = $subtotal + $tax;
                
                // Create order
                $order = Order::create([
                    'slot_id' => $slot->id,
                    'customer_name' => $customer['name'],
                    'customer_email' => $customer['email'],
                    'customer_phone' => $customer['phone'],
                    'subtotal' => $subtotal,
                    'tax' => $tax,
                    'total' => $total,
                    'status' => $statuses[array_rand($statuses)],
                    'special_instructions' => rand(0, 1) ? 'Extra sauce please' : null,
                    'pickup_time' => $date->copy()->setTime($slot->start_time->hour, $slot->start_time->minute),
                    'created_at' => $date->copy()->addHours(rand(8, 18))->addMinutes(rand(0, 59)),
                ]);
                
                // Create order items
                foreach ($orderItems as $itemData) {
                    $itemData['order_id'] = $order->id;
                    OrderItem::create($itemData);
                }
            }
        }
    }
}
