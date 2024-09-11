import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Column(
        children: [
          Text(
            "partners 1",
            style: BaseTypography.caption,
          )
        ],
      ),
    );
  }
}
