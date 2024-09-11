import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppRepo());
    Get.lazyPut(() => UserRepoPartner());
    Get.lazyPut<OrderRepo>(() => OrderRepoImpl());
    Get.lazyPut(() => ProductRepo());
    Get.lazyPut(() => PartnerRepo());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => OrdersController());
  }
}
