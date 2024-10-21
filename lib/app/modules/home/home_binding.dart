import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/services/services.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    //main repo
    Get.put(AppRepo());

    //main services
    Get.put(NotificationService());
    Get.put(LocalStorageService());

    //specific repos
    Get.lazyPut<OrderRepo>(() => OrderRepoImpl());
    Get.lazyPut<ProductRepo>(() => ProductRepo());
    Get.lazyPut<PartnerRepo>(() => PartnerRepo());
    Get.put<UserRepo>(
      UserRepo(
        appRepo: Get.find<AppRepo>(),
        localStorageService: Get.find<LocalStorageService>(),
      ),
    );

    //controllers
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DashboardController());
    Get.lazyPut(() => OrdersController());
    Get.lazyPut(() => ProductsController());
  }
}
