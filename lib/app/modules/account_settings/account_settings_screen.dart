import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/account_settings/account_settings_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/app/widgets/screen_wrapper.dart';
import 'package:mapalus_partner/shared/theme.dart';

class AccountSettingsScreen extends GetView<AccountSettingsController> {
  const AccountSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CardNavigation(title: 'Tentang Akun'),
              Obx(
                () => AnimatedSwitcher(
                  duration: 400.milliseconds,
                  child: controller.userName.isNotEmpty
                      ? _buildSignedInBody(context)
                      : _buildAnonymousBody(context),
                ),
              )
            ],
          ),
          _buildDevNote(context),
        ],
      ),
    );
  }

  Widget _buildSignedInBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Insets.medium.h),
            Container(
              width: 120.w,
              height: 120.h,
              padding: EdgeInsets.all(24.sp),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Palette.accent,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/mapalus.svg',
                  color: Palette.primary,
                ),
              ),
            ),
            SizedBox(height: Insets.small.h),
            Text(
              controller.userName.value,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.grey,
                    fontSize: 16.sp,
                  ),
            ),
            Text(
              controller.userPhone.value,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Palette.accent,
                    fontSize: 14.sp,
                  ),
            ),
          ],
        ),
        SizedBox(height: Insets.medium.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.medium.w),
          child: Column(
            children: [
              _buildItemRow(
                assetLocation: 'assets/vectors/edit.svg',
                text: 'Sunting Informasi Akun',
                context: context,
                onPressed: controller.onPressedEditAccountInfo,
              ),
              Badge(
                padding: EdgeInsets.all(3.sp),
                badgeContent: Text(
                  '99',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 10.sp,
                        color: Palette.editable,
                      ),
                ),
                position: BadgePosition.topStart(),
                child: _buildItemRow(
                  assetLocation: 'assets/vectors/bag.svg',
                  text: 'Pesanan Anda',
                  context: context,
                  onPressed: controller.onPressedOrders,
                ),
              ),
              _buildItemRow(
                assetLocation: 'assets/vectors/exit.svg',
                text: 'Keluar',
                context: context,
                onPressed: controller.onPressedSignOut,
              ),
            ],
          ),
        ),
        SizedBox(height: Insets.small.h),
        Container(
          height: 2.h,
          width: 100.w,
          margin: EdgeInsets.symmetric(
            horizontal: Insets.medium.w,
          ),
          color: Palette.accent,
        ),
      ],
    );
  }

  Widget _buildAnonymousBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Insets.medium.h),
        Text(
          'Silahkan masuk untuk melanjutkan',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: Insets.small.h),
        Material(
          clipBehavior: Clip.hardEdge,
          color: Palette.primary,
          borderRadius: BorderRadius.circular(9.sp),
          elevation: 2,
          child: InkWell(
            onTap: controller.onPressedSignIn,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Insets.medium.w,
                vertical: Insets.medium.w * .5,
              ),
              child: Text(
                'Masuk',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: Palette.accent,
                    ),
              ),
            ),
          ),
        ),
        SizedBox(height: Insets.medium.h),
      ],
    );
  }

  Widget _buildDevNote(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.medium.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: Insets.small.h),
            Text(
              'mapalus v.1.2.441',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                  ),
            ),
            Text(
              'www.meimodev.com',
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                  ),
            ),
            Row(
              children: [
                Text(
                  'with ??? 2022 ',
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 12.sp,
                      ),
                ),
                SvgPicture.asset(
                  'assets/images/logo_meimo.svg',
                  width: 15.sp,
                  height: 15.sp,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow({
    required String assetLocation,
    required String text,
    required BuildContext context,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 45.h,
          child: Row(
            children: [
              SizedBox(
                width: 30.sp,
                child: SvgPicture.asset(
                  assetLocation,
                  width: 18.sp,
                  height: 18.sp,
                ),
              ),
              SizedBox(width: Insets.small.w * .5),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 14.sp,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}