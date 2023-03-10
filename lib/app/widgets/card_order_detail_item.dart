import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardOrderDetailItem extends StatefulWidget {
  const CardOrderDetailItem({
    Key? key,
    required this.index,
    required this.productName,
    required this.productPrice,
    required this.productWeight,
    required this.onChangeCheck,
  }) : super(key: key);

  final String index;
  final String productName;
  final String productPrice;
  final String productWeight;

  final Function(bool value) onChangeCheck;

  @override
  State<CardOrderDetailItem> createState() => _CardOrderDetailItemState();
}

class _CardOrderDetailItemState extends State<CardOrderDetailItem> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Palette.accent,
      child: InkWell(
        onTap: (){
          setState(() {
            checked = !checked;
          });
          widget.onChangeCheck(checked);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: Insets.small,
          ),
          margin: const EdgeInsets.symmetric(horizontal: Insets.small),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Palette.cardForeground,
              ),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 30.sp,
                child: Center(
                  child: Text(
                    widget.index,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Palette.cardForeground,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.productName,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: Palette.cardForeground,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        _buildWeightAndPriceCard(context, widget.productPrice),
                        SizedBox(width: 6.w),
                        _buildWeightAndPriceCard(context, widget.productWeight),
                      ],
                    ),
                  ],
                ),
              ),
              Checkbox(
                value: checked,
                activeColor: Palette.primary,
                visualDensity: VisualDensity.compact,
                onChanged: (value) {
                  setState(() {
                    checked = !checked;
                  });
                  widget.onChangeCheck(checked);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildWeightAndPriceCard(
    BuildContext context,
    String text,
  ) =>
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: 6.w,
          vertical: 3.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.sp),
          color: Palette.cardForeground,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Palette.textPrimary,
              ),
        ),
      );
}
