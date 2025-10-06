<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\MenuController;
use App\Http\Controllers\SlotController;
use App\Http\Controllers\OrderController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/menu', [MenuController::class, 'index']);
Route::get('/menu/{menuItem}', [MenuController::class, 'show']);

Route::get('/slots', [SlotController::class, 'index']);
Route::get('/slots/{slot}', [SlotController::class, 'show']);

Route::post('/orders', [OrderController::class, 'store']);
Route::get('/orders/{order}', [OrderController::class, 'show']);
Route::patch('/orders/{order}/status', [OrderController::class, 'updateStatus']);