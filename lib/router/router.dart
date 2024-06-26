import 'package:feedback_fusion/pages/splash.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = "splash";

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: splash,
        path: "/",
        builder: (context, state) => const SplashPage(),
      ),
    ],
  );
}
