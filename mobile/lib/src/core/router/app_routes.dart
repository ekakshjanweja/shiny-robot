import 'package:go_router/go_router.dart';
import 'package:mobile/src/modules/auth/ui/auth_page.dart';
import 'package:mobile/src/modules/home/home_page.dart';

class AppRoutes {
  static const String initialRoute = HomePage.routeName;
  static const List<String> publicRoutes = [AuthPage.routeName];

  static final List<RouteBase> routes = [
    GoRoute(
      path: AuthPage.routeName,

      name: AuthPage.routeName,
      builder: (context, state) => const AuthPage(),
    ),
    GoRoute(
      path: HomePage.routeName,
      name: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
  ];
}
