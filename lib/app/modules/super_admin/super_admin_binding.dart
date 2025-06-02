import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/modules.dart';

class SuperAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SuperAdminController());
  }
}
