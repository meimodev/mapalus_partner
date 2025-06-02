import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/home/dashboard/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/modules.dart';
import 'package:mapalus_partner/shared/routes.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap.h24,
          Text(
            'Dashboard',
            textAlign: TextAlign.start,
            style: BaseTypography.displayLarge.toBold.toPrimary,
          ),
          Gap.h12,
          Obx(
            () => CardPartnerInfoWidget(
              partner: controller.partner.value,
              onPressed: () async {
                final Partner partner = controller.partner.value as Partner;
                final updatedPartner = await Get.toNamed(
                  Routes.partnerSetting,
                  arguments: partner,
                );
                if (updatedPartner != null) {
                  controller.onUpdatePartner(updatedPartner);
                }
              },
            ),
          ),
          Gap.h12,
          // Row(
          //   children: [
          //     Expanded(
          //       child: CardPartnerStatusWidget(
          //         title: 'Total Product',
          //         value: '123',
          //         onPressed: () {},
          //       ),
          //     ),
          //     Gap.w12,
          //     Expanded(
          //       child: CardPartnerStatusWidget(
          //         title: 'Offline Product',
          //         value: '12',
          //         color: BaseColor.negative,
          //         onPressed: () {},
          //       ),
          //     ),
          //   ],
          // ),
          // Gap.h12,
          // CardPartnerStatusWidget(
          //   title: 'New Orders',
          //   value: '100',
          //   onPressed: () {},
          // ),
          ButtonWidget(
            backgroundColor: BaseColor.black,
            textStyle: BaseTypography.button.bold.toPrimary,
            textColor: BaseColor.negative,
            icon: Icons.warning,
            text: "Super Admin Page",
            onPressed: controller.onPressedSuperAdminPage,
          ),
        ],
      ),
    );
  }
}
