import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            "products 1",
            style: BaseTypography.caption,
          ),
          Text(
            "products 2",
            style: BaseTypography.caption,
          ),
          Text(
            "products 3",
            style: BaseTypography.caption,
          ),
        ],
      ),
    );
  }
}
