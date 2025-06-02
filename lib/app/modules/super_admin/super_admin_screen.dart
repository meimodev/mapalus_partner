import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/modules.dart';
import 'package:mapalus_partner/shared/routes.dart';

import 'widgets/widget.dart';

class SuperAdminScreen extends GetView<SuperAdminController> {
  const SuperAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap.h24,
          Text(
            'Super Admin',
            textAlign: TextAlign.start,
            style: BaseTypography.displaySmall.toBold.toPrimary,
          ),
          Gap.h12,
          Container(
            decoration: BoxDecoration(border: Border.all()),
            padding: EdgeInsets.symmetric(horizontal: BaseSize.w12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gap.h12,
                DateRangePickerWidget(
                  onChangedDate: controller.onChangedDate,
                ),
                Gap.h12,
                DropDownButtonOrderStatusWidget(
                  list: OrderStatus.values,
                  onChangeOrderStatus: controller.onChangedOrderStatus,
                ),
                Gap.h12,
              ],
            ),
          ),
          Gap.h24,
          Expanded(
            child: Obx(
              () => LoadingWrapper(
                loading: controller.loading.value,
                child: controller.orders.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada pesanan untuk hari ini',
                          style: BaseTypography.bodySmall,
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
    );
  }
}
