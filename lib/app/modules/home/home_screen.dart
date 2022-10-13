import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/home/home_controller.dart';
import 'package:mapalus_partner/app/widgets/card_order.dart';
import 'package:mapalus_partner/app/widgets/card_product.dart';
import 'package:mapalus_partner/app/widgets/screen_wrapper.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_partner/shared/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  //TODO gonna need to replace this list implementation with infinite scrolling implementation

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: Insets.small.h,
                  ),
                  decoration: BoxDecoration(
                    color: Palette.cardForeground,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.35),
                        offset: const Offset(0, 1),
                        blurRadius: 15,
                        spreadRadius: .5,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(width: 12.w),
                      Material(
                        color: Palette.primary,
                        shape: const CircleBorder(),
                        elevation: 3,
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          onTap: controller.onPressedSettings,
                          child: SizedBox(
                            height: 40.sp,
                            width: 40.sp,
                            child: Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: SvgPicture.asset(
                                'assets/images/mapalus_logo.svg',
                                width: 12.sp,
                                height: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mapalus Partner",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                            ),
                            Text(
                              "Pasar Tondano",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 16.sp,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: 200.milliseconds,
                          child: controller.isLoading.value
                              ? const SizedBox()
                              : _buildInfoSection(
                                  isShowingOrders:
                                      controller.activeNavBottomIndex.value ==
                                          1,
                                  isShowingProducts:
                                      controller.activeNavBottomIndex.value ==
                                          2,
                                  context: context,
                                ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => AnimatedSwitcher(
                      duration: 200.milliseconds,
                      child: controller.isLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Palette.primary,
                              ),
                            )
                          : _buildListSwitcher(
                              isShowingOrders:
                                  controller.activeNavBottomIndex.value == 1,
                              isShowingProducts:
                                  controller.activeNavBottomIndex.value == 2,
                              context: context,
                            ),
                    ),
                  ),
                ),
                Obx(
                  () => _BuildBottomNav(
                    active: controller.activeNavBottomIndex.value,
                    onPressedProducts: controller.onPressedProducts,
                    onPressedOrders: controller.onPressedOrders,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: Insets.medium.w,
            bottom: 120.h,
            child: Obx(
              () => AnimatedSwitcher(
                duration: 400.milliseconds,
                child: controller.activeNavBottomIndex.value == 2
                    ? Material(
                        color: Palette.primary,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        elevation: 3,
                        child: InkWell(
                          onTap: controller.onPressedAddButton,
                          child: SizedBox(
                            height: 50.sp,
                            width: 50.sp,
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  color: Palette.accent,
                                  fontSize: 30.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildListSwitcher({
    required bool isShowingOrders,
    required bool isShowingProducts,
    required BuildContext context,
  }) {
    if (isShowingOrders) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: Insets.small.h),
          Expanded(
            child: Obx(
              () => controller.orders.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.only(
                        bottom: Insets.large.h * 2,
                      ),
                      addAutomaticKeepAlives: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        Order order = controller.orders.elementAt(index);
                        return CardOrder(
                            order: order,
                            onPressed: () => Navigator.pushNamed(
                                  context,
                                  Routes.orderDetail,
                                  arguments: order,
                                ));
                      },
                      itemCount: controller.orders.length,
                    )
                  : Center(
                      child: Text(
                        'No Order Yet',
                        style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Palette.accent,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
            ),
          ),
        ],
      );
    }

    if (isShowingProducts) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Insets.medium.w,
              right: Insets.medium.w,
              bottom: Insets.medium.h,
              top: Insets.medium.h,
            ),
            child: TextField(
              controller: controller.tecProductFilter,
              onChanged: controller.onChangedProductFilter,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.sp,
                color: Palette.accent,
              ),
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                focusColor: Palette.primary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                  borderSide: const BorderSide(
                    color: Palette.primary,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                  borderSide: const BorderSide(
                    color: Palette.accent,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                  borderSide: const BorderSide(
                    color: Palette.primary,
                  ),
                ),
                labelText: "Filter",
                labelStyle: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: Insets.large.h * 2),
              addAutomaticKeepAlives: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Product product = controller.products.elementAt(index);
                return CardProduct(
                    product: product,
                    onPressed: (_) {
                      Navigator.pushNamed(
                        context,
                        Routes.productDetail,
                        arguments: product,
                      );
                    });
              },
              itemCount: controller.products.length,
            ),
          ),
        ],
      );
    }
  }

  _buildInfoSection({
    required BuildContext context,
    required bool isShowingOrders,
    required bool isShowingProducts,
  }) {
    if (isShowingOrders) {
      return Obx(
        () => Text(
          'Total orders ${controller.orders.length}',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Palette.accent,
                fontWeight: FontWeight.w300,
                fontSize: 10.sp,
              ),
        ),
      );
    }

    return Obx(
      () => Text(
        'Total products ${controller.products.length}',
        style: Theme.of(context).textTheme.bodyText1?.copyWith(
              color: Palette.accent,
              fontWeight: FontWeight.w300,
              fontSize: 10.sp,
            ),
      ),
    );
  }
}

class _BuildBottomNav extends StatelessWidget {
  const _BuildBottomNav({
    Key? key,
    required this.onPressedOrders,
    required this.onPressedProducts,
    required this.active,
  }) : super(key: key);

  final VoidCallback onPressedOrders;
  final VoidCallback onPressedProducts;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Palette.cardForeground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.35),
            offset: const Offset(0, 1),
            blurRadius: 15,
            spreadRadius: .5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBottomNavButton(
            context: context,
            title: "Pesanan",
            active: active == 1,
            imageAssetPath: 'assets/vectors/orders.svg',
            onPressed: onPressedOrders,
          ),
          _buildBottomNavButton(
            context: context,
            title: "Produk",
            active: active == 2,
            imageAssetPath: 'assets/vectors/bag.svg',
            onPressed: onPressedProducts,
          ),
        ],
      ),
    );
  }

  _buildBottomNavButton({
    required BuildContext context,
    required String title,
    required String imageAssetPath,
    required bool active,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Material(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: Insets.small.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  imageAssetPath,
                  color: active ? Palette.primary : Colors.grey,
                  width: active ? 21.w : 19.w,
                  height: active ? 21.h : 19.h,
                ),
                SizedBox(height: Insets.small.h * .5),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 12.sp,
                        color: active ? Palette.accent : Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
