import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/repos/repos.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class OrdersListController extends GetxController {
  final orderRepo = Get.find<OrderRepo>();
  final partnerRepo = Get.find<PartnerRepo>();

  List<OrderApp> orders = [];

  RxBool loading = true.obs;

  Partner? _partner;

  @override
  void onReady() async {
    super.onReady();
    _partner = await partnerRepo.getCurrentPartner();
    listenToProducts();
  }

  Future<void> listenToProducts() async {
    loading.value = true;
    final req = GetOrdersRequest(
      partnerId: _partner!.id,
      dateRange: DateTimeRange(
        start: DateTime.now().toStartOfTheYear,
        end: DateTime.now(),
      ),
    );

    orders = await orderRepo.readOrders(req);
    loading.value = false;
  }

  void onChangedFilterDate(DateTimeRange result) async {
    loading.value = true;
    orders = await orderRepo.readOrders(
      GetOrdersRequest(
        partnerId: _partner!.id,
        dateRange: result,
      ),
    );
    loading.value = false;
  }
}
