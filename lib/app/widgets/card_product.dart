import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapalus_partner/app/widgets/custom_image.dart';
import 'package:mapalus_partner/data/models/product.dart';
import 'package:mapalus_partner/shared/theme.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    Key? key,
    required this.onPressed,
    required this.product,
  }) : super(key: key);

  final Product product;
  final Function(Product product) onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Palette.cardForeground,
      child: InkWell(
        onTap: () {
          onPressed(product);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.small.w,
            vertical: Insets.small.h * .5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 60.w,
                width: 60.w,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: Palette.primary,
                  backgroundBlendMode: BlendMode.clear,
                  shape: BoxShape.circle,
                ),
                child: CustomImage(
                  imageUrl: product.imageUrl,
                ),
              ),
              SizedBox(width: Insets.small.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 12.sp,
                          ),
                    ),
                    Text(
                      '${product.priceF} / ${product.unit}',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    Text(
                      product.weightF,
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Insets.small.w),
              _buildStatusIcons(
                isAvailable: product.isAvailable,
                isCustomPrice: product.isCustomPrice,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildStatusIcons({
    required bool isAvailable,
    required bool isCustomPrice,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isAvailable
            ? const SizedBox()
            : Container(
                padding: EdgeInsets.all(6.sp),
                decoration: const BoxDecoration(
                  color: Palette.editable,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/vectors/empty.svg',
                  color: Palette.negative,
                  width: 15.w,
                  height: 15.h,
                ),
              ),
        isCustomPrice
            ? Container(
                padding: EdgeInsets.all(6.sp),
                decoration: const BoxDecoration(
                  color: Palette.editable,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/vectors/money.svg',
                  color: Palette.accent,
                  width: 15.w,
                  height: 15.h,
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}