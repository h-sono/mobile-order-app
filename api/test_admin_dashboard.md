# T-14 Admin Dashboard Testing Guide

## How to Test the Admin Dashboard

### 1. Start Laravel Development Server
```bash
cd api
php artisan serve --host=127.0.0.1 --port=8000
```

### 2. Access Admin Dashboard
Open your browser and navigate to:
```
http://localhost:8000/admin/orders
```

### 3. Features to Test

#### Dashboard Features:
- **Date Selection**: Change the date and click "Load Orders"
- **Statistics Display**: View total orders, revenue, and status counts
- **Order List**: See all orders for the selected date
- **Real-time Updates**: Click "Refresh" to update the data

#### Order Management:
- **Status Updates**: Click action buttons to change order status
  - Pending → Accept/Cancel
  - Accepted → Start Cooking/Cancel
  - Cooking → Mark Ready
  - Ready → Complete
- **Order Details**: View customer info, items, pickup time, special instructions

#### API Integration:
- Uses X-API-KEY authentication automatically
- Fetches data from `/api/admin/orders?date=YYYY-MM-DD`
- Updates status via `PATCH /api/orders/{id}/status`

### 4. Expected Behavior

#### On Page Load:
- Shows today's orders by default
- Displays statistics cards
- Lists orders in a table format

#### Status Workflow:
1. **Pending** → Accept → **Accepted**
2. **Accepted** → Start Cooking → **Cooking**
3. **Cooking** → Mark Ready → **Ready**
4. **Ready** → Complete → **Completed**
5. Any status → Cancel → **Canceled**

#### Error Handling:
- Shows error messages for API failures
- Handles network connectivity issues
- Validates date input format

### 5. Test Data
The OrderSeeder creates sample orders for today and yesterday with various statuses.

### 6. Troubleshooting

If you see errors:
- Check that Laravel server is running on port 8000
- Verify ADMIN_API_KEY is set in .env file
- Ensure database has been seeded with test data
- Check browser console for JavaScript errors