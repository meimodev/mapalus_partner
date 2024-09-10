import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/account_settings/account_settings_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';

class AccountSettingsScreen extends GetView<AccountSettingsController> {
  const AccountSettingsScreen({super.key});

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
            Gap.h12,
            Container(
              width: 120.w,
              height: 120.h,
              padding: EdgeInsets.all(24.sp),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: BaseColor.accent,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/mapalus.svg',
                  colorFilter: const ColorFilter.mode(
                    BaseColor.primary3,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Gap.h6,
            Text(
              controller.userName.value,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16.sp,
              ),
            ),
            Text(
              controller.userPhone.value,
              style: TextStyle(
                color: BaseColor.accent,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
        Gap.h12,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: BaseSize.w12),
          child: Column(
            children: [
              _buildItemRow(
                assetLocation: 'assets/vectors/edit.svg',
                text: 'Sunting Informasi Akun',
                context: context,
                onPressed: controller.onPressedEditAccountInfo,
              ),
              Badge(
                badgeContent: Text(
                  '99',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: BaseColor.editable,
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
        Gap.w12,
        Container(
          height: 2.h,
          width: 100.w,
          margin: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
          ),
          color: BaseColor.accent,
        ),
      ],
    );
  }

  Widget _buildAnonymousBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Gap.h12,
        Text(
          'Silahkan masuk untuk melanjutkan',
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
        Gap.h12,
        Material(
          clipBehavior: Clip.hardEdge,
          color: BaseColor.primary3,
          borderRadius: BorderRadius.circular(9.sp),
          elevation: 2,
          child: InkWell(
            onTap: controller.onPressedSignIn,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: BaseSize.w12,
                vertical: BaseSize.h6,
              ),
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: BaseColor.accent,
                ),
              ),
            ),
          ),
        ),
        Gap.h12,
      ],
    );
  }

  Widget _buildDevNote(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: BaseSize.w12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gap.h6,
            Text(
              'mapalus ${controller.currentVersion.value}',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
              ),
            ),
            Text(
              'www.meimodev.com',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
              ),
            ),
            Row(
              children: [
                Text(
                  'with ♥ ${DateTime.now().year} ',
                  style: TextStyle(
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
              Gap.w12,
              Text(
                text,
                style: TextStyle(
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
