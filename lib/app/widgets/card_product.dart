import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.onPressed,
    required this.product,
  });

  final Product product;
  final Function(Product product) onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: BaseColor.cardBackground1,
      child: InkWell(
        onTap: () => onPressed(product),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.w12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 80.sp,
                width: 80.sp,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  color: BaseColor.primary3,
                  backgroundBlendMode: BlendMode.clear,
                  shape: BoxShape.circle,
                ),
                child: CustomImage(
                  imageUrl: product.image,
                ),
              ),
              Gap.w12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 3.sp),
                    Row(
                      children: [
                        Text(
                          '${product.price} / ${product.unit}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        product.unit.name.toLowerCase() == 'kilogram'
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(" | "),
                                  Text(
                                    product.weight.toString(),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                        product.customPrice
                            ? Text(
                                " | min ${product.minimumPrice}",
                                style: TextStyle(
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
              Gap.w12,
              _buildStatusIcons(
                isAvailable: product.status == ProductStatus.available,
                isCustomPrice: product.customPrice,
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
                  color: BaseColor.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "!",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: BaseColor.negative,
                  ),
                ),
              ),
        SizedBox(width: 3.w),
        isCustomPrice
            ? Container(
                padding: EdgeInsets.all(9.sp),
                decoration: const BoxDecoration(
                  color: BaseColor.accent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "\$",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: BaseColor.primary3,
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
              color: BaseColor.accent,
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Center(
              child: Text(
                c,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: BaseColor.primary3,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
