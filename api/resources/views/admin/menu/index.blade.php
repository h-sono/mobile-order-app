<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Menu Management - Mobile Order App</title>
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
        
        .nav-links {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .nav-links a {
            padding: 0.5rem 1rem;
            background: #ecf0f1;
            color: #2c3e50;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.2s;
        }
        
        .nav-links a:hover,
        .nav-links a.active {
            background: #3498db;
            color: white;
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
        
        .menu-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .section-header {
            background: #34495e;
            color: white;
            padding: 1rem;
            font-weight: bold;
            border-radius: 8px 8px 0 0;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1rem;
            padding: 1rem;
        }
        
        .menu-item {
            border: 1px solid #ecf0f1;
            border-radius: 8px;
            padding: 1rem;
            transition: box-shadow 0.2s;
        }
        
        .menu-item:hover {
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .menu-item.unavailable {
            opacity: 0.6;
            background: #f8f9fa;
        }
        
        .menu-item-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 0.5rem;
        }
        
        .menu-item-name {
            font-weight: bold;
            font-size: 1.1rem;
            color: #2c3e50;
        }
        
        .menu-item-price {
            font-weight: bold;
            color: #27ae60;
        }
        
        .menu-item-description {
            color: #7f8c8d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
            line-height: 1.4;
        }
        
        .availability-toggle {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .toggle-switch {
            position: relative;
            width: 50px;
            height: 24px;
            background: #ccc;
            border-radius: 12px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .toggle-switch.active {
            background: #27ae60;
        }
        
        .toggle-switch::after {
            content: '';
            position: absolute;
            top: 2px;
            left: 2px;
            width: 20px;
            height: 20px;
            background: white;
            border-radius: 50%;
            transition: transform 0.2s;
        }
        
        .toggle-switch.active::after {
            transform: translateX(26px);
        }
        
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
        
        .success {
            background: #d4edda;
            color: #155724;
            padding: 1rem;
            border-radius: 4px;
            margin: 1rem 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Menu Management</h1>
        <div class="nav-links">
            <a href="/admin/orders">Orders Dashboard</a>
            <a href="/admin/menu" class="active">Menu Management</a>
        </div>
    </div>

    <div class="container">
        <div id="statsContainer" class="stats">
            <!-- Stats will be populated by JavaScript -->
        </div>

        <div id="loadingIndicator" class="loading">
            Loading menu items...
        </div>
        
        <div id="errorContainer" style="display: none;"></div>
        <div id="successContainer" style="display: none;"></div>
        
        <div id="menuContainer">
            <!-- Menu items will be populated by JavaScript -->
        </div>
    </div>

    <script>
        const API_KEY = '{{ $apiKey }}';
        const BASE_URL = window.location.origin;
        
        let currentMenuItems = [];
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            loadMenuItems();
        });
        
        async function loadMenuItems() {
            showLoading();
            
            try {
                const response = await fetch(`${BASE_URL}/api/admin/menu`, {
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
                    currentMenuItems = data.data.menu_items;
                    displayStats(data.data.stats);
                    displayMenuItems(data.data.menu_items);
                    hideLoading();
                } else {
                    throw new Error(data.message || 'Failed to load menu items');
                }
            } catch (error) {
                showError('Failed to load menu items: ' + error.message);
                hideLoading();
            }
        }
        
        function displayStats(stats) {
            const statsContainer = document.getElementById('statsContainer');
            statsContainer.innerHTML = `
                <div class="stat-card">
                    <div class="stat-number">${stats.total_items}</div>
                    <div class="stat-label">Total Items</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.available_items}</div>
                    <div class="stat-label">Available</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">${stats.unavailable_items}</div>
                    <div class="stat-label">Sold Out</div>
                </div>
            `;
        }
        
        function displayMenuItems(menuItems) {
            const menuContainer = document.getElementById('menuContainer');
            
            if (menuItems.length === 0) {
                menuContainer.innerHTML = '<div class="loading">No menu items found</div>';
                return;
            }
            
            menuContainer.innerHTML = menuItems.map(categoryGroup => `
                <div class="menu-section">
                    <div class="section-header">${categoryGroup.category}</div>
                    <div class="menu-grid">
                        ${categoryGroup.items.map(item => `
                            <div class="menu-item ${!item.is_available ? 'unavailable' : ''}">
                                <div class="menu-item-header">
                                    <div class="menu-item-name">${item.name}</div>
                                    <div class="menu-item-price">$${parseFloat(item.price).toFixed(2)}</div>
                                </div>
                                <div class="menu-item-description">${item.description || ''}</div>
                                <div class="availability-toggle">
                                    <span>Available:</span>
                                    <div class="toggle-switch ${item.is_available ? 'active' : ''}" 
                                         onclick="toggleAvailability(${item.id}, ${!item.is_available})">
                                    </div>
                                    <span>${item.is_available ? 'Yes' : 'Sold Out'}</span>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `).join('');
        }
        
        async function toggleAvailability(itemId, newAvailability) {
            try {
                const response = await fetch(`${BASE_URL}/api/admin/menu/${itemId}/availability`, {
                    method: 'PATCH',
                    headers: {
                        'X-API-KEY': API_KEY,
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify({ isAvailable: newAvailability })
                });
                
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: ${response.statusText}`);
                }
                
                const data = await response.json();
                
                if (data.success) {
                    showSuccess(`${data.data.name} availability updated successfully`);
                    // Refresh the menu items
                    loadMenuItems();
                } else {
                    throw new Error(data.message || 'Failed to update menu item');
                }
            } catch (error) {
                showError('Failed to update menu item: ' + error.message);
            }
        }
        
        function showLoading() {
            document.getElementById('loadingIndicator').style.display = 'block';
            document.getElementById('menuContainer').style.display = 'none';
            document.getElementById('errorContainer').style.display = 'none';
            document.getElementById('successContainer').style.display = 'none';
        }
        
        function hideLoading() {
            document.getElementById('loadingIndicator').style.display = 'none';
            document.getElementById('menuContainer').style.display = 'block';
        }
        
        function showError(message) {
            const errorContainer = document.getElementById('errorContainer');
            errorContainer.innerHTML = `<div class="error">${message}</div>`;
            errorContainer.style.display = 'block';
            
            setTimeout(() => {
                errorContainer.style.display = 'none';
            }, 5000);
        }
        
        function showSuccess(message) {
            const successContainer = document.getElementById('successContainer');
            successContainer.innerHTML = `<div class="success">${message}</div>`;
            successContainer.style.display = 'block';
            
            setTimeout(() => {
                successContainer.style.display = 'none';
            }, 3000);
        }
    </script>
</body>
</html>