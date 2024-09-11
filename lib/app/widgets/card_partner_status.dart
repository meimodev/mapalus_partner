import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardPartnerStatus extends StatelessWidget {
  const CardPartnerStatus({
    super.key,
    required this.title,
    required this.value,
    this.color,
    this.onPressed,
  });

  final String title;
  final String value;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.white,
      clipBehavior: Clip.hardEdge,
      borderOnForeground: false,
      shape: ContinuousRectangleBorder(
        side: BorderSide(
          color: color ?? BaseColor.white,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(
          BaseSize.radiusMd,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Column(
            children: [
              Text(
                title,
                style: BaseTypography.bodyMedium,
              ),
              Text(
                value,
                style: BaseTypography.headlineMedium.toBold.copyWith(
                  color: color ?? BaseColor.primaryText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
