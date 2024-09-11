import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/widgets/widgets.dart';

class DashboardScreen extends StatelessWidget {
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
          CardPartnerInfo(
            onPressed: () {},
            name: 'Strata',
            location: 'Jakarta Selatan, Tebet',
          ),
          Gap.h12,
          CardPartnerStatus(
            title: 'New Orders',
            value: '100',
            onPressed: () {},
          ),
          Gap.h16,
          Row(
            children: [
              Expanded(
                child: CardPartnerStatus(
                  title: 'Total Product',
                  value: '123',
                  onPressed: () {},
                ),
              ),
              Gap.w12,
              Expanded(
                child: CardPartnerStatus(
                  title: 'Offline Product',
                  value: '12',
                  color: BaseColor.negative,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
