import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class SigningScreen extends GetView<SigningController> {
  const SigningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = context.isTablet;
    return ScreenWrapper(
      backgroundColor: Palette.accent,
      child: Flex(
        direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Palette.accent,
              child: CarouselSlider(
                items: [
                  _buildGraphicHolderCard(
                    context: context,
                    assetName: 'assets/vectors/phone.svg',
                    text: 'Pesan dirumah, harga pasar',
                  ),
                  _buildGraphicHolderCard(
                    context: context,
                    assetName: 'assets/vectors/bike.svg',
                    text: 'Tinggal tunggu, kami antar',
                  ),
                  _buildGraphicHolderCard(
                    context: context,
                    assetName: 'assets/vectors/packet.svg',
                    text: 'Tidak sesuai, kami ganti',
                  ),
                ],
                options: CarouselOptions(
                  pauseAutoPlayOnTouch: true,
                  viewportFraction: 1,
                  height: double.infinity,
                  initialPage: 0,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),
          Expanded(
            flex: isLargeScreen ? 1 : 0,
            child: _BuildCardSigning(
              tecPhone: controller.tecPhone,
              tecPassword: controller.tecPassword,
              onPressedSigning: controller.onPressedSignIn,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }

  _buildGraphicHolderCard({
    required BuildContext context,
    required String assetName,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Insets.small.w,
                    vertical: Insets.small.h,
                  ),
                  child: SvgPicture.asset(
                    assetName,
                    height: 200.h,
                  ),
                ),
                Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Palette.editable,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BuildCardSigning extends StatelessWidget {
  const _BuildCardSigning({
    Key? key,
    required this.tecPhone,
    required this.tecPassword,
    required this.controller,
    required this.onPressedSigning,
  }) : super(key: key);

  final TextEditingController tecPhone;
  final TextEditingController tecPassword;
  final SigningController controller;
  final VoidCallback onPressedSigning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.medium.w,
        vertical: Insets.small.w,
      ),
      decoration: BoxDecoration(
        color: Palette.cardForeground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.sp),
        ),
      ),
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: controller.isLoading.isTrue
              ? _buildLoading()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: Insets.small.h),
                    _buildTextField(
                      context,
                      controller: tecPhone,
                      title: "Phone",
                    ),
                    SizedBox(height: Insets.small.h),
                    _buildTextField(
                      context,
                      controller: tecPassword,
                      title: "Password",
                      obscureText: true,
                    ),
                    SizedBox(height: Insets.small.h),
                    Obx(() => AnimatedSwitcher(
                          duration: 400.milliseconds,
                          child: controller.errorText.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding:
                                      EdgeInsets.only(bottom: Insets.small.h),
                                  child: Text(
                                    controller.errorText.value,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        ?.copyWith(
                                          color: Palette.negative,
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w300,
                                        ),
                                  ),
                                ),
                        )),
                    _buildSigningButton(context, onPressedSigning),
                  ],
                ),
        ),
      ),
    );
  }

  _buildTextField(
    BuildContext context, {
    required controller,
    required title,
    obscureText = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Insets.small.w,
        vertical: 1.w,
      ),
      decoration: BoxDecoration(
        color: Palette.editable,
        borderRadius: BorderRadius.circular(9.sp),
      ),
      child: TextField(
        controller: controller,
        maxLines: 1,
        obscureText: obscureText,
        autocorrect: false,
        style: TextStyle(
          color: Palette.accent,
          fontFamily: fontFamily,
          fontSize: 12.sp,
        ),
        cursorColor: Palette.primary,
        decoration: InputDecoration(
          hintStyle: TextStyle(
            fontFamily: fontFamily,
            fontSize: 10.sp,
            color: Palette.accent,
          ),
          labelStyle: TextStyle(
            fontFamily: fontFamily,
            color: Palette.accent,
            fontSize: 12.sp,
          ),
          isDense: true,
          border: InputBorder.none,
          labelText: title,
        ),
      ),
    );
  }

  _buildSigningButton(
    BuildContext context,
    VoidCallback onPressedSigning,
  ) {
    return Material(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(12.w),
      color: Palette.primary,
      child: InkWell(
        onTap: onPressedSigning,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: Insets.small.h),
          child: Text('Sign In',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 14.sp,
                    color: Palette.accent,
                  )),
        ),
      ),
    );
  }

  _buildLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Insets.medium.h,
        horizontal: Insets.small.w,
      ),
      child: const CircularProgressIndicator(
        color: Palette.primary,
      ),
    );
  }
}