import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/app/widgets/text_input_quantity.dart';

import 'button_alter_quantity.dart';

class DialogItemDetail extends StatefulWidget {
  const DialogItemDetail({
    super.key,
    required this.product,
    required this.onPressedAddToCart,
  });

  final Product product;
  final Function(ProductOrder) onPressedAddToCart;

  @override
  State<DialogItemDetail> createState() => _DialogItemDetailState();
}

class _DialogItemDetailState extends State<DialogItemDetail> {
  TextEditingController tecGram = TextEditingController();
  TextEditingController tecPrice = TextEditingController();

  late int initAmount;

  late int additionAmountUnit;

  late int additionAmountPrice;

  @override
  void initState() {
    initAmount = 1;
    additionAmountUnit = 1;
    additionAmountPrice = widget.product.price.toInt();

    tecGram.text = initAmount.toString();
    tecPrice.text = widget.product.price.toString();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tecGram.dispose();
    tecPrice.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        alignment: Alignment.center,
        height: 570.h,
        width: 300.w,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(9.sp)),
                  color: BaseColor.cardBackground1,
                ),
                height: 470.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 135.h),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: BaseSize.w12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  widget.product.name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.sp,
                                  ),
                                ),
                                Gap.h12,
                                Text(
                                  '${widget.product.price} / ${widget.product.unit}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Gap.h12,
                                Text(
                                  widget.product.description,
                                  maxLines: 4,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: BaseSize.h12,
                              ),
                              child: widget.product.status ==
                                      ProductStatus.available
                                  ? _buildAvailableWidgets(context)
                                  : _buildUnavailableWidgets(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: widget.product.status == ProductStatus.available
                          ? BaseColor.primary3
                          : BaseColor.editable,
                      borderRadius: BorderRadius.all(Radius.circular(9.sp)),
                      child: InkWell(
                        onTap: () {
                          if (widget.product.status ==
                              ProductStatus.available) {
                            widget.onPressedAddToCart(
                              ProductOrder(
                                product: widget.product,
                                quantity: double.parse(tecGram.text),
                                totalPrice: double.parse(tecPrice.text),
                              ),
                            );
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: BaseSize.h12),
                          child: Center(
                            child: Text(
                              widget.product.status == ProductStatus.available
                                  ? "Masukkan Keranjang"
                                  : "Kembali",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: widget.product.status ==
                                        ProductStatus.available
                                    ? BaseColor.primaryText
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 210.h,
                width: 210.w,
                foregroundDecoration:
                    widget.product.status == ProductStatus.available
                        ? BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withValues(alpha: .5),
                          )
                        : null,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BaseColor.accent,
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: .5,
                      blurRadius: 15,
                      color: Colors.grey.withValues(alpha: .5),
                      offset: const Offset(3, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/mapalus.svg',
                    colorFilter: const ColorFilter.mode(
                      BaseColor.primary3,
                      BlendMode.srcIn,
                    ),
                    width: 60.w,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnavailableWidgets(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Produk sedang tidak tersedia",
          style: TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 15.h),
        SvgPicture.asset(
          "assets/vectors/empty.svg",
          width: 60.sp,
          height: 60.sp,
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.srcIn,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableWidgets(BuildContext context) {
    onChangeValue(bool isFromPrice) {
      double gram = double.parse(tecGram.text);
      double price = double.parse(tecPrice.text);

      if (isFromPrice) {
        double g = price / widget.product.price;
        String s = g.toStringAsFixed(2);
        if (s.contains(".00")) {
          s = s.substring(0, s.length - 3);
        }
        tecGram.text = s;
      } else {
        tecPrice.text = (gram * widget.product.price).floor().toString();
      }
    }

    adding(int amount, TextEditingController controller, bool isFromPrice) {
      late int cur;
      try {
        cur = int.parse(controller.text);
      } catch (_) {
        cur = 0;
      }
      if (amount < 0 && cur + amount <= 0) {
        amount = 0;
      }
      controller.text = (cur + amount).toString();
      onChangeValue(isFromPrice);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildQuantityRow(
          context: context,
          valueLabel: 'gram',
          isCustomPrice: true,
          icon: SvgPicture.asset(
            'assets/vectors/gram.svg',
            width: 15.sp,
            height: 15.sp,
            colorFilter: const ColorFilter.mode(
              BaseColor.accent,
              BlendMode.srcIn,
            ),
          ),
          textEditingController: tecGram,
          onValueChanged: (value) {
            onChangeValue(false);
          },
          onAdd: () {
            adding(additionAmountUnit, tecGram, false);
          },
          onSub: () {
            adding(-additionAmountUnit, tecGram, false);
          },
        ),
        SizedBox(height: 9.h),
        _buildQuantityRow(
          context: context,
          valueLabel: 'rupiah',
          isCustomPrice: widget.product.customPrice,
          icon: SvgPicture.asset(
            'assets/vectors/money.svg',
            width: 15.sp,
            height: 15.sp,
            colorFilter: const ColorFilter.mode(
              BaseColor.accent,
              BlendMode.srcIn,
            ),
          ),
          textEditingController: tecPrice,
          onValueChanged: (value) {
            onChangeValue(true);
          },
          onAdd: () {
            adding(additionAmountPrice, tecPrice, true);
          },
          onSub: () {
            adding(-additionAmountPrice, tecPrice, true);
          },
        )
      ],
    );
  }

  Widget _buildQuantityRow({
    required BuildContext context,
    required Widget icon,
    required String valueLabel,
    required Function(String value) onValueChanged,
    required VoidCallback onAdd,
    required VoidCallback onSub,
    required TextEditingController textEditingController,
    bool isCustomPrice = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextInputQuantity(
          icon: icon,
          onTextChanged: onValueChanged,
          textEditingController: textEditingController,
          isReadOnly: !isCustomPrice,
          trailingWidget: Row(
            children: [
              SizedBox(width: 3.w),
              Text(
                valueLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              Gap.w12,
            ],
          ),
        ),
        // Text(
        //   valueLabel,
        //   style: Theme.of(context).textTheme.bodyText1?.copyWith(
        //         fontWeight: FontWeight.w300,
        //       ),
        // ),
        SizedBox(width: 3.w),

        ButtonAlterQuantity(
          label: "-",
          onPressed: onSub,
          isEnabled: isCustomPrice,
        ),
        SizedBox(width: 3.w),
        ButtonAlterQuantity(
          label: "+",
          onPressed: onAdd,
          isEnabled: isCustomPrice,
        ),
      ],
    );
  }
}
