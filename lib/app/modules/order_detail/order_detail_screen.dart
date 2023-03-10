import 'package:flutter/material.dart';
import 'package:mapalus_partner/app/modules/order_detail/order_detail_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/app/widgets/card_order_detail_item.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:get/get.dart';

class OrderDetailScreen extends GetView<OrderDetailController> {
  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      backgroundColor: Palette.accent,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: Insets.medium,
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
                        '#${controller.order.value.idMinified}',
                        style: const TextStyle(
                          color: Palette.cardForeground,
                        ),
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${controller.order.value.products.length} Produk',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10.sp,
                          color: Palette.cardForeground,
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
                          controller.order.value.orderInfo.deliveryTime,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.sp,
                            color: Palette.cardForeground,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          'Dipesan ${controller.order.value.orderTimeStamp.format("E, dd MMM HH:mm:ss")}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                            color: Palette.cardForeground,
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
            top: Insets.medium * 3,
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
            right: Insets.small,
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
        color: Palette.primary,
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
                      productPrice:
                          controller.order.value.products[i].totalPriceString,
                      productWeight:
                          '${controller.order.value.products[i].quantityString} ${controller.order.value.products[i].product.unit}',
                      onChangeCheck: (value) {
                        controller.onChangeCheck(
                            value, controller.order.value.products[i]);
                      },
                    ),
                  const SizedBox(height: Insets.small),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Insets.medium.w * .5,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.medium.h,
                      vertical: Insets.medium.w * .5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.sp),
                      color: Palette.cardForeground,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Column(
                          children: [
                            _buildDeliveryInfoLayout(context),
                            controller.order.value.paymentMethod.isNotEmpty
                                ? Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: Insets.small.h * .5,
                                    ),
                                    decoration: const BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        color: Palette.accent,
                                      ),
                                    )),
                                    child: _buildPaymentInfoLayout(context),
                                  )
                                : const SizedBox(),
                            SizedBox(height: Insets.small.h),
                            controller.order.value.note.isNotEmpty
                                ? _BuildNoteCard(
                                    note: controller.order.value.note)
                                : const SizedBox(),
                            SizedBox(height: Insets.small.h),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Produk",
                                "${controller.order.value.products.length} Produk",
                                controller.order.value.orderInfo.productPriceF,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Pengantaran",
                                controller
                                    .order.value.orderInfo.deliveryWeightF,
                                controller.order.value.orderInfo.deliveryPriceF,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Obx(
                              () => _buildRowItem(
                                context,
                                "Total Pembayaran",
                                '',
                                controller.order.value.orderInfo.totalPriceF,
                                highLight: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Insets.medium.h),
                        _buildConfirmFinishLayout(
                          orderStatus: controller.order.value.status,
                          rating: controller.order.value.rating,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Insets.medium),
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
                color: Palette.negative,
              ),
            ),
            Text(
              controller.order.value.confirmTimeStamp
                      ?.format("E, dd MMMM yyyy HH:mm") ??
                  "-",
              style: TextStyle(
                fontSize: 12.sp,
                color: Palette.negative,
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
                color: Palette.positive,
              ),
            ),
            Text(
              controller.order.value.deliverTimeStamp
                      ?.format("E, dd MMMM yyyy HH:mm") ??
                  "-",
              style: TextStyle(
                fontSize: 12.sp,
                color: Palette.positive,
              ),
            ),
          ],
        );
      case OrderStatus.finished:
        return _BuildRatedLayout(order: controller.order.value);
    }
  }

  _buildDeliveryInfoLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Insets.small.h * .5,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Palette.accent,
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
                controller.order.value.orderInfo.deliveryTime,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                controller.order.value.orderingUser.name,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SelectableText(
                controller.order.value.orderingUser.phone,
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
              const SizedBox(width: Insets.small * .5),
              _buildHelperButton(Icons.chat, controller.onPressedViewWhatsApp),
              const SizedBox(width: Insets.small * .5),
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
              controller.order.value.paymentMethodF,
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
        color: Palette.primary,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(12.sp),
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Insets.small.sp * .75,
              vertical: Insets.small.sp * .75,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Palette.accent,
                size: Insets.small.sp * 1.5,
              ),
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
        padding: const EdgeInsets.symmetric(
          vertical: Insets.small,
          horizontal: Insets.medium,
        ),
        decoration: const BoxDecoration(
          color: Palette.editable,
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
//       color: Palette.primary,
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
  const _BuildDeliverLayout({Key? key, required this.onPressedDeliver})
      : super(key: key);

  final VoidCallback onPressedDeliver;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.primary,
      borderRadius: BorderRadius.circular(12.sp),
      child: InkWell(
        onTap: onPressedDeliver,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Insets.small.h,
            horizontal: Insets.medium.w,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping,
                color: Palette.accent,
                size: 15.sp,
              ),
              const SizedBox(width: 6),
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
    Key? key,
    required this.onPressedPositive,
    required this.onPressedNegative,
  }) : super(key: key);

  final VoidCallback onPressedPositive;
  final VoidCallback onPressedNegative;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(
          icon: Icons.clear,
          backgroundColor: Palette.negative,
          onPressed: onPressedNegative,
        ),
        _buildButton(
          icon: Icons.check,
          backgroundColor: Palette.positive,
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
          padding: EdgeInsets.all(Insets.small.sp),
          child: Center(
            child: Icon(
              icon,
              color: Palette.cardForeground,
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
    Key? key,
    required this.order,
  }) : super(key: key);

  final OrderApp order;

  @override
  Widget build(BuildContext context) {
    final rating = order.rating ?? Rating.zero();
    return Container(
      margin: EdgeInsets.only(
        bottom: Insets.medium.h,
        top: Insets.small.h * .5,
      ),
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: rating.number.toDouble(),
            minRating: rating.number.toDouble(),
            maxRating: rating.number.toDouble(),
            direction: Axis.horizontal,
            itemCount: 5,
            glowColor: Palette.editable.withOpacity(.25),
            itemSize: 27.sp,
            itemPadding: EdgeInsets.symmetric(horizontal: 6.w),
            onRatingUpdate: (_) {},
            itemBuilder: (_, int index) => SvgPicture.asset(
              'assets/vectors/star.svg',
              colorFilter: const ColorFilter.mode(
                Palette.primary,
                BlendMode.srcIn,
              ),
            ),
            updateOnDrag: false,
            ignoreGestures: true,
            unratedColor: Palette.accent,
          ),
          SizedBox(height: Insets.small.h * .5),
          Text(
            'Dinilai ${order.finishTimeStamp?.format("dd MMMM yyyy") ?? '-'}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(height: Insets.small.h * .5),
          Text(
            " \"${rating.message}\" ",
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
    Key? key,
    required this.note,
  }) : super(key: key);

  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9.sp),
        color: Palette.editable,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Insets.small.sp,
        vertical: Insets.small.sp,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.edit_note_rounded, size: 15.sp),
          SizedBox(width: 6.w),
          Expanded(
            child: ReadMoreText(
              '$note  ',
              trimLines: 1,
              colorClickableText: Palette.primary,
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
