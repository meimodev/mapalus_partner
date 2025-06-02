import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class SuperAdminController extends GetxController {
  final orderRepo = Get.find<OrderRepo>();
  final partnerRepo = Get.find<PartnerRepo>();

  List<OrderApp> orders = [];

  RxBool loading = true.obs;

  Partner? _partner;

  @override
  void onReady() async {
    super.onReady();
    _partner = await partnerRepo.getCurrentPartner();
    listenToOrders();
  }

  Future<void> listenToOrders() async {
    loading.value = true;
    final req = GetOrdersRequest(
      // partnerId: _partner!.id,
      // dateRange: DateTimeRange(
      //   start: DateTime.now().toStartOfTheWeek,
      //   end: DateTime.now().toEndOfTheWeek,
      // ),
    );
    final streamOrders = orderRepo.readOrdersStream(req);

    streamOrders.listen(
      (event) {
        loading.value = true;
        orders = event;
        loading.value = false;
      },
    );

    orders = await orderRepo.readOrders(req);
    loading.value = false;
  }
}
