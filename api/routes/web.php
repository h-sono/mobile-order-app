<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\OrderAdminController;

Route::get('/', function () {
    return view('welcome');
});

// Admin routes
Route::prefix('admin')->group(function () {
    Route::get('/orders', [OrderAdminController::class, 'index'])->name('admin.orders.index');
});
