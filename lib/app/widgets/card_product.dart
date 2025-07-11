import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    super.key,
    required this.onPressed,
    required this.product,
  });

  final Product product;
  final void Function(Product product) onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(BaseSize.radiusMd),
      color: BaseColor.white,
      child: InkWell(
        onTap: () => onPressed(product),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: BaseSize.w72,
                width: BaseSize.w72,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: BaseColor.accent,
                  borderRadius: BorderRadius.circular(BaseSize.radiusMd),
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
                    ),
                    Row(
                      children: [
                        Text(
                          '${product.price.formatNumberToCurrency()} / ${product.unit?.name}',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        product.unit?.name.toLowerCase() == 'kilogram'
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(" | "),
                                  Text(
                                    product.weight.toKilogram(accurate: true),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                        product.customPrice
                            ? Text(
                                " | min ${product.minimumPrice.formatNumberToCurrency()}",
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              )
                            : const SizedBox(),
                      ],
                    ),
                    Gap.h4,
                    ChipCategory(category: product.category),
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

  Widget _buildStatusIcons({
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
        Gap.w3,
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
}
