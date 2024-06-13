import 'package:etechstore/module/auth/views/sign_in_screen.dart';
import 'package:etechstore/module/auth/views/splash_screen.dart';
import 'package:etechstore/module/home/views/home_screen.dart';
import 'package:etechstore/module/product_detail/view/product_detail_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class NavBarController {
  static String splash = '/';
  static String login = '/login';
  static String home = '/login/home';

  static String getHomeRoute() => home;
  static String getSplash() => splash;

  static String getLogin() => login;

  static List<GetPage> routes = [
    GetPage(page: () => const SplashScreen(), name: splash),
    GetPage(page: () => const SignInScreen(), name: login),
    GetPage(page: () => const HomeScreen(), name: home),
  ];
}
