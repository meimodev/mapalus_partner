import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/home/home.dart';

class OrdersScreen extends GetView<OrdersController> {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          Text(
            "products 3",
            style: BaseTypography.caption,
          ),
          Text(
            "products 3",
            style: BaseTypography.caption,
          ),
          Text(
            "products 3",
            style: BaseTypography.caption,
          ),
          Text(
            "products 3",
            style: BaseTypography.caption,
          ),

          // Expanded(
          //   child: Obx(
          //     () => AnimatedSwitcher(
          //       duration: const Duration(milliseconds: 400),
          //       child: controller.isLoading.value
          //           ? const Center(
          //               child: CircularProgressIndicator(
          //                 color: BaseColor.primary3,
          //               ),
          //             )
          //           : Padding(
          //               padding: EdgeInsets.symmetric(
          //                 horizontal: BaseSize.w12,
          //               ),
          //               child: Obx(
          //                 () => ListView.builder(
          //                   physics: const BouncingScrollPhysics(),
          //                   itemCount: controller.orders.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     OrderApp order =
          //                         controller.orders.elementAt(index);
          //                     return Padding(
          //                       padding: EdgeInsets.symmetric(
          //                         vertical: BaseSize.h12,
          //                       ),
          //                       child: CardOrder(
          //                         order: order,
          //                         onPressed: () {
          //                           Navigator.pushNamed(
          //                             context,
          //                             Routes.orderDetail,
          //                             arguments: order,
          //                           );
          //                         },
          //                       ),
          //                     );
          //                   },
          //                 ),
          //               ),
          //             ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
