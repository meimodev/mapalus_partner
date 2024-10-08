import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/services/services.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppRepo());
    Get.put(UserPartnerRepo());
    Get.put(NotificationService());
    Get.lazyPut<OrderRepo>(() => OrderRepoImpl());
    Get.lazyPut(() => ProductRepo());
    Get.lazyPut(() => PartnerRepo());

    //Controllers
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => ProductsController());
  }
}
