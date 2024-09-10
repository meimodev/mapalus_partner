import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Dashboard',
            style: BaseTypography.caption,
          ),
          Text(
            'Stats about the store, '
            'about newly received order, '
            'availability of products..., '
            'card of partner info + clickable to partner setting',
            style: BaseTypography.caption,
          ),
        ],
      ),
    );
  }
}
