import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardCategory extends StatelessWidget {
  const CardCategory({
    Key? key,
    this.isSelected = false,
    required this.name,
    required this.iconData,
    required this.onPressed,
  }) : super(key: key);

  final bool isSelected;
  final String name;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: isSelected ? Palette.accent : Palette.cardForeground,
          elevation: isSelected ? 0 : 3,
          borderRadius: BorderRadius.all(
            Radius.circular(12.sp),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Icon(
                iconData,
                color: isSelected ? Palette.primary : Palette.accent,
                size: 30.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: Insets.small.h * .5),
        SizedBox(
          width: 60.w,
          child: Text(
            name,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
                  color: isSelected ? Palette.textPrimary : Colors.grey,
                ),
          ),
        ),
      ],
    );
  }
}