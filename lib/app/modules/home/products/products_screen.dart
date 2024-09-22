import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';
import 'package:mapalus_partner/app/modules/home/home.dart';
import 'package:mapalus_partner/app/widgets/card_product.dart';
import 'package:mapalus_partner/shared/routes.dart';

class ProductsScreen extends GetView<ProductsController> {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gap.h24,
          Text(
            'Products',
            textAlign: TextAlign.start,
            style: BaseTypography.displayLarge.toBold.toPrimary,
          ),
          Gap.h12,
          Row(
            children: [
              Expanded(
                child: InputWidget.text(
                  hint: "Cari Produk",
                  startIcon: Icons.search_rounded,
                  onChanged: controller.onChangedSearchText,
                  backgroundColor: BaseColor.white,
                  borderColor: BaseColor.accent,
                ),
              ),
              Gap.w12,
              ButtonWidget(
                text: "+ Product",
                onPressed: () async {
                  final product = await Get.toNamed(Routes.productDetail);

                  if (product != null) {
                    controller.addProduct(product as Product);
                  }
                },
              ),
            ],
          ),
          Gap.h12,
          Expanded(
            child: Obx(
              () => LoadingWrapper(
                loading: controller.loading.value,
                child: controller.products.isEmpty
                    ? const Center(
                        child: Text("No Product yet -_-"),
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.products.length,
                        separatorBuilder: (context, index) => Gap.h12,
                        itemBuilder: (context, index) => CardProduct(
                          product: controller.products[index],
                          onPressed: (product) async {
                            await Get.toNamed(
                              Routes.productDetail,
                              arguments: product,
                            );
                          },
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
