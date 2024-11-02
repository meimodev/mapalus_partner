import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/shared/routes.dart';

import 'orders_list_controller.dart';

class OrdersListScreen extends GetView<OrdersListController> {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w24,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gap.h24,
              IntrinsicHeight(
                child: Row(
                  children: [
                    BackButton(
                      color: BaseColor.primary3,
                    ),
                    Gap.w12,
                    Text(
                      'Riwayat Pesanan',
                      textAlign: TextAlign.start,
                      style: BaseTypography.displayMedium.toBold.toPrimary,
                    ),
                  ],
                ),
              ),
              Gap.h12,
              Expanded(
                child: Obx(
                  () => LoadingWrapper(
                    loading: controller.loading.value,
                    child: controller.orders.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Pesanan tidak ditemukan',
                                  style: BaseTypography.bodySmall,
                                ),
                                Gap.h12,
                                Text(
                                  '-_-',
                                  style: BaseTypography.bodySmall,
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.orders.length,
                            separatorBuilder: (context, index) => Gap.h12,
                            itemBuilder: (context, index) => CardOrder(
                              order: controller.orders[index],
                              onPressed: () {
                                Get.toNamed(
                                  Routes.orderDetail,
                                  arguments: controller.orders[index],
                                );
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: BaseSize.h24,
            child: ButtonWidget(
              backgroundColor: BaseColor.accent,
              icon: Icons.filter_alt_rounded,
              textColor: BaseColor.primary3,
              onPressed: () async {
                final result = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2023),
                  lastDate: DateTime.now(),
                );
                if (result != null) {
                  controller.onChangedFilterDate(result);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
