import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardNavigation extends StatelessWidget {
  const CardNavigation({
    Key? key,
    this.title,
    this.isInverted = false,
    this.isCircular = false,
  }) : super(key: key);

  final String? title;
  final bool isInverted;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isInverted ? Palette.accent : Palette.cardForeground,
      elevation: isInverted ? 0 : 6,
      shadowColor: isInverted ? null : Colors.grey.withOpacity(.125),
      shape: isCircular ? const CircleBorder() : null,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.medium.w),
          height: 60.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/vectors/back.svg',
                  height: 24.sp,
                  width: 24.sp,
                  colorFilter: ColorFilter.mode(
                    isInverted ? Palette.editable : Palette.textPrimary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title == null
                  ? const SizedBox()
                  : Center(
                      child: Text(
                        title!,
                        style: TextStyle(
                          color: isInverted
                              ? Palette.editable
                              : Palette.textPrimary,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
