import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/services/services.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<FirestoreService>(FirestoreService());

    Get.put<LocalStorageService>(LocalStorageService());
    Get.put<NotificationService>(NotificationService());
    Get.put<AppRepo>(
      AppRepo(
        firestoreService: Get.find<FirestoreService>(),
        notificationService: Get.find<NotificationService>(),
      ),
    );

    //specific repos
    Get.put<OrderRepo>(OrderRepo());
    Get.lazyPut<ProductRepo>(() => ProductRepo());
    Get.lazyPut<PartnerRepo>(
      () => PartnerRepo(
        Get.find<AppRepo>(),
        Get.find<FirestoreService>(),
      ),
    );
    Get.put<UserRepo>(
      UserRepo(
        appRepo: Get.find<AppRepo>(),
        localStorageService: Get.find<LocalStorageService>(),
      ),
    );

    //controllers
    Get.put<HomeController>(HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<OrdersController>(() => OrdersController());
    Get.lazyPut<ProductsController>(() => ProductsController());
  }
}
