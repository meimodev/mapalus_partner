import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/ordering/ordering_controller.dart';

class OrderingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OrderingController>(OrderingController());
  }
}