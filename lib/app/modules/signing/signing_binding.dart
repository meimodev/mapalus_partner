import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';

class SigningBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SigningController>(SigningController());
  }
}