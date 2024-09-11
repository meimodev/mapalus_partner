import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
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
                    'Senin, 11 September 2024',
                    textAlign: TextAlign.start,
                    style: BaseTypography.bodySmall,
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(
                    BaseSize.radiusMd,
                  ),
                  color: BaseColor.primary3,
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: BaseSize.w12,
                        vertical: BaseSize.h12,
                      ),
                      child: Text(
                        'See All',
                        textAlign: TextAlign.start,
                        style: BaseTypography.bodySmall.toBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Gap.h12,
          controller.orders.isEmpty
              ? const Expanded(
                  child: Center(
                    child: Text('No Order Yet'),
                  ),
                )
              : Expanded(
                  child: Obx(
                    () => LoadingWrapper(
                      loading: controller.loading.value,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.orders.length,
                        separatorBuilder: (context, index) => Gap.h12,
                        itemBuilder: (context, index) => CardOrder(
                          order: controller.orders[index],
                          onPressed: () {
                            Get.toNamed(Routes.orderDetail);
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
