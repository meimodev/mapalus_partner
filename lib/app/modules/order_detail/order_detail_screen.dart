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
      child: Stack(
        children: [
          Positioned(
            right: 0,
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              color: Palette.accent,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: Insets.medium.h,
            child: Column(
              children: [
                Obx(
                  () => CardNavigation(
                    title: 'Rincian Pesanan #${controller.id.value}',
                    isInverted: true,
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      child: controller.canLoading.isTrue
                          ? _buildLoadingLayout()
                          : _buildMainLayout(context),
                    ),
                  ),
                ),
              ],
            ),
          )
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
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: Insets.medium.w * .5,
            ),
            child: Obx(
              () => ListView.builder(
                itemCount: controller.productOrders.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  ProductOrder po = controller.productOrders.elementAt(index);
                  return CardOrderDetailItem(
                    productName: po.product.name,
                    productPrice: po.totalPriceString,
                    index: (index + 1).toString(),
                    productWeight: '${po.quantityString} ${po.product.unit}',
                  );
                },
              ),
            ),
          ),
        ),
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
                  Row(
                    children: [
                      Obx(
                        () => _buildDeliveryStateCard(
                          context: context,
                          title: 'Dipesan',
                          timeStamp: controller.orderTime.value,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Insets.small.h * .5),
                  _buildDeliveryInfoLayout(context),
                  controller.paymentMethod.isNotEmpty
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
                  controller.note.isNotEmpty
                      ? _BuildNoteCard(note: controller.note.value)
                      : const SizedBox(),
                  SizedBox(height: Insets.small.h),
                  Obx(
                    () => _buildRowItem(
                      context,
                      "Produk",
                      controller.productCount.value,
                      controller.productTotal.value,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Obx(
                    () => _buildRowItem(
                      context,
                      "Pengantaran",
                      controller.deliveryCount.value,
                      controller.deliveryTotal.value,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Obx(
                    () => _buildRowItem(
                      context,
                      "Total Pembayaran",
                      '',
                      controller.totalPrice.value,
                      highLight: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Insets.medium.h),
              _buildConfirmFinishLayout(
                context,
                orderStatus: controller.orderStatus.value,
                rating: controller.orderRating.value,
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildConfirmFinishLayout(BuildContext context,
      {required OrderStatus orderStatus, required Rating rating}) {
    if (orderStatus == OrderStatus.placed) {
      return _BuildConfirmationLayout(
        onPressedNegative: controller.onPressedNegative,
        onPressedPositive: controller.onPressedPositive,
      );
    }
    if (orderStatus == OrderStatus.accepted) {
      return _BuildFinishingLayout(
        onPressedFinish: controller.onPressedFinishOrder,
      );
    }
    if (orderStatus == OrderStatus.rejected) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.small.w,
          vertical: Insets.small.h,
        ),
        child: Center(
          child: Text(
            'Order telah dibatalkan',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 14.sp,
                  color: Palette.negative,
                ),
          ),
        ),
      );
    }
    if (orderStatus == OrderStatus.finished) {
      return _BuildRatedLayout(rating: rating);
    }
  }

  _buildDeliveryInfoLayout(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Insets.small.h * .5,
      ),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Palette.accent,
          ),
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
                controller.deliveryTime.value,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 12.sp,
                    ),
              ),
              Text(
                "${controller.orderingUser!.name} - ${controller.orderingUser!.phone}",
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                    ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHelperButton(Icons.place, controller.onPressedViewMaps),
              SizedBox(width: Insets.small.w * .5),
              _buildHelperButton(
                  Icons.whatsapp, controller.onPressedViewWhatsApp),
              SizedBox(width: Insets.small.w * .5),
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
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 10.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
            ),
            Text(
              controller.paymentMethod.value,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
              horizontal: Insets.small.sp,
              vertical: Insets.small.sp,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Palette.accent,
                size: Insets.medium.sp,
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
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                highLight
                    ? const SizedBox()
                    : Text(
                        sub,
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey,
                            ),
                      ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      );

  _buildDeliveryStateCard({
    required BuildContext context,
    required String title,
    required String timeStamp,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.small.w,
          vertical: Insets.small.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.sp),
          color: Palette.accent,
        ),
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontSize: 9.sp,
                    color: Palette.editable,
                  ),
            ),
            Text(
              timeStamp,
              style: Theme.of(context).textTheme.caption?.copyWith(
                    fontSize: 9.sp,
                    color: Palette.editable,
                  ),
            ),
          ],
        ),
      );
}

class _BuildFinishingLayout extends StatelessWidget {
  const _BuildFinishingLayout({Key? key, required this.onPressedFinish})
      : super(key: key);

  final VoidCallback onPressedFinish;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.primary,
      borderRadius: BorderRadius.circular(12.sp),
      child: InkWell(
        onTap: onPressedFinish,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Insets.small.h,
            horizontal: Insets.medium.w,
          ),
          child: Center(
            child: Text('Finish Order',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 14.sp)),
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
    required this.rating,
  }) : super(key: key);

  final Rating rating;

  @override
  Widget build(BuildContext context) {
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
              color: Palette.primary,
            ),
            updateOnDrag: false,
            ignoreGestures: true,
            unratedColor: Palette.accent,
          ),
          SizedBox(height: Insets.small.h * .5),
          Text(
            'Dinilai ${rating.ratingTimeStamp.format("dd MMMM yyyy")}',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                ),
          ),
          SizedBox(height: Insets.small.h * .5),
          Text(
            " \"${rating.message}\" ",
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
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
