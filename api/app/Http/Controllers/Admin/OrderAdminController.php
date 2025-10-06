<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Carbon\Carbon;

class OrderAdminController extends Controller
{
    public function index(Request $request)
    {
        $selectedDate = $request->query('date', Carbon::today()->format('Y-m-d'));
        $apiKey = env('ADMIN_API_KEY');
        
        return view('admin.orders.index', [
            'selectedDate' => $selectedDate,
            'apiKey' => $apiKey,
        ]);
    }
}
