<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class MenuController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([]);
    }
}