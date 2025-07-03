import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_partner/shared/routes.dart';

class AccountSettingsController extends GetxController {
  RxString userName = ''.obs;
  RxString userPhone = ''.obs;
  RxInt orderCount = 0.obs;

  UserRepo userRepo = Get.find();

  RxString currentVersion = ''.obs;

  AppRepo appRepo = Get.find();

  @override
  void onInit() {
    super.onInit();

    initVersion();
  }

  void onPressedEditAccountInfo() {}

  void onPressedOrders() {
    Get.toNamed(Routes.orders);
  }

  void onPressedSignOut() async {
    await userRepo.signOut();
  }

  void onPressedSignIn() {
    Get.toNamed(Routes.signing, arguments: "");
  }

  void initVersion() async {
    currentVersion.value = await appRepo.getCurrentVersion();
  }
}
