<?php

// Test script for T-13 Admin Orders API
$apiKey = 'admin-secret-key-2025';
$baseUrl = 'http://localhost:8000';

// Test 1: Get today's orders
echo "Testing GET /api/admin/orders (today)\n";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $baseUrl . '/api/admin/orders');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'X-API-KEY: ' . $apiKey,
    'Accept: application/json',
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpCode\n";
echo "Response: " . substr($response, 0, 200) . "...\n\n";

// Test 2: Get orders for specific date
echo "Testing GET /api/admin/orders?date=2025-10-06\n";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $baseUrl . '/api/admin/orders?date=2025-10-06');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'X-API-KEY: ' . $apiKey,
    'Accept: application/json',
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpCode\n";
echo "Response: " . substr($response, 0, 200) . "...\n\n";

// Test 3: Test without API key (should fail)
echo "Testing GET /api/admin/orders (no API key - should fail)\n";
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $baseUrl . '/api/admin/orders');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Accept: application/json',
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

echo "HTTP Code: $httpCode\n";
echo "Response: $response\n";