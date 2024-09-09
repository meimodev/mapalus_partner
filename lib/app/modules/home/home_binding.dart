import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AppRepo>(AppRepo());
    Get.put<UserRepoPartner>(UserRepoPartner());
    Get.put<OrderRepo>(OrderRepoImpl());
    Get.put<ProductRepo>(ProductRepo());
    Get.put<PartnerRepo>(PartnerRepo());
    Get.put<HomeController>(HomeController());
  }
}
