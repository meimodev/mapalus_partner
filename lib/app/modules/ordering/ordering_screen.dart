import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/ordering/ordering_controller.dart';
import 'package:mapalus_partner/app/widgets/screen_wrapper.dart';
import 'package:mapalus_partner/shared/theme.dart';

class OrderingScreen extends GetView<OrderingController> {
  const OrderingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: WillPopScope(
        onWillPop: () {
          controller.onPressedBack();
          return Future.value(false);
        },
        child: Stack(
          children: [
            // Center(
            //   child: Obx(() => _buildLoading(context)),
            // ),
            Center(
              child: Obx(
                () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.isLoading.value
                      ? _buildLoading(context)
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: Insets.small.w * 2.4),
                              child: SvgPicture.asset(
                                'assets/vectors/order-received.svg',
                                height: 120.sp,
                                width: 120.sp,
                              ),
                            ),
                            SizedBox(height: Insets.medium.h),
                            Text(
                              'Pesanan Diterima',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                  ),
                            ),
                            SizedBox(height: Insets.small.h),
                            Text(
                              'Anda akan segera dihubungi \nsaat waktu pengantaran nanti',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                            ),
                            SizedBox(height: Insets.medium.h * 1.5),
                          ],
                        ),
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: Insets.medium.h,
                child: Obx(
                  () => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.isLoading.value
                        ? const SizedBox()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Insets.medium.w),
                            child: Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(9.sp),
                              color: Palette.primary,
                              clipBehavior: Clip.hardEdge,
                              child: InkWell(
                                onTap: controller.onPressedReturn,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Insets.medium,
                                    vertical: Insets.small.w,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Kembali',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          ?.copyWith(
                                            fontSize: 14.sp,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  _buildLoading(BuildContext context) {
    return Visibility(
      visible: controller.isLoading.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sedang Melakukan Pemesanan',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontSize: 14.sp,
                ),
          ),
          SizedBox(height: Insets.medium.h),
          const CircularProgressIndicator(color: Palette.primary),
        ],
      ),
    );
  }
}