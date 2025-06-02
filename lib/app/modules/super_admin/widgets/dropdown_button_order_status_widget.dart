import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class DropDownButtonOrderStatusWidget extends StatefulWidget {
  const DropDownButtonOrderStatusWidget({
    super.key,
    required this.list,
    required this.onChangeOrderStatus,
  });

  final List<OrderStatus> list;
  final void Function(OrderStatus value) onChangeOrderStatus;

  @override
  State<DropDownButtonOrderStatusWidget> createState() =>
      _DropDownButtonOrderStatusWidgetState();
}

class _DropDownButtonOrderStatusWidgetState extends State<DropDownButtonOrderStatusWidget> {
  late OrderStatus dropdownValue = widget.list.first;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Filter order status",
          style: BaseTypography.bodySmall,
        ),
        Gap.w12,
        Expanded(
          child: DropdownMenu<OrderStatus>(
            initialSelection: widget.list.first,
            textStyle: BaseTypography.bodySmall,
            onSelected: (OrderStatus? value) {

              setState(() {
                dropdownValue = value!;
              });
              if (value != null) {
                widget.onChangeOrderStatus(value);
              }
            },
            dropdownMenuEntries:
            UnmodifiableListView<DropdownMenuEntry<OrderStatus>>(
              widget.list.map<DropdownMenuEntry<OrderStatus>>(
                    (OrderStatus e) => DropdownMenuEntry(
                  value: e,
                  label: e.name.toUpperCase(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
