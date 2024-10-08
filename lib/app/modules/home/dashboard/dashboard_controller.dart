import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/partner_repo.dart';

class DashboardController extends GetxController {
  final PartnerRepo partnerRepo = Get.find();

  Rx<Partner?> partner = Rx<Partner?>(null);

  @override
  void onInit() async {
    super.onInit();

    await Future.delayed(Duration(seconds: 1));

    // Partner should be passed from login procedure
    // get partner object from local storage
    partner.value = await partnerRepo.readPartner("ssTneIKTUTtnb8L4dGWA");
  }

  void onUpdatePartner(updatedPartner) {
    partner.value = updatedPartner;
  }
}
