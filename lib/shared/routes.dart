import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/app_settings/app_settings_binding.dart';
import 'package:mapalus_partner/app/modules/home/app_settings/app_settings_screen.dart';
import 'package:mapalus_partner/app/modules/settings/settings_binding.dart';
import 'package:mapalus_partner/app/modules/settings/settings_screen.dart';
import 'package:mapalus_partner/app/modules/home/home_binding.dart';
import 'package:mapalus_partner/app/modules/home/home_screen.dart';
import 'package:mapalus_partner/app/modules/order_detail/order_detail_binding.dart';
import 'package:mapalus_partner/app/modules/order_detail/order_detail_screen.dart';
import 'package:mapalus_partner/app/modules/orders/orders_binding.dart';
import 'package:mapalus_partner/app/modules/orders/orders_screen.dart';
import 'package:mapalus_partner/app/modules/product_detail/product_detail_binding.dart';
import 'package:mapalus_partner/app/modules/product_detail/product_detail_screen.dart';
import 'package:mapalus_partner/app/modules/signing/signing_binding.dart';
import 'package:mapalus_partner/app/modules/signing/signing_screen.dart';
import 'package:mapalus_partner/app/modules/update_app/update_app_screen.dart';

class Routes {
  static const String home = '/';
  static const String orders = '/orders';
  static const String orderDetail = '/order-detail';
  static const String productDetail = '/product-detail';
  static const String ordering = '/ordering';
  static const String signing = '/signing';
  static const String updateApp = '/update-app';
  static const String settings = '/settings';
  static const String appSettings = '/app-settings';


  static List<GetPage> getRoutes() {
    return [
      GetPage(
        name: home,
        page: () => const HomeScreen(),
        binding: HomeBinding(),
        transition: Transition.fade,
        maintainState: true,
        preventDuplicates: true,
      ),
      // GetPage(
      //   name: accountSetting,
      //   page: () => const AccountSettingsScreen(),
      //   binding: AccountSettingsBinding(),
      //   transition: Transition.cupertino,
      // ),
      GetPage(
        name: orders,
        page: () => const OrdersScreen(),
        binding: OrdersBinding(),
        transition: Transition.cupertino,
      ),
      GetPage(
        name: orderDetail,
        page: () => const OrderDetailScreen(),
        transition: Transition.cupertino,
        binding: OrderDetailBinding(),
      ),
      GetPage(
        name: productDetail,
        page: () => const ProductDetailScreen(),
        transition: Transition.cupertino,
        binding: ProductDetailBinding(),
      ),


      GetPage(
        name: signing,
        page: () => const SigningScreen(),
        binding: SigningBinding(),
        transition: Transition.leftToRight,
      ),
      GetPage(
        name: updateApp,
        page: () => const UpdateAppScreen(),
        transition: Transition.rightToLeftWithFade,
      ),
      GetPage(
        name: settings,
        page: () => const SettingsScreen(),
        binding: SettingsBinding(),
        transition: Transition.leftToRight,
      ),
      GetPage(
        name: appSettings,
        page: () => const AppSettingsScreen(),
        binding: AppSettingsBinding(),
      ),
    ];
  }
}