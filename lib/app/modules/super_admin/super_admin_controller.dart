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


  // Filter state
  OrderStatus? filterOrderStatus;
  DateTimeRange? filterDateTimeRange;

  @override
  void onReady() async {
    super.onReady();
    // _partner = await partnerRepo.getCurrentPartner();
    listenToOrders();
  }

  Future<void> listenToOrders() async {
    loading.value = true;
    filterOrderStatus = OrderStatus.placed;
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
        recalculateFilter();
        loading.value = false;
      },
    );

    orders = await orderRepo.readOrders(req);
    loading.value = false;
  }

  void onChangedOrderStatus(OrderStatus value) async {
    filterOrderStatus = value;
    orders = await orderRepo.readOrders(GetOrdersRequest());
    recalculateFilter();
  }

  void onChangedDate(DateTimeRange value) async {
    filterDateTimeRange = value;
    orders = await orderRepo.readOrders(GetOrdersRequest());
    recalculateFilter();
  }

  void recalculateFilter() {
    loading.value = true;

    if (filterOrderStatus != null) {
      orders = orders.where((e) => e.status == filterOrderStatus).toList();
    }

    if (filterDateTimeRange != null) {
      orders = orders.where((e) {

        return e.createdAt
                .isAfter(filterDateTimeRange!.start.toStartOfTheDay) &&
            e.createdAt.isBefore(filterDateTimeRange!.end.toEndOfTheDay);
      }).toList();
    }
    loading.value = false;
  }
}
