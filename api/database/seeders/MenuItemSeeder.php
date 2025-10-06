<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\MenuItem;

class MenuItemSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $menuItems = [
            [
                'name' => 'Classic Burger',
                'description' => 'Juicy beef patty with lettuce, tomato, and our special sauce',
                'price' => 12.99,
                'category' => 'Burgers',
                'image_url' => 'https://via.placeholder.com/300x200?text=Classic+Burger',
                'is_available' => true,
            ],
            [
                'name' => 'Chicken Caesar Salad',
                'description' => 'Fresh romaine lettuce with grilled chicken, parmesan, and caesar dressing',
                'price' => 10.99,
                'category' => 'Salads',
                'image_url' => 'https://via.placeholder.com/300x200?text=Caesar+Salad',
                'is_available' => true,
            ],
            [
                'name' => 'Margherita Pizza',
                'description' => 'Traditional pizza with fresh mozzarella, tomatoes, and basil',
                'price' => 15.99,
                'category' => 'Pizza',
                'image_url' => 'https://via.placeholder.com/300x200?text=Margherita+Pizza',
                'is_available' => true,
            ],
            [
                'name' => 'Fish & Chips',
                'description' => 'Beer-battered cod with crispy fries and tartar sauce',
                'price' => 14.99,
                'category' => 'Seafood',
                'image_url' => 'https://via.placeholder.com/300x200?text=Fish+and+Chips',
                'is_available' => true,
            ],
            [
                'name' => 'Chocolate Cake',
                'description' => 'Rich chocolate cake with chocolate frosting',
                'price' => 6.99,
                'category' => 'Desserts',
                'image_url' => 'https://via.placeholder.com/300x200?text=Chocolate+Cake',
                'is_available' => true,
            ],
            [
                'name' => 'Iced Coffee',
                'description' => 'Cold brew coffee served over ice',
                'price' => 3.99,
                'category' => 'Beverages',
                'image_url' => 'https://via.placeholder.com/300x200?text=Iced+Coffee',
                'is_available' => true,
            ],
        ];

        foreach ($menuItems as $item) {
            MenuItem::create($item);
        }
    }
}
