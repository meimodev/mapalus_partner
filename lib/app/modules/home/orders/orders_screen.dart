import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/home/home.dart';
import 'package:mapalus_partner/shared/routes.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

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
            'Orders',
            textAlign: TextAlign.start,
            style: BaseTypography.displayLarge.toBold.toPrimary,
          ),
          Gap.h12,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    DateTime.now().EEEEddMMMyyyy,
                    textAlign: TextAlign.start,
                    style: BaseTypography.bodySmall,
                  ),
                ),
                // ButtonWidget(
                //   text: "See All",
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
          Gap.h12,
          Expanded(
            child: Obx(
              () => LoadingWrapper(
                loading: controller.loading.value,
                child: controller.orders.isEmpty
                    ? const Center(
                        child: Text('No Order Yet'),
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
