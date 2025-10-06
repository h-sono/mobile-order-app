<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Orders Dashboard - Mobile Order App</title>
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f5f5f5;
            color: #333;
        }
        
        .header {
            background: #fff;
            padding: 1rem 2rem;
            border-bottom: 1px solid #e0e0e0;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .controls {
            display: flex;
            gap: 1rem;
            align-items: center;
            margin-top: 1rem;
        }
        
        .date-input {
            padding: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            transition: background-color 0.2s;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
        
        .btn-success {
            background: #27ae60;
            color: white;
        }
        
        .btn-warning {
            background: #f39c12;
            color: white;
        }
        
        .btn-danger {
            background: #e74c3c;
            color: white;
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .stat-label {
            color: #7f8c8d;
            margin-top: 0.5rem;
        }
        
        .orders-table {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table-header {
            background: #34495e;
            color: white;
            padding: 1rem;
            font-weight: bold;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th,
        .table td {
            padding: 1rem;
            text-align: left;
            border-bottom: 1px solid #ecf0f1;
        }
        
        .table th {
            background: #f8f9fa;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-accepted { background: #d4edda; color: #155724; }
        .status-cooking { background: #cce5ff; color: #004085; }
        .status-ready { background: #d1ecf1; color: #0c5460; }
        .status-completed { background: #d4edda; color: #155724; }
        .status-canceled { background: #f8d7da; color: #721c24; }
        
        .loading {
            text-align: center;
            padding: 2rem;
            color: #7f8c8d;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }
        
        .status-actions {
            display: flex;
            gap: 0.25rem;
            flex-wrap: wrap;
        }
        
        .status-actions .btn {
            padding: 0.25rem 0.5rem;
            font-size: 12px;
        }
        
        .slot-warning {
            background: #fff3cd;
            color: #856404;
            padding: 0.5rem;
            border-radius: 4px;
            font-size: 12px;
            margin-top: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Orders Dashboard</h1>
        <div class="controls">
            <label for="dateInput">Date:</label>
            <input type="date" id="dateInput" class="date-input" value="{{ $selectedDate }}">
            <button id="loadOrders" class="btn btn-primary">Load Orders</button>
            <button id="refreshOrders" class="btn btn-secondary">Refresh</button>
        </div>
    </div>

    <div class="container">
        <div id="statsContainer" class="stats">
            <!-- Stats will be populated by JavaScript -->
        </div>

        <div class="orders-table">
            <div class="table-header">
                Orders for <span id="currentDate">{{ $selectedDate }}</span>
            </div>
            
            <div id="loadingIndicator" class="loading">
                Loading orders...
            </div>
            
            <div id="errorContainer" style="display: none;"></div>
            
            <table class="table" id="ordersTable" style="display: none;">
                <thead>
                    <tr>
                        <th>Order #</th>
                        <th>Customer</th>
                        <th>Pickup Time</th>
                        <th>Items</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="ordersTableBody">
                    <!-- Orders will be populated by JavaScript -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const API_KEY = '{{ $apiKey }}';
        const BASE_URL = window.location.origin;
        
        let currentOrders = [];
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadOrders();
            
            document.getElementById('loadOrders').addEventListener('click', loadOrders);
            document.getElementById('refreshOrders').addEventListener('click', loadOrders);
        });
        
        async function loadOrders() {
            const date = document.getElementById('dateInput').value;
            document.getElementById('currentDate').textContent = date;
            
            showLoading();
            
            try {
                const response = await fetch(`${BASE_URL}/api/admin/orders?date=${date}`, {
                    headers: {
                        'X-API-KEY': API_KEY,
                        'Accept': 'application/json'
                    }
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                const data = await response.json();
                
                if (data.success) {
                    currentOrders = data.data.orders;
                    displayStats(data.data.stats);
                    displayOrders(data.data.orders);
                    hideLoading();
                } else {
                    throw new Error(data.message || 'Failed to load orders');
                }
            } catch (error) {
                showError('Failed to load orders: ' + error.message);
                hideLoading();
            }
        }
        
        function displayStats(stats) {
            const statsContainer = document.getElementById('statsContainer');
            statsContainer.innerHTML = `
                <div class="stat-card">
                    <div class="stat-number">${stats.total_orders}</div>
                    <div class="stat-label">Total Orders</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">$${parseFloat(stats.total_revenue).toFixed(2)}</div>
                    <div class="stat-label">Total Revenue</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.status_counts.pending}</div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.status_counts.cooking}</div>
                    <div class="stat-label">Cooking</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.status_counts.ready}</div>
                    <div class="stat-label">Ready</div>
                </div>
            `;
        }
        
        function displayOrders(orders) {
            const tbody = document.getElementById('ordersTableBody');
            
            if (orders.length === 0) {
                tbody.innerHTML = '<tr><td colspan="7" style="text-align: center; color: #7f8c8d;">No orders found for this date</td></tr>';
            } else {
                tbody.innerHTML = orders.map(order => `
                    <tr>
                        <td>
                            <strong>${order.order_number.substring(0, 8)}...</strong><br>
                            <small>${new Date(order.created_at).toLocaleTimeString()}</small>
                        </td>
                        <td>
                            <strong>${order.customer_name}</strong><br>
                            <small>${order.customer_email || ''}</small><br>
                            <small>${order.customer_phone || ''}</small>
                        </td>
                        <td>
                            <strong>${order.slot.time_slot}</strong><br>
                            <small>${order.slot.date}</small>
                        </td>
                        <td>
                            <strong>${order.items_count} items</strong><br>
                            <small>${order.items.map(item => `${item.name} x${item.quantity}`).join(', ')}</small>
                            ${order.special_instructions ? `<br><em style="color: #e67e22;">${order.special_instructions}</em>` : ''}
                        </td>
                        <td><strong>$${parseFloat(order.total).toFixed(2)}</strong></td>
                        <td>
                            <span class="status-badge status-${order.status}">${order.status}</span>
                        </td>
                        <td>
                            <div class="status-actions">
                                ${getStatusActions(order)}
                            </div>
                        </td>
                    </tr>
                `).join('');
            }
        }
        
        function getStatusActions(order) {
            const actions = [];
            
            switch (order.status) {
                case 'pending':
                    actions.push(`<button class="btn btn-success" onclick="updateOrderStatus(${order.id}, 'accepted')">Accept</button>`);
                    actions.push(`<button class="btn btn-danger" onclick="updateOrderStatus(${order.id}, 'canceled')">Cancel</button>`);
                    break;
                case 'accepted':
                    actions.push(`<button class="btn btn-warning" onclick="updateOrderStatus(${order.id}, 'cooking')">Start Cooking</button>`);
                    actions.push(`<button class="btn btn-danger" onclick="updateOrderStatus(${order.id}, 'canceled')">Cancel</button>`);
                    break;
                case 'cooking':
                    actions.push(`<button class="btn btn-primary" onclick="updateOrderStatus(${order.id}, 'ready')">Mark Ready</button>`);
                    break;
                case 'ready':
                    actions.push(`<button class="btn btn-success" onclick="updateOrderStatus(${order.id}, 'completed')">Complete</button>`);
                    break;
                case 'completed':
                    actions.push(`<span style="color: #27ae60;">✓ Completed</span>`);
                    break;
                case 'canceled':
                    actions.push(`<span style="color: #e74c3c;">✗ Canceled</span>`);
                    break;
            }
            
            return actions.join('');
        }
        
        async function updateOrderStatus(orderId, newStatus) {
            try {
                const response = await fetch(`${BASE_URL}/api/orders/${orderId}/status`, {
                    method: 'PATCH',
                    headers: {
                        'X-API-KEY': API_KEY,
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ status: newStatus })
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                const data = await response.json();
                
                if (data.success) {
                    // Refresh the orders list
                    loadOrders();
                } else {
                    throw new Error(data.message || 'Failed to update order status');
                }
            } catch (error) {
                alert('Failed to update order status: ' + error.message);
            }
        }
        
        function showLoading() {
            document.getElementById('loadingIndicator').style.display = 'block';
            document.getElementById('ordersTable').style.display = 'none';
            document.getElementById('errorContainer').style.display = 'none';
        }
        
        function hideLoading() {
            document.getElementById('loadingIndicator').style.display = 'none';
            document.getElementById('ordersTable').style.display = 'table';
        }
        
        function showError(message) {
            const errorContainer = document.getElementById('errorContainer');
            errorContainer.innerHTML = `<div class="error">${message}</div>`;
            errorContainer.style.display = 'block';
            document.getElementById('ordersTable').style.display = 'none';
        }
    </script>
</body>
</html>