import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/app/modules/order_detail/widgets/main_action_layout_widget.dart';

import 'widgets.dart';

class OrderDataCardWidget extends StatelessWidget {
  const OrderDataCardWidget({
    super.key,
    required this.orderApp,
    required this.onPressedAccept,
    required this.onPressedReject,
    required this.onPressedDeliver,
    required this.onPressedViewPhone,
    required this.onPressedViewMap,
    required this.onPressedViewWhatsApp,
    required this.onPressedSeeTransferStatus,
  });

  final OrderApp orderApp;

  final VoidCallback onPressedViewPhone;
  final VoidCallback onPressedViewMap;
  final VoidCallback onPressedViewWhatsApp;

  final VoidCallback onPressedAccept;
  final VoidCallback onPressedReject;
  final VoidCallback onPressedDeliver;
  final VoidCallback onPressedSeeTransferStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BaseSize.w12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w12,
        vertical: BaseSize.h12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(BaseSize.radiusMd),
        color: BaseColor.cardBackground1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              DeliveryInfoLayoutWidget(
                orderApp: orderApp,
                onPressedViewMap: onPressedViewMap,
                onPressedViewWhatsApp: onPressedViewWhatsApp,
                onPressedViewPhone: onPressedViewPhone,
              ),
              PaymentInfoLayoutWidget(
                paymentMethod: orderApp.payment.method,
                onPressedSeeTransferStatus: onPressedSeeTransferStatus,
              ),
              Gap.h12,
              orderApp.note.isNotEmpty
                  ? NoteCardWidget(note: orderApp.note)
                  : const SizedBox(),
              Gap.h12,
              _buildRowItem(
                context,
                "Produk",
                "${orderApp.products.length} Produk",
                (orderApp.payment.amount - (orderApp.delivery?.price ?? 0))
                    .formatNumberToCurrency(),
              ),
              orderApp.delivery == null
                  ? const SizedBox()
                  : _buildRowItem(
                      context,
                      "Pengantaran",
                      orderApp.delivery!.weight.toKilogram(),
                      orderApp.delivery!.price.formatNumberToCurrency(),
                    ),
              _buildRowItem(
                context,
                "Total Pembayaran",
                '',
                orderApp.payment.amount.formatNumberToCurrency(),
                highLight: true,
              ),
            ],
          ),
          Gap.h24,
          MainActionLayoutWidget(
            orderApp: orderApp,
            onPressedAccept: onPressedAccept,
            onPressedReject: onPressedReject,
            onPressedDeliver: onPressedDeliver,
          ),
        ],
      ),
    );
  }

  Widget _buildRowItem(
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
                  style: BaseTypography.titleLarge.w500,
                ),
                highLight
                    ? const SizedBox()
                    : Text(
                        sub,
                        style: BaseTypography.titleLarge.toSecondary,
                      ),
              ],
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              textAlign: TextAlign.end,
              style: BaseTypography.titleLarge.toSecondary,
            ),
          ),
        ],
      );
}
