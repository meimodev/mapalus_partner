import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_partner/app/modules/product_detail/product_detail_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Obx(
        () => LoadingWrapper(
          loading: controller.loading.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardNavigation(
                title: controller.adding ? 'Tambah Produk' : "Edit Produk",
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: BaseSize.w24),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap.h24,
                      ImagePickerWidget(
                        label: "Gambar Produk",
                        onPressed: controller.onPressedImage,
                        imageUrl: controller.product?.image ?? "",
                        errorText: controller.errorTextImage,
                        height: BaseSize.customHeight(250),
                      ),
                      Gap.h12,
                      InputWidget.dropdown(
                        backgroundColor: BaseColor.white,
                        currentInputValue: controller.product?.type?.name,
                        label: 'Tipe Produk',
                        hint: 'Tipe',
                        errorText: controller.errorTextType,
                        onPressedWithResult: () async {
                          final res = await showSingleSelectionDialogWidget<
                              ProductType>(
                            context: context,
                            title: "Tipe Produk",
                            getDisplayText: (data) => data.name,
                            items: ProductType.values,
                          );

                          if (res != null) {
                            controller.onChangedType(res);
                          }

                          return res?.name;
                        },
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        hint: "Nama",
                        label: "Nama",
                        errorText: controller.errorTextName,
                        currentInputValue: controller.product?.name,
                        onChanged: controller.onChangedName,
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        hint: "Deskripsi",
                        label: "Deskripsi",
                        currentInputValue: controller.product?.description,
                        errorText: controller.errorTextDescription,
                        onChanged: controller.onChangedDescription,
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        hint: "Harga",
                        label: "Harga",
                        textInputType: TextInputType.number,
                        errorText: controller.errorTextPrice,
                        currentInputValue:
                            controller.product?.price.toStringAsFixed(0),
                        onChanged: controller.onChangedPrice,
                      ),
                      Gap.h12,
                      InputWidget.dropdown(
                        backgroundColor: BaseColor.white,
                        currentInputValue:
                            controller.product?.unit?.name.capitalizeFirst,
                        label: 'Unit',
                        hint: 'Unit',
                        errorText: controller.errorTextUnit,
                        onPressedWithResult: () async {
                          final res = await showSingleSelectionDialogWidget<
                              ProductUnit>(
                            context: context,
                            title: "Unit Produk",
                            getDisplayText: (data) => data.name,
                            items: ProductUnit.values,
                          );

                          if (res != null) {
                            controller.onChangedUnit(res);
                          }

                          return res?.name;
                        },
                      ),
                      Gap.h12,
                      InputWidget.text(
                        backgroundColor: BaseColor.white,
                        label: "Berat dalam gram",
                        hint: "Berat dalam gram",
                        errorText: controller.errorTextWeight,
                        textInputType: TextInputType.number,
                        currentInputValue:
                            controller.product?.weight.toStringAsFixed(0),
                        onChanged: controller.onChangedWeight,
                      ),
                      Gap.h12,
                      InputWidget.dropdown(
                        backgroundColor: BaseColor.white,
                        currentInputValue: controller.product?.category,
                        label: 'Kategori',
                        hint: 'Kategori',
                        errorText: controller.errorTextCategory,
                        onPressedWithResult: () async {
                          final res =
                              await showSingleSelectionDialogWidget<String>(
                            context: context,
                            title: "Kategori",
                            getDisplayText: (data) => data,
                            items: controller.availableCategories,
                          );

                          if (res != null) {
                            controller.onChangedCategory(res);
                          }

                          return res;
                        },
                      ),
                      Gap.h12,
                      InputWidget.dropdown(
                        backgroundColor: BaseColor.white,
                        currentInputValue: controller.product?.status?.name,
                        label: 'Status',
                        hint: 'Status',
                        errorText: controller.errorTextStatus,
                        onPressedWithResult: () async {
                          final res = await showSingleSelectionDialogWidget<
                              ProductStatus>(
                            context: context,
                            title: "Status",
                            getDisplayText: (data) => data.translate,
                            items: ProductStatus.values,
                          );

                          if (res != null) {
                            controller.onChangedStatus(res);
                          }

                          return res?.name;
                        },
                      ),
                      // Gap.h12,
                      // InputWidget.binaryOption(
                      //   backgroundColor: BaseColor.white,
                      //   currentInputValue:
                      //       controller.product?.customPrice ?? false
                      //           ? "Ya"
                      //           : "Tidak",
                      //   options: const ["Ya", "Tidak"],
                      //   label: "Harga Bisa Custom",
                      //   errorText: controller.errorTextCustomPrice,
                      //   onChanged: (value) =>
                      //       controller.onChangedCustomPrice(value == "Ya"),
                      // ),
                      // Gap.h12,
                      // InputWidget.text(
                      //   backgroundColor: BaseColor.white,
                      //   label: "Harga Minimal",
                      //   hint: "Harga Minimal",
                      //   textInputType: TextInputType.number,
                      //   errorText: controller.errorTextMinimumPrice,
                      //   currentInputValue:
                      //       controller.product?.minimumPrice.toStringAsFixed(0),
                      //   onChanged: controller.onChangedMinimumPrice,
                      // ),
                      Gap.h24,
                      controller.adding
                          ? ButtonWidget(
                              text: "Tambah Produk",
                              padding: EdgeInsets.symmetric(
                                vertical: BaseSize.h12,
                              ),
                              onPressed: controller.onPressedSaveButton,
                            )
                          : const SizedBox(),
                      Gap.h12,
                      controller.adding
                          ? const SizedBox()
                          : ButtonWidget(
                              padding: EdgeInsets.symmetric(
                                vertical: BaseSize.h12,
                              ),
                              text: "Edit Produk",
                              onPressed: controller.onPressedSaveButton,
                            ),
                      controller.adding
                          ? const SizedBox()
                          : ButtonWidget(
                              padding: EdgeInsets.symmetric(
                                vertical: BaseSize.h12,
                              ),
                              text: "Hapus Produk",
                              onPressed: () => controller
                                  .onPressedDelete(controller.product!.id),
                            ),
                      Gap.h24,
                    ],
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
