import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class OrdersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OrdersListController());
  }
}
