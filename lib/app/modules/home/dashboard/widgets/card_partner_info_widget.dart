import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/custom_image.dart';

class CardPartnerInfoWidget extends StatelessWidget {
  const CardPartnerInfoWidget({
    super.key,
    required this.onPressed,
    this.partner,
  });

  final VoidCallback onPressed;
  final Partner? partner;

  @override
  Widget build(BuildContext context) {
    if (partner == null) {
      return const SizedBox();
    }
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
              Container(
                width: BaseSize.w48,
                height: BaseSize.w48,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    BaseSize.radiusMd,
                  ),
                ),
                child: CustomImage(
                  imageUrl: partner!.image,
                ),
              ),
              Gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      partner!.name,
                      style: BaseTypography.bodyMedium.toBold.toPrimary,
                    ),
                    Text(
                      partner!.location!.place,
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
