import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/order_detail/order_detail_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/app/widgets/card_order_detail_item.dart';

class OrderDetailScreen extends GetView<OrderDetailController> {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      backgroundColor: BaseColor.accent,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: BaseSize.w12,
            child: Row(
              children: [
                const CardNavigation(
                  isInverted: true,
                  isCircular: true,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        '#${controller.order.value}',
                        style: const TextStyle(
                          color: BaseColor.cardBackground1,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${controller.order.value.products.length} Produk',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10.sp,
                          color: BaseColor.cardBackground1,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          "controller.order.value.orderInfo.deliveryTime",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                            color: BaseColor.cardBackground1,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          'Dipesan ${controller.order.value}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                            color: BaseColor.cardBackground1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: BaseSize.h24,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      child: controller.isLoading.isTrue
                          ? _buildLoadingLayout()
                          : _buildMainLayout(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: BaseSize.w12,
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: controller.productOrdersChecked.isEmpty
                    ? const SizedBox()
                    : _buildItemChecker(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildLoadingLayout() {
    return const Center(
      child: CircularProgressIndicator(
        color: BaseColor.primary3,
      ),
    );
  }

  _buildMainLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Obx(
              () => Column(
                children: [
                  for (int i = 0;
                      i < controller.order.value.products.length;
                      i++)
                    CardOrderDetailItem(
                      index: (i + 1).toString(),
                      productName:
                          controller.order.value.products[i].product.name,
                      productPrice: "controller.order.value.products[i]",
                      productWeight:
                          '${controller.order.value.products[i]} ${controller.order.value.products[i].product.unit}',
                      onChangeCheck: (value) {
                        controller.onChangeCheck(
                            value, controller.order.value.products[i]);
                      },
                    ),
                  Gap.h12,
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: BaseSize.w12,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: BaseSize.w12,
                      vertical: BaseSize.h12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(BaseSize.radiusMd),
                      color: BaseColor.cardBackground1,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            _buildDeliveryInfoLayout(context),
                            controller.order.value.payment.amount != 0
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: BaseSize.h12,
                                    ),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: BaseColor.accent,
                                      ),
                                    )),
                                    child: _buildPaymentInfoLayout(context),
                                  )
                                : const SizedBox(),
                            SizedBox(height: BaseSize.h12),
                            controller.order.value.note.isNotEmpty
                                ? _BuildNoteCard(
                                    note: controller.order.value.note)
                                : const SizedBox(),
                            SizedBox(height: BaseSize.h12),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Produk",
                                "${controller.order.value.products.length} Produk",
                                "controller.order.value.orderInfo.",
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Pengantaran",
                                "controller.order.value.orderInfo",
                                "controller.order.value.orderInfo.deliveryPriceF",
                              ),
                            ),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Total Pembayaran",
                                '',
                                "controller.order.value.orderInfo.totalPriceF",
                                highLight: true,
                              ),
                            ),
                          ],
                        ),
                        Gap.h24,
                        _buildConfirmFinishLayout(
                          orderStatus: controller.order.value.status,
                          rating: controller.order.value.rating,
                        ),
                      ],
                    ),
                  ),
                  Gap.h24,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildConfirmFinishLayout({
    required OrderStatus orderStatus,
    required Rating? rating,
  }) {
    switch (orderStatus) {
      case OrderStatus.placed:
        return _BuildConfirmationLayout(
          onPressedNegative: controller.onPressedNegative,
          onPressedPositive: controller.onPressedPositive,
        );
      case OrderStatus.accepted:
        return _BuildDeliverLayout(
          onPressedDeliver: controller.onPressedDeliver,
        );
      case OrderStatus.rejected:
        return Column(
          children: [
            Text(
              'Order telah dibatalkan',
              style: TextStyle(
                fontSize: 12.sp,
                color: BaseColor.negative,
              ),
            ),
            Text(
              "controller.order.",
              style: TextStyle(
                fontSize: 12.sp,
                color: BaseColor.negative,
              ),
            ),
          ],
        );
      case OrderStatus.delivered:
        return Column(
          children: [
            Text(
              'Order telah diantar',
              style: TextStyle(
                fontSize: 12.sp,
                color: BaseColor.positive,
              ),
            ),
            Text(
              "controller.order.value",
              style: TextStyle(
                fontSize: 12.sp,
                color: BaseColor.positive,
              ),
            ),
          ],
        );
      case OrderStatus.finished:
        return _BuildRatedLayout(order: controller.order.value);
      case OrderStatus.canceled:
        // TODO: Handle this case.
        break;
    }
  }

  _buildDeliveryInfoLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: BaseSize.h12,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: BaseColor.accent,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "controller.order.value.orderInfo.deliveryTime",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                "controller.order.value.orderingUser.name",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SelectableText(
                "controller.order.value.orderingUser.phone",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHelperButton(Icons.place, controller.onPressedViewMaps),
              Gap.h12,
              _buildHelperButton(Icons.chat, controller.onPressedViewWhatsApp),
              Gap.h12,
              _buildHelperButton(Icons.phone, controller.onPressedViewPhone),
            ],
          ),
        ],
      ),
    );
  }

  _buildPaymentInfoLayout(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pembayaran",
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
                fontWeight: FontWeight.w300,
              ),
            ),
            Text(
              "controller.order.value.paymentMethodF",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildHelperButton(
    IconData icon,
    void Function() onPressed,
  ) =>
      Material(
        color: BaseColor.primary3,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12.sp),
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(
              icon,
              color: BaseColor.accent,
              size: BaseSize.radiusMd,
            ),
          ),
        ),
      );

  _buildRowItem(
    BuildContext context,
    String title,
    String sub,
    String value, {
    bool highLight = false,
  }) =>
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                highLight
                    ? const SizedBox()
                    : Text(
                        sub,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey,
                        ),
                      ),
              ],
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );

  _buildItemChecker(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          vertical: BaseSize.h12,
          horizontal: BaseSize.h12,
        ),
        decoration: const BoxDecoration(
          color: BaseColor.editable,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(
                "${controller.productOrdersChecked.length} / ${controller.order.value.products.length}")),
            Obx(() => Text(controller.totalCheckedPrice.value)),
          ],
        ),
      );
}

// class _BuildFinishingLayout extends StatelessWidget {
//   const _BuildFinishingLayout({Key? key, required this.onPressedFinish})
//       : super(key: key);
//
//   final VoidCallback onPressedFinish;
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: BaseColor.primary,
//       borderRadius: BorderRadius.circular(12.sp),
//       child: InkWell(
//         onTap: onPressedFinish,
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             vertical: Insets.small.h,
//             horizontal: Insets.medium.w,
//           ),
//           child: Center(
//             child: Text(
//               'Finish Order',
//               style: TextStyle(
//                 fontSize: 14.sp,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _BuildDeliverLayout extends StatelessWidget {
  const _BuildDeliverLayout({required this.onPressedDeliver});

  final VoidCallback onPressedDeliver;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.primary3,
      borderRadius: BorderRadius.circular(12.sp),
      child: InkWell(
        onTap: onPressedDeliver,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: BaseSize.h12,
            horizontal: BaseSize.w12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping,
                color: BaseColor.accent,
                size: 15.sp,
              ),
              Gap.w8,
              const Text(
                'Antar Pesanan',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildConfirmationLayout extends StatelessWidget {
  const _BuildConfirmationLayout({
    required this.onPressedPositive,
    required this.onPressedNegative,
  });

  final VoidCallback onPressedPositive;
  final VoidCallback onPressedNegative;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(
          icon: Icons.clear,
          backgroundColor: BaseColor.negative,
          onPressed: onPressedNegative,
        ),
        _buildButton(
          icon: Icons.check,
          backgroundColor: BaseColor.positive,
          onPressed: onPressedPositive,
        ),
      ],
    );
  }

  _buildButton({
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: backgroundColor,
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(BaseSize.radiusMd),
          child: Center(
            child: Icon(
              icon,
              color: BaseColor.cardBackground1,
              size: 18.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildRatedLayout extends StatelessWidget {
  const _BuildRatedLayout({
    required this.order,
  });

  final OrderApp order;

  @override
  Widget build(BuildContext context) {
    final rating = order.rating;
    if (rating == null) {
      return const SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(
        bottom: BaseSize.h12,
        top: BaseSize.h6,
      ),
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: rating.rate.toDouble(),
            minRating: rating.rate.toDouble(),
            maxRating: rating.rate.toDouble(),
            direction: Axis.horizontal,
            itemCount: 5,
            glowColor: BaseColor.editable.withOpacity(.25),
            itemSize: 27.sp,
            itemPadding: EdgeInsets.symmetric(horizontal: 6.w),
            onRatingUpdate: (_) {},
            itemBuilder: (_, int index) => SvgPicture.asset(
              'assets/vectors/star.svg',
              colorFilter: const ColorFilter.mode(
                BaseColor.primary3,
                BlendMode.srcIn,
              ),
            ),
            updateOnDrag: false,
            ignoreGestures: true,
            unratedColor: BaseColor.accent,
          ),
          Gap.h12,
          Text(
            'Dinilai ${order.lastUpdate.ddMmmmYyyy}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          Gap.h6,
          Text(
            rating.message,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildNoteCard extends StatelessWidget {
  const _BuildNoteCard({
    required this.note,
  });

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.sp),
        color: BaseColor.editable,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w12,
        vertical: BaseSize.h12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.edit_note_rounded, size: 15.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: ReadMoreText(
              '$note ',
              trimLines: 1,
              colorClickableText: BaseColor.primary3,
              trimMode: TrimMode.Line,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
              ),
              delimiter: "  . . .  ",
              delimiterStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
