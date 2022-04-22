import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapalus_partner/app/widgets/screen_wrapper.dart';
import 'package:mapalus_partner/shared/routes.dart';
import 'package:mapalus_partner/shared/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void wait(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () {});
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.home,
      (route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    wait(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Palette.primary,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                'assets/images/mapalus.svg',
                width: 90.sp,
                height: 90.sp,
                color: Palette.accent,
              ),
              SizedBox(height: Insets.small.h),
              Text(
                'Partner App',
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Palette.accent,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}