import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardDeliveryFee extends StatelessWidget {
  const CardDeliveryFee({
    super.key,
    required this.deliveryTime,
    required this.price,
    this.isActive = false,
    this.isTomorrow = false,
    required this.onPressed,
  });

  final String deliveryTime;
  final String price;
  final bool isActive;
  final bool isTomorrow;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(9.sp),
        side: BorderSide(
          width: 1.5,
          color: isActive ? BaseColor.primary3 : Colors.transparent,
        ),
      ),
      color: Colors.grey.shade200,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: BaseSize.h12,
            horizontal: BaseSize.w12,
          ),
          child: Row(
            children: [
              ...isActive
                  ? [
                      SvgPicture.asset(
                        'assets/vectors/check.svg',
                        width: 24.sp,
                        height: 24.sp,
                        colorFilter: const ColorFilter.mode(
                          BaseColor.accent,
                          BlendMode.srcIn,
                        ),
                      ),
                      Gap.w4,
                    ]
                  : [const SizedBox()],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          deliveryTime,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: isTomorrow
                                ? Colors.grey
                                : BaseColor.primaryText,
                          ),
                        ),
                        Gap.h12,
                        isTomorrow
                            ? Text(
                                'BESOK, 16 Feb',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12.sp,
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
