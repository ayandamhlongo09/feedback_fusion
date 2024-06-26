import 'package:feedback_fusion/pages/login.dart';
import 'package:feedback_fusion/pages/register.dart';
import 'package:feedback_fusion/pages/splash.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = "splash";
  static const String login = "login";
  static const String register = "register";

  static GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: splash,
        path: "/",
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: login,
        path: "/login",
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        name: register,
        path: "/register",
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
