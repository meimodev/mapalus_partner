import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class ButtonAlterQuantity extends StatelessWidget {
  const ButtonAlterQuantity(
      {super.key,
      required this.onPressed,
      required this.label,
      this.isEnabled = true});

  final VoidCallback onPressed;
  final String label;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled ? BaseColor.primary3 : Colors.grey.shade300,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        child: SizedBox(
          width: 45.w,
          height: 45.h,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 19.sp,
                color: isEnabled ? BaseColor.primaryText : Colors.grey.shade400,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
