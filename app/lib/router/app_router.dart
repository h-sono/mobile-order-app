import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/menu_list.dart';
import '../screens/menu_detail.dart';
import '../screens/cart.dart';
import '../screens/slot_selection.dart';
import '../screens/order_confirmation.dart';
import '../screens/order_complete.dart';
import '../screens/help.dart';

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
      path: '/slot-selection',
      builder: (context, state) => const SlotSelectionScreen(),
    ),
    GoRoute(
      path: '/order-confirmation',
      builder: (context, state) => const OrderConfirmationScreen(),
    ),
    GoRoute(
      path: '/order-complete',
      builder: (context, state) => const OrderCompleteScreen(),
    ),
    GoRoute(
      path: '/help',
      builder: (context, state) => const HelpScreen(),
    ),
  ],
);