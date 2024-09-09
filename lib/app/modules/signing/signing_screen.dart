import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/signing/signing_controller.dart';

class SigningScreen extends GetView<SigningController> {
  const SigningScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = context.isTablet;
    return ScreenWrapper(
      backgroundColor: BaseColor.accent,
      child: Flex(
        direction: isLargeScreen ? Axis.horizontal : Axis.vertical,
        children: [
          // Expanded(
          //   flex: 2,
          //   child: Container(
          //     color: BaseColor.accent,
          //     child: CarouselSlider(
          //       items: [
          //         _buildGraphicHolderCard(
          //           context: context,
          //           assetName: 'assets/vectors/phone.svg',
          //           text: 'Pesan dirumah, harga pasar',
          //         ),
          //         _buildGraphicHolderCard(
          //           context: context,
          //           assetName: 'assets/vectors/bike.svg',
          //           text: 'Tinggal tunggu, kami antar',
          //         ),
          //         _buildGraphicHolderCard(
          //           context: context,
          //           assetName: 'assets/vectors/packet.svg',
          //           text: 'Tidak sesuai, kami ganti',
          //         ),
          //       ],
          //       options: CarouselOptions(
          //         pauseAutoPlayOnTouch: true,
          //         viewportFraction: 1,
          //         height: double.infinity,
          //         initialPage: 0,
          //         reverse: false,
          //         autoPlay: true,
          //         autoPlayInterval: const Duration(seconds: 4),
          //         autoPlayAnimationDuration: const Duration(milliseconds: 500),
          //         autoPlayCurve: Curves.fastOutSlowIn,
          //         enlargeCenterPage: false,
          //         scrollDirection: Axis.horizontal,
          //       ),
          //     ),
          //   ),
          // ),
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

  // _buildGraphicHolderCard({
  //   required BuildContext context,
  //   required String assetName,
  //   required String text,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.stretch,
  //     children: [
  //       Expanded(
  //         child: Center(
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.symmetric(
  //                   horizontal: BaseSize.w12,
  //                   vertical: BaseSize.h12,
  //                 ),
  //                 child: SvgPicture.asset(
  //                   assetName,
  //                   height: 200.h,
  //                 ),
  //               ),
  //               Text(
  //                 text,
  //                 style: const TextStyle(
  //                   color: BaseColor.editable,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
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
        horizontal: BaseSize.w12,
        vertical: BaseSize.w12,
      ),
      decoration: BoxDecoration(
        color: BaseColor.cardBackground1,
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
                    Gap.h12,
                    _buildTextField(
                      context,
                      controller: tecPhone,
                      title: "Phone",
                    ),
                    Gap.h12,
                    _buildTextField(
                      context,
                      controller: tecPassword,
                      title: "Password",
                      obscureText: true,
                    ),
                    Gap.h12,
                    Obx(() => AnimatedSwitcher(
                          duration: 400.milliseconds,
                          child: controller.errorText.isEmpty
                              ? const SizedBox()
                              : Padding(
                                  padding:
                                      EdgeInsets.only(bottom: BaseSize.h12),
                                  child: Text(
                                    controller.errorText.value,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: BaseColor.negative,
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
        horizontal: BaseSize.w12,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: BaseColor.editable,
        borderRadius: BorderRadius.circular(BaseSize.radiusMd),
      ),
      child: TextField(
        controller: controller,
        maxLines: 1,
        obscureText: obscureText,
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
            fontSize: 10.sp,
            color: BaseColor.accent,
          ),
          labelStyle: TextStyle(
            fontFamily: fontFamily,
            color: BaseColor.accent,
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
      color: BaseColor.primary3,
      child: InkWell(
        onTap: onPressedSigning,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: BaseSize.h12),
          child: Text('Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: BaseColor.accent,
              )),
        ),
      ),
    );
  }

  _buildLoading() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: BaseSize.h12,
        horizontal: BaseSize.w12,
      ),
      child: const CircularProgressIndicator(
        color: BaseColor.primary3,
      ),
    );
  }
}
