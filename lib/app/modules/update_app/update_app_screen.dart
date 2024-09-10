import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class UpdateAppScreen extends StatelessWidget {
  const UpdateAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: BaseColor.cardBackground1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/mapalus.svg',
                width: 60.sp,
                height: 60.sp,
                colorFilter: const ColorFilter.mode(
                  BaseColor.accent,
                  BlendMode.srcIn,
                ),
              ),
              Gap.h12,
              Text(
                'Partner App',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                  color: BaseColor.accent,
                ),
              ),
              Gap.h24,
              Text(
                'Please update the app\nto ensure the latest feature & app stability',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Gap.h12,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(
                    context,
                    title: 'App Store',
                    icon: Icons.apple,
                    onPressed: () {
                      String url =
                          "https://apps.apple.com/sg/app/bungkus/id1460126004";
                      launchUrlString(
                        url,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                  _buildButton(
                    context,
                    title: 'Play Store',
                    icon: Icons.android,
                    onPressed: () {
                      String url =
                          "https://play.google.com/store/apps/details?id=com.meimodev.mapalus_partner";
                      launchUrlString(
                        url,
                        mode: LaunchMode.externalNonBrowserApplication,
                      );
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildButton(
    BuildContext context, {
    required VoidCallback onPressed,
    required String title,
    required IconData icon,
  }) {
    return Material(
      color: BaseColor.primary3,
      borderRadius: BorderRadius.circular(12.w),
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: BaseColor.accent,
                size: 21.w,
              ),
              SizedBox(width: 6.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: BaseColor.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
