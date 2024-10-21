import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';

class SigningBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put<AppRepo>(AppRepo());
    // Get.put<UserRepo>(
    //   UserRepo(
    //     appRepo: Get.find<AppRepo>(),
    //     localStorageService: LocalStorageService(),
    //   ),
    // );
    // Get.put<PartnerRepo>(PartnerRepo());
    Get.put<SigningController>(SigningController());
  }
}
