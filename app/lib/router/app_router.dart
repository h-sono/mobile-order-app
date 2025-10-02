import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/menu_list.dart';
import '../screens/menu_detail.dart';
import '../screens/cart.dart';
import '../screens/order_complete.dart';

final appRouter = GoRouter(
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/menu',
      builder: (context, state) => const MenuListScreen(),
    ),
    GoRoute(
      path: '/menu/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return MenuDetailScreen(menuId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/order-complete',
      builder: (context, state) => const OrderCompleteScreen(),
    ),
  ],
);