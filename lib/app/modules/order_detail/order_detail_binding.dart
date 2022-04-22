import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/order_detail/order_detail_controller.dart';

class OrderDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OrderDetailController>(OrderDetailController());
  }
}