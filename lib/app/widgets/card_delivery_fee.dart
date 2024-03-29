import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardDeliveryFee extends StatelessWidget {
  const CardDeliveryFee({
    Key? key,
    required this.deliveryTime,
    required this.price,
    this.isActive = false,
    this.isTomorrow = false,
    required this.onPressed,
  }) : super(key: key);

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
          color: isActive ? Palette.primary : Colors.transparent,
        ),
      ),
      color: Colors.grey.shade200,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: Insets.small.h * .5,
            horizontal: Insets.medium.w * .5,
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
                          Palette.accent,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: Insets.small.w * .85),
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
                            color:
                                isTomorrow ? Colors.grey : Palette.textPrimary,
                          ),
                        ),
                        SizedBox(width: Insets.small.w),
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
