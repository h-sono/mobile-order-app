<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class ApiKeyMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $apiKey = $request->header('X-API-KEY');
        $adminApiKey = env('ADMIN_API_KEY');

        if (empty($adminApiKey)) {
            return response()->json([
                'success' => false,
                'message' => 'Admin API key not configured',
            ], 500);
        }

        if (empty($apiKey) || $apiKey !== $adminApiKey) {
            return response()->json([
                'success' => false,
                'message' => 'Unauthorized. Valid API key required.',
            ], 401);
        }

        return $next($request);
    }
}
