import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/home/app_settings/app_settings_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';

class AppSettingsScreen extends GetView<AppSettingsController> {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        child: Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                color: BaseColor.primary3,
              ))
            : Column(
                children: [
                  const CardNavigation(title: 'App Settings'),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap.h12,
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
    ));
  }
}

class _BuildDeliveryFeeCard extends StatelessWidget {
  const _BuildDeliveryFeeCard({required this.controller});

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(BaseSize.radiusMd),
      child: Container(
        padding: EdgeInsets.all(BaseSize.radiusMd),
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
            Gap.h12,
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
          vertical: BaseSize.h6,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: BaseSize.w6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: BaseColor.editable,
          borderRadius: BorderRadius.circular(BaseSize.radiusMd),
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
                color: BaseColor.accent,
                fontFamily: fontFamily,
                fontSize: 12.sp,
              ),
              cursorColor: BaseColor.primary3,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w300,
                  color: BaseColor.primaryText,
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
    this.onPressed,
    required this.text,
  });

  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.primary3,
      elevation: 2,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(BaseSize.radiusMd),
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
  const _BuildAppInfoCard({required this.controller});

  final AppSettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(BaseSize.radiusMd),
      child: Container(
        padding: EdgeInsets.all(BaseSize.radiusMd),
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
