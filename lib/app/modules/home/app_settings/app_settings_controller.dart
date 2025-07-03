import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';

class AppSettingsController extends GetxController {
  PartnerRepo partnerRepo = Get.find();

  var tecDistancePrice = TextEditingController();
  var tecDistanceUnit = TextEditingController();
  var tecWeightPrice = TextEditingController();
  var tecWeightUnit = TextEditingController();

  DeliveryModifiers? deliveryModifiers;

  var verifiedAccountCount = 0;
  var hadOrderCount = 0;
  var lastQuery = "";

  var isLoading = true.obs;

  @override
  Future<void> onReady() async {
    isLoading.value = true;
    await _loadDelivery();
    await _loadAccountInfo();
    isLoading.value = false;

    super.onReady();
  }

  void onPressedSaveSettings() async {
    isLoading.value = true;
    final delivery = DeliveryModifiers(
      distancePrice: double.parse(tecDistancePrice.text.trim()),
      distanceUnit: double.parse(tecDistanceUnit.text.trim()),
      weightPrice: double.parse(tecWeightPrice.text.trim()),
      weightUnit: double.parse(tecWeightUnit.text.trim()),
    );

    await partnerRepo.setDeliveryModifiers(delivery);
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void onRefreshAccountInfo() async {
    isLoading.value = true;
    await _loadAccountInfo();
    isLoading.value = false;
  }

  Future<void> _loadDelivery() async {
    deliveryModifiers = await partnerRepo.getDeliveryModifiers();
    if (deliveryModifiers == null) {
      return;
    }
    // dev.log(deliveryModifiers.toString());
    // tecDistancePrice.text =
    //     deliveryModifiers!.distancePrice.toStringWithoutPointZeroTrail();
    // tecDistanceUnit.text =
    //     deliveryModifiers!.distanceUnit.toStringWithoutPointZeroTrail();
    // tecWeightPrice.text =
    //     deliveryModifiers!.weightPrice.toStringWithoutPointZeroTrail();
    // tecWeightUnit.text =
    //     deliveryModifiers!.weightUnit.toStringWithoutPointZeroTrail();
  }

  Future<void> _loadAccountInfo() async {
    // UsersInfo usersInfo = await partnerRepo.getUsersInfo();
    //
    // final lastQuery =
    //     Jiffy(usersInfo.lastQuery, Values.formatRawDate).endOf(Units.DAY);
    // final lastQueryExpiration = lastQuery.clone().add(days: 1).endOf(Units.DAY);
    //
    // if (Jiffy().isAfter(lastQueryExpiration)) {
    //   dev.log("FRESH QUERY");
    //   usersInfo = await partnerRepo.queryUsersInfo(
    //       Jiffy().endOf(Units.DAY).format(Values.formatRawDate));
    // }
    //
    // this.lastQuery = usersInfo.lastQuery;
    // verifiedAccountCount = usersInfo.verifiedAccountCount;
    // hadOrderCount = usersInfo.hadOrderCount;
  }
}
