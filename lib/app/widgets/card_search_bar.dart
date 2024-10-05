import 'package:flutter/material.dart' hide Badge;
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardSearchBar extends StatelessWidget {
  const CardSearchBar({
    super.key,
    required this.onSubmitted,
    required this.onLogoPressed,
    required this.notificationBadgeCount,
  });

  final Function(String value) onSubmitted;
  final VoidCallback onLogoPressed;
  final int notificationBadgeCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BaseColor.editable,
        borderRadius: BorderRadius.circular(BaseSize.radiusLg),
      ),
      padding: EdgeInsets.symmetric(
        vertical: BaseSize.h12,
        horizontal: BaseSize.h12,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: BaseSize.w12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Gap.w12,
                  SvgPicture.asset(
                    'assets/vectors/search.svg',
                    height: 15.sp,
                    width: 15.sp,
                    colorFilter: const ColorFilter.mode(
                      Colors.grey,
                      BlendMode.srcIn,
                    ),
                  ),
                  Gap.w12,
                  Flexible(
                    child: TextField(
                      onSubmitted: onSubmitted,
                      maxLines: 1,
                      autocorrect: false,
                      style: TextStyle(
                        color: BaseColor.accent,
                        fontFamily: fontFamily,
                        fontSize: 12.sp,
                      ),
                      cursorColor: BaseColor.primary3,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 12.sp,
                        ),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Cari Produk ...',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Gap.w12,
            // Badge(
            //   showBadge: notificationBadgeCount > 0,
            //   badgeContent: Center(
            //     child: Text(
            //       notificationBadgeCount.toString(),
            //       style: TextStyle(
            //         fontSize: 10.sp,
            //         color: BaseColor.editable,
            //       ),
            //     ),
            //   ),
            //   child: Material(
            //     shape: const CircleBorder(),
            //     color: BaseColor.accent,
            //     child: InkWell(
            //       onTap: onLogoPressed,
            //       child: Container(
            //         padding: EdgeInsets.all(6.sp),
            //         height: 33.sp,
            //         width: 33.sp,
            //         child: SvgPicture.asset(
            //           'assets/images/mapalus_logo.svg',
            //           height: 12.sp,
            //           width: 12.sp,
            //           colorFilter: const ColorFilter.mode(
            //             BaseColor.primaryText,
            //             BlendMode.srcIn,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
