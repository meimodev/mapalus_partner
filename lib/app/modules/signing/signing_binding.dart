import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';
import 'package:mapalus_partner/data/repo/app_repo.dart';

class SigningBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppRepo>(AppRepo());
    Get.put<SigningController>(SigningController());
  }
}