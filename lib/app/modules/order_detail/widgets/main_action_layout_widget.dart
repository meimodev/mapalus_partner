import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';

class MainActionLayoutWidget extends StatelessWidget {
  const MainActionLayoutWidget({
    super.key,
    required this.orderApp,
    required this.onPressedAccept,
    required this.onPressedReject,
    required this.onPressedDeliver,
  });

  final OrderApp orderApp;

  final VoidCallback onPressedAccept;
  final VoidCallback onPressedReject;
  final VoidCallback onPressedDeliver;

  @override
  Widget build(BuildContext context) {
    switch (orderApp.status) {
      case OrderStatus.placed:
        return _BuildConfirmationLayout(
          onPressedNegative: onPressedReject,
          onPressedPositive: onPressedAccept,
        );
      case OrderStatus.accepted:
        return _BuildDeliverLayout(
          onPressedDeliver: onPressedDeliver,
        );
      case OrderStatus.rejected:
        return Column(
          children: [
            Text(
              'Order telah ditolak',
              style: BaseTypography.titleLarge.toNegative,
            ),
          ],
        );
      case OrderStatus.delivered:
        return Column(
          children: [
            Text(
              'Order telah diantar',
              style: BaseTypography.titleLarge.toPositive,
            ),
          ],
        );
      case OrderStatus.finished:
        return _BuildRatedLayout(order: orderApp);
      case OrderStatus.canceled:
        return Column(
          children: [
            Text(
              'Order telah dibatalkan',
              style: BaseTypography.titleLarge.toNegative,
            ),
          ],
        );
    }
  }
}

class _BuildDeliverLayout extends StatelessWidget {
  const _BuildDeliverLayout({required this.onPressedDeliver});

  final VoidCallback onPressedDeliver;

  void onPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tekan dan Tahan untuk melanjutkan...",
          style: BaseTypography.bodySmall.toPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      text: "Antar Pesanan",
      icon: Icons.local_shipping,
      onPressed: () => onPressed(context),
      size: BaseSize.customRadius(18),
      onLongPressed: onPressedDeliver,
    );
  }
}

class _BuildConfirmationLayout extends StatelessWidget {
  const _BuildConfirmationLayout({
    required this.onPressedPositive,
    required this.onPressedNegative,
  });

  final VoidCallback onPressedPositive;
  final VoidCallback onPressedNegative;

  void onPressed(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tekan dan Tahan untuk melanjutkan...",
          style: BaseTypography.bodySmall.toPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ButtonWidget(
          icon: Icons.clear,
          backgroundColor: BaseColor.negative,
          textColor: BaseColor.white,
          size: BaseSize.customRadius(16),
          onPressed: () => onPressed(context),
          onLongPressed: onPressedNegative,
        ),
        ButtonWidget(
          icon: Icons.check,
          backgroundColor: BaseColor.positive,
          textColor: BaseColor.white,
          size: BaseSize.customRadius(16),
          onPressed: () => onPressed(context),
          onLongPressed: onPressedPositive,
        ),
      ],
    );
  }
}

class _BuildRatedLayout extends StatelessWidget {
  const _BuildRatedLayout({
    required this.order,
  });

  final OrderApp order;

  @override
  Widget build(BuildContext context) {
    final rating = order.rating;
    if (rating == null) {
      return Text(
        "Order telah selesai, belum ada penilaian",
        textAlign: TextAlign.center,
        style: BaseTypography.bodySmall,
      );
    }
    return Container(
      margin: EdgeInsets.only(
        bottom: BaseSize.h12,
        top: BaseSize.h6,
      ),
      child: Column(
        children: [
          RatingBar.builder(
            initialRating: rating.rate.toDouble(),
            minRating: rating.rate.toDouble(),
            maxRating: rating.rate.toDouble(),
            direction: Axis.horizontal,
            itemCount: 5,
            glowColor: BaseColor.editable.withOpacity(.25),
            itemSize: BaseSize.customRadius(27),
            itemPadding: EdgeInsets.symmetric(horizontal: BaseSize.w6),
            onRatingUpdate: (_) {},
            itemBuilder: (_, int index) => SvgPicture.asset(
              'assets/vectors/star.svg',
              colorFilter: const ColorFilter.mode(
                BaseColor.primary3,
                BlendMode.srcIn,
              ),
            ),
            updateOnDrag: false,
            ignoreGestures: true,
            unratedColor: BaseColor.accent,
          ),
          Gap.h12,
          Text(
            'Dinilai ${order.lastUpdate.ddMmmmYyyy}',
            style: BaseTypography.titleLarge.w300,
          ),
          Gap.h6,
          Text(
            rating.message,
            style: BaseTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}
