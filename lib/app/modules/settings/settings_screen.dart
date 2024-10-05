import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/settings/settings_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/shared/routes.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CardNavigation(title: 'Pengaturan'),
                Expanded(child: _buildSignedInBody(context)),
              ],
            ),
          ),
          _buildDevNote(context),
        ],
      ),
    );
  }

  Widget _buildSignedInBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Gap.h12,
              Container(
                width: 120.sp,
                height: 120.sp,
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
              Gap.h12,
              Text(
                'Pasar Tondano',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
              Text(
                '0895 2569 9078',
                style: TextStyle(
                  color: BaseColor.accent,
                  fontSize: 14.sp,
                ),
              ),
              Gap.h12,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: BaseSize.w12),
                child: Material(
                  color: BaseColor.editable,
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(9.sp),
                  ),
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.appSettings),
                    child: Padding(
                      padding: EdgeInsets.all(BaseSize.radiusMd),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: BaseColor.negative,
                              size: 20.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              "App Settings",
                              style: TextStyle(
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
            Gap.h12,
            Obx(
              () => Text(
                controller.currentVersion.value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15.sp,
                ),
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
                  'with ♥ ${Jiffy.now().year} ',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
