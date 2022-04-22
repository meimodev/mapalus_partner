import 'package:flutter/material.dart';
import 'package:mapalus_partner/app/modules/product_detail/product_detail_controller.dart';
import 'package:mapalus_partner/app/widgets/card_navigation.dart';
import 'package:mapalus_partner/app/widgets/screen_wrapper.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends GetView<ProductDetailController> {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          Obx(
            () => CardNavigation(
              title: controller.isAdding.value
                  ? 'Tambah Produk Baru'
                  : "Product Detail",
            ),
          ),
          Text(
            'Image Goes Here',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Name',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'ID',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Description',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'price',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'price',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'unit',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'availability',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'unit',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'weight',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'is Custom Price',
            style: Theme.of(context).textTheme.bodyText1?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}