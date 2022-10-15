import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mapalus_partner/data/models/delivery_modifiers.dart';
import 'package:mapalus_partner/data/models/users_info.dart';
import 'package:mapalus_partner/data/repo/app_repo.dart';
import 'package:mapalus_partner/shared/values.dart';


import 'dart:developer' as dev;

class AppSettingsController extends GetxController {
  AppRepo appRepo = Get.find();

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

    await appRepo.setDeliveryModifiers(delivery);
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
  }

  void onRefreshAccountInfo() async {
    isLoading.value = true;
    await _loadAccountInfo();
    isLoading.value = false;
  }

  _loadDelivery() async {
    deliveryModifiers = await appRepo.getDeliveryModifiers();
    if (deliveryModifiers == null) {
      return;
    }
    tecDistancePrice.text = deliveryModifiers!.distancePrice.toInt().toString();
    tecDistanceUnit.text = deliveryModifiers!.distanceUnit.toInt().toString();
    tecWeightPrice.text = deliveryModifiers!.weightPrice.toInt().toString();
    tecWeightUnit.text = deliveryModifiers!.weightUnit.toInt().toString();
  }

  _loadAccountInfo() async {
     UsersInfo usersInfo = await appRepo.getUsersInfo();

    final lastQuery = Jiffy(usersInfo.lastQuery, Values.formatRawDate ).endOf(Units.DAY);
    final lastQueryExpiration = lastQuery.clone().add(days: 1).endOf(Units.DAY);

    if (Jiffy().isAfter(lastQueryExpiration)) {
      dev.log("FRESH QUERY");
      usersInfo = await appRepo.queryUsersInfo(Jiffy().endOf(Units.DAY).format(Values.formatRawDate));
    }


    this.lastQuery = usersInfo.lastQuery;
    verifiedAccountCount = usersInfo.verifiedAccountCount;
    hadOrderCount = usersInfo.hadOrderCount;
  }
}
