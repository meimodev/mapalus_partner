import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class BuilderSwitchOrderStatus extends StatelessWidget {
  const BuilderSwitchOrderStatus({
    super.key,
    required this.order,
    required this.placed,
    required this.accepted,
    required this.rejected,
    required this.finished,
  });

  final OrderApp order;
  final Widget placed;
  final Widget accepted;
  final Widget rejected;
  final Widget finished;

  @override
  Widget build(BuildContext context) {
    switch (order.status) {
      case OrderStatus.accepted:
        return accepted;
      case OrderStatus.rejected:
        return rejected;
      case OrderStatus.finished:
        return finished;
      default:
        return placed;
    }
  }
}
