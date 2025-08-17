import 'package:go_router/go_router.dart';
import 'package:mobile/src/core/router/app_routes.dart';
import 'package:mobile/src/modules/auth/providers/auth_provider.dart';
import 'package:mobile/src/modules/auth/ui/auth_page.dart';
import 'package:mobile/src/modules/home/home_page.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.initialRoute,
    routes: AppRoutes.routes,
    redirect: (context, state) async {
      final ap = context.read<AuthProvider>();

      final isLoggedIn = ap.session != null || ap.user != null;
      final isPublicRoute = AppRoutes.publicRoutes.contains(
        state.matchedLocation,
      );

      if (!isLoggedIn && !isPublicRoute) {
        return AuthPage.routeName;
      }

      if (isLoggedIn && isPublicRoute) {
        return HomePage.routeName;
      }

      return null;
    },
  );
}
