<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class MenuItemTranslationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // First, create some sample menu items (without name/description)
        $menuItems = [
            [
                'price' => 1200.00,
                'category' => 'Pizza',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 1400.00,
                'category' => 'Pizza',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 800.00,
                'category' => 'Salad',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 1100.00,
                'category' => 'Pasta',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 1300.00,
                'category' => 'Main Course',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 300.00,
                'category' => 'Drinks',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 400.00,
                'category' => 'Drinks',
                'image_url' => null,
                'is_available' => true,
            ],
            [
                'price' => 600.00,
                'category' => 'Dessert',
                'image_url' => null,
                'is_available' => true,
            ],
        ];

        // Translations data
        $translations = [
            1 => [
                'ja' => ['name' => 'マルゲリータピザ', 'description' => 'トマトソース、モッツァレラ、フレッシュバジルのクラシックピザ'],
                'en' => ['name' => 'Margherita Pizza', 'description' => 'Classic pizza with tomato sauce, mozzarella, and fresh basil'],
            ],
            2 => [
                'ja' => ['name' => 'ペパロニピザ', 'description' => 'ペパロニとモッツァレラチーズをトッピングしたピザ'],
                'en' => ['name' => 'Pepperoni Pizza', 'description' => 'Pizza topped with pepperoni and mozzarella cheese'],
            ],
            3 => [
                'ja' => ['name' => 'シーザーサラダ', 'description' => 'シーザードレッシングとクルトンを添えた新鮮なロメインレタス'],
                'en' => ['name' => 'Caesar Salad', 'description' => 'Fresh romaine lettuce with Caesar dressing and croutons'],
            ],
            4 => [
                'ja' => ['name' => 'スパゲッティカルボナーラ', 'description' => 'ベーコン、卵、パルメザンチーズのクリーミーなパスタ'],
                'en' => ['name' => 'Spaghetti Carbonara', 'description' => 'Creamy pasta with bacon, eggs, and parmesan cheese'],
            ],
            5 => [
                'ja' => ['name' => 'チキンテリヤキ', 'description' => 'テリヤキソースのグリルチキンと蒸しご飯'],
                'en' => ['name' => 'Chicken Teriyaki', 'description' => 'Grilled chicken with teriyaki sauce and steamed rice'],
            ],
            6 => [
                'ja' => ['name' => '緑茶', 'description' => '伝統的な日本の緑茶'],
                'en' => ['name' => 'Green Tea', 'description' => 'Traditional Japanese green tea'],
            ],
            7 => [
                'ja' => ['name' => 'コーヒー', 'description' => '淹れたてのコーヒー'],
                'en' => ['name' => 'Coffee', 'description' => 'Freshly brewed coffee'],
            ],
            8 => [
                'ja' => ['name' => 'チョコレートケーキ', 'description' => 'チョコレートフロスティングの濃厚なチョコレートケーキ'],
                'en' => ['name' => 'Chocolate Cake', 'description' => 'Rich chocolate cake with chocolate frosting'],
            ],
        ];

        \DB::transaction(function () use ($menuItems, $translations) {
            // Clear existing data
            \App\Models\MenuItemTranslation::truncate();
            \App\Models\MenuItem::truncate();

            // Create menu items and their translations
            foreach ($menuItems as $index => $itemData) {
                $menuItem = \App\Models\MenuItem::create($itemData);
                $menuItemId = $index + 1;

                // Create translations for this menu item
                if (isset($translations[$menuItemId])) {
                    foreach ($translations[$menuItemId] as $locale => $translationData) {
                        \App\Models\MenuItemTranslation::create([
                            'menu_item_id' => $menuItem->id,
                            'locale' => $locale,
                            'name' => $translationData['name'],
                            'description' => $translationData['description'],
                        ]);
                    }
                }
            }
        });

        $this->command->info('Menu items and translations seeded successfully!');
    }
}
