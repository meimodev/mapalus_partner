import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        onTap: () => onPressed(product),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.small.w,
            vertical: Insets.small.sp,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80.sp,
                width: 80.sp,
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
                    SizedBox(height: 3.sp),
                    Row(
                      children: [
                        Text(
                          '${product.priceF} / ${product.unit}',
                          style:
                              Theme.of(context).textTheme.bodyText1?.copyWith(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w300,
                                  ),
                        ),
                        product.unit.trim().toLowerCase() == 'kilogram'
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(" | "),
                                  Text(
                                    product.weightF,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                  ),
                                ],
                              ),
                        product.isCustomPrice
                            ? Text(
                                " | min ${product.minimumPriceF}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    SizedBox(height: 3.sp),
                    _buildCategoriesChip(),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        isAvailable
            ? const SizedBox()
            : Container(
                padding: EdgeInsets.all(9.sp),
                decoration: const BoxDecoration(
                  color: Palette.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "!",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Palette.negative,
                  ),
                ),
              ),
        SizedBox(width: 3.w),
        isCustomPrice
            ? Container(
                padding: EdgeInsets.all(9.sp),
                decoration: const BoxDecoration(
                  color: Palette.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "\$",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: Palette.primary,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  _buildCategoriesChip() {
    var categoryList = [];
    if (product.category.contains(',')) {
      var temp = product.category.split(',');
      for (String t in temp) {
        categoryList.add(t);
      }
    } else {
      categoryList.add(product.category);
    }

    return Row(
      children: [
        for (var c in categoryList)
          Container(
            decoration: BoxDecoration(
              color: Palette.accent,
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Insets.small.sp * .75,
                  vertical: Insets.small.h * .25,
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Palette.primary,
                    fontSize: 8.sp,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
