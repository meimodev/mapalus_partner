import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class SigningBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppRepo>(AppRepo());
    Get.put<UserRepoPartner>(UserRepoPartner());
    Get.put<SigningController>(SigningController());
  }
}