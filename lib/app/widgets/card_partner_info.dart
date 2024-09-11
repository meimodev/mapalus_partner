import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardPartnerInfo extends StatelessWidget {
  const CardPartnerInfo({
    super.key,
    required this.onPressed,
    required this.name,
    required this.location,
  });

  final VoidCallback onPressed;
  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.primaryText,
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(
        BaseSize.radiusMd,
      ),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.star_outline_outlined,
                color: BaseColor.primary3,
              ),
              Gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      name,
                      style: BaseTypography.bodyMedium.toBold.toPrimary,
                    ),
                    Text(
                      location,
                      style: BaseTypography.bodySmall.toCardBackground1,
                    ),
                  ],
                ),
              ),
              Gap.w12,
              const Icon(
                Icons.edit_rounded,
                color: BaseColor.primary3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
