import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_partner/shared/routes.dart';

class DashboardController extends GetxController {
  final PartnerRepo partnerRepo = Get.find();
  final UserRepo userRepo = Get.find();

  Rx<Partner?> partner = Rx<Partner?>(null);

  @override
  void onReady() async {
    super.onReady();

    partner.value = await partnerRepo.getCurrentPartner();
  }

  void onUpdatePartner(updatedPartner) {
    partner.value = updatedPartner;
  }

  void onPressedSuperAdminPage() {
    Get.toNamed(Routes.superAdmin);
  }
}
