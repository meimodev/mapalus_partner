import 'package:flutter/material.dart';
import 'package:mapalus_partner/app/modules/home/app_settings/app_settings_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class AppSettingsScreen extends GetView<AppSettingsController> {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Obx(
        ()=> AnimatedSwitcher(
          duration:const Duration(milliseconds: 400),
          child: controller.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: Palette.primary,))
              : Column(
            children: [
              const CardNavigation(title: 'App Settings'),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: Insets.medium.h),
                      _BuildDeliveryFeeCard(controller: controller),
                      _BuildAppInfoCard(controller: controller),
                      //account with verified phone
                      //
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class _BuildDeliveryFeeCard extends StatelessWidget {
  const _BuildDeliveryFeeCard({Key? key, required this.controller})
      : super(key: key);

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Insets.medium.sp),
      child: Container(
        padding: EdgeInsets.all(Insets.medium.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.sp),
          color: Colors.white,
          border: Border.all(),
        ),
        child: Column(
          children: [
            _buildListItem(
              context: context,
              title: "Distance Price",
              controller: controller.tecDistancePrice,
            ),
            _buildListItem(
              context: context,
              title: "Distance Unit",
              controller: controller.tecDistanceUnit,
            ),
            _buildListItem(
              context: context,
              title: "Weight Price",
              controller: controller.tecWeightPrice,
            ),
            _buildListItem(
              context: context,
              title: "Weight Unit",
              controller: controller.tecWeightUnit,
            ),
            SizedBox(
              height: Insets.medium.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                _BuildButton(
                  text: "Save Delivery Settings ",
                  onPressed: controller.onPressedSaveSettings,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildListItem({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    Function(String)? onTextChanged,
    bool numbersOnly = true,
    int maxLines = 1,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(
          vertical: Insets.small.h * .5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Insets.small.w,
          vertical: 2.w,
        ),
        decoration: BoxDecoration(
          color: Palette.editable,
          borderRadius: BorderRadius.circular(9.sp),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: controller,
              maxLines: maxLines,
              autocorrect: false,
              onChanged: onTextChanged,
              keyboardType:
                  numbersOnly ? TextInputType.number : TextInputType.text,
              textInputAction: TextInputAction.next,
              style: TextStyle(
                color: Palette.accent,
                fontFamily: fontFamily,
                fontSize: 12.sp,
              ),
              cursorColor: Palette.primary,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: Palette.textPrimary,
                ),
                isDense: true,
                border: InputBorder.none,
                labelText: title,
              ),
            ),
          ],
        ),
      );
}

class _BuildButton extends StatelessWidget {
  const _BuildButton({
    Key? key,
    this.onPressed,
    required this.text,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.primary,
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(Insets.small.sp),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildAppInfoCard extends StatelessWidget {
  const _BuildAppInfoCard({Key? key, required this.controller})
      : super(key: key);

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Insets.medium.sp),
      child: Container(
        padding: EdgeInsets.all(Insets.medium.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.sp),
          color: Colors.white,
          border: Border.all(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "VALID UNTIL = ${controller.lastQuery}",
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
            Text(
              "Verified Account = ${controller.verifiedAccountCount}",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
            Text(
              "Account with order = ${controller.hadOrderCount}",
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
