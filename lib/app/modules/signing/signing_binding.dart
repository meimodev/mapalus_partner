import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';

class SigningBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppRepo>(AppRepo());
    Get.put<UserPartnerRepo>(UserPartnerRepo());
    Get.put<SigningController>(SigningController());
  }
}
