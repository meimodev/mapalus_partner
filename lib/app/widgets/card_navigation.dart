import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardNavigation extends StatelessWidget {
  const CardNavigation({
    super.key,
    this.title,
    this.isInverted = false,
    this.isCircular = false,
  });

  final String? title;
  final bool isInverted;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isInverted ? BaseColor.accent : BaseColor.cardBackground1,
      elevation: isInverted ? 0 : 6,
      shadowColor: isInverted ? null : Colors.grey.withValues(alpha: .125),
      shape: isCircular ? const CircleBorder() : null,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: BaseSize.w12),
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
                    isInverted ? BaseColor.editable : BaseColor.primaryText,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              title == null
                  ? const SizedBox()
                  : Center(
                      child: Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isInverted
                              ? BaseColor.editable
                              : BaseColor.primary3,
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
