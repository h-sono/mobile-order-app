<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Add deleted_at to menu_items table
        Schema::table('menu_items', function (Blueprint $table) {
            $table->softDeletes();
        });

        // Add deleted_at to slots table
        Schema::table('slots', function (Blueprint $table) {
            $table->softDeletes();
        });

        // Add deleted_at to orders table
        Schema::table('orders', function (Blueprint $table) {
            $table->softDeletes();
        });

        // Add deleted_at to order_items table
        Schema::table('order_items', function (Blueprint $table) {
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Remove deleted_at from menu_items table
        Schema::table('menu_items', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });

        // Remove deleted_at from slots table
        Schema::table('slots', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });

        // Remove deleted_at from orders table
        Schema::table('orders', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });

        // Remove deleted_at from order_items table
        Schema::table('order_items', function (Blueprint $table) {
            $table->dropSoftDeletes();
        });
    }
};