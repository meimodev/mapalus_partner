import 'package:flutter/material.dart';
import 'package:mapalus_partner/app/modules/product_detail/product_detail_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(color: Palette.primary))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Obx(
                      () => CardNavigation(
                        title: controller.isAdding.value
                            ? 'Tambah Produk Baru'
                            : "Product Detail",
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding:
                            EdgeInsets.symmetric(horizontal: Insets.medium.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: Insets.small.h),
                            _buildImageSelector(controller.onPressedImage),
                            SizedBox(height: Insets.small.h),
                            _buildListItem(
                              context: context,
                              title: "Name",
                              value: controller.product.name,
                              controller: controller.tecName,
                            ),
                            _buildListItem(
                              context: context,
                              title: "Description",
                              value: controller.product.description,
                              controller: controller.tecDescription,
                            ),
                            _buildListItem(
                              context: context,
                              title: "Price",
                              value: controller.product.price.toString(),
                              controller: controller.tecPrice,
                              numbersOnly: true,
                            ),
                            _buildListItem(
                                context: context,
                                title: "Unit",
                                value: controller.product.unit,
                                controller: controller.tecUnit,
                                onTextChanged: (value) {
                                  if (value.toLowerCase() == 'kilogram') {
                                    controller.tecWeight.text = "1000";
                                  }
                                }),
                            _buildListItem(
                              context: context,
                              title: "Weight in gram",
                              value: controller.product.weight.toString(),
                              controller: controller.tecWeight,
                              numbersOnly: true,
                            ),
                            _buildDropdownList(context, (value) {
                              if (value != null) {
                                controller.tecCategory.text = value;
                              }
                            }, controller.tecCategory.text),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Obx(
                                  () => _buildCheckbox(
                                    context: context,
                                    title: "Available",
                                    value: controller.isAvailable.value,
                                    onChange:
                                        controller.onPressedAvailableCheckbox,
                                  ),
                                ),
                                Obx(
                                  () => _buildCheckbox(
                                    context: context,
                                    title: "Custom Price",
                                    value: controller.isCustomPrice.value,
                                    onChange:
                                        controller.onPressedCustomPriceCheckbox,
                                  ),
                                ),
                              ],
                            ),
                            _buildListItem(
                              context: context,
                              title: "Minimum price",
                              value: controller.product.minimumPrice.toString(),
                              controller: controller.tecMinimumPrice,
                              numbersOnly: true,
                            ),
                            SizedBox(height: Insets.large.h),
                            controller.isAdding.isTrue
                                ? const SizedBox()
                                : _buildDeleteButton(
                                    context, controller.onPressedDelete),
                            SizedBox(height: Insets.large.h),
                          ],
                        ),
                      ),
                    ),
                    _buildErrorText(context),
                    _buildSaveButton(
                      context,
                      controller.onPressedSaveButton,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _buildListItem({
    required BuildContext context,
    required String title,
    required String value,
    required TextEditingController controller,
    Function(String)? onTextChanged,
    bool numbersOnly = false,
    int maxLines = 1,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Insets.small.h * .5,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Insets.small.w,
        vertical: 2.w,
      ),
      decoration: BoxDecoration(
        color: Palette.editable,
        borderRadius: BorderRadius.circular(9.sp),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            maxLines: maxLines,
            autocorrect: false,
            onChanged: onTextChanged,
            keyboardType:
                numbersOnly ? TextInputType.number : TextInputType.text,
            textInputAction: TextInputAction.next,
            style: TextStyle(
              color: Palette.accent,
              fontFamily: fontFamily,
              fontSize: 12.sp,
            ),
            cursorColor: Palette.primary,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                fontFamily: fontFamily,
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
                color: Palette.textPrimary,
              ),
              isDense: true,
              border: InputBorder.none,
              labelText: title,
            ),
          ),
          // Obx(
          //       () => AnimatedSwitcher(
          //     duration: 400.milliseconds,
          //     child: controller.errorText.isNotEmpty
          //         ? Text(
          //       controller.errorText.value,
          //       style: Theme.of(context).textTheme.bodyText1?.copyWith(
          //         color: Palette.negative,
          //         fontSize: 10.sp,
          //         fontWeight: FontWeight.w300,
          //       ),
          //     )
          //         : const SizedBox(),
          //   ),
          // ),
        ],
      ),
    );
  }

  _buildCheckbox({
    required title,
    required value,
    required onChange,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
        ),
        Checkbox(
          activeColor: Palette.primary,
          checkColor: Palette.accent,
          visualDensity: VisualDensity.comfortable,
          value: value,
          onChanged: onChange,
        ),
      ],
    );
  }

  _buildImageSelector(VoidCallback onPressedImage) {
    return Material(
      clipBehavior: Clip.hardEdge,
      color: Palette.primary,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressedImage,
        child: SizedBox(
          height: 400.sp,
          width: 400.sp,
          child: CustomImage(
            imageUrl: controller.product.imageUrl,
          ),
        ),
      ),
    );
  }

  _buildErrorText(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: controller.errorText.isEmpty
            ? const SizedBox()
            : Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Insets.small.h,
                  horizontal: Insets.medium.w,
                ),
                child: Text(
                  controller.errorText.value,
                  style: TextStyle(
                        color: Palette.negative,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  _buildSaveButton(
    BuildContext context,
    VoidCallback onPressed,
  ) {
    return Material(
      color: Palette.primary,
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(9.sp),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: Insets.small.h,
          ),
          child: Text(
            controller.isAdding.isTrue ? "Add" : 'Save',
            textAlign: TextAlign.center,
            style: TextStyle(
                  color: Palette.accent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
          ),
        ),
      ),
    );
  }

  _buildDeleteButton(
    BuildContext context,
    Function(String productId) onPressed,
  ) {
    return Material(
      color: Palette.negative,
      borderRadius: BorderRadius.circular(9.sp),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onPressed(controller.product.id);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: Insets.small.h,
          ),
          child: Text(
            "Delete Product",
            textAlign: TextAlign.center,
            style: TextStyle (
                  color: Palette.cardForeground,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
          ),
        ),
      ),
    );
  }

  _buildDropdownList(
    BuildContext context,
    Function(String?)? onChanged,
    String current,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Insets.small.h * .5,
      ),
      decoration: BoxDecoration(
        color: Palette.editable,
        borderRadius: BorderRadius.circular(9.sp),
      ),
      child: DropDown<String>(
        showUnderline: false,
        items: controller.categories,
        hint: Padding(
          padding: EdgeInsets.only(
            left: Insets.small.w,
          ),
          child: Text(
            current.isEmpty ? 'Category' : current,
            style:TextStyle (
                  color: Palette.accent,
                  fontSize: 12.sp,
                  fontWeight:
                      current.isEmpty ? FontWeight.w400 : FontWeight.w300,
                ),
          ),
        ),
        customWidgets: <Widget>[
          for (var e in controller.categories)
            Padding(
              padding: EdgeInsets.only(
                left: Insets.small.w,
              ),
              child: Text(
                e,
                style: TextStyle (
                      color: Palette.accent,
                      fontWeight: e.toLowerCase() == current.toLowerCase()
                          ? FontWeight.bold
                          : FontWeight.w400,
                      fontSize: 12.sp,
                    ),
              ),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}
