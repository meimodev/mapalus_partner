import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class DialogConfirm extends StatelessWidget {
  const DialogConfirm({
    super.key,
    required this.onPressedConfirm,
    this.title,
    this.description,
    this.confirmText,
  });

  final VoidCallback onPressedConfirm;
  final String? title;
  final String? description;
  final String? confirmText;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(
          top: BaseSize.h24,
          left: BaseSize.w12,
          right: BaseSize.w12,
          bottom: BaseSize.h12,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title ?? 'Perhatian !',
              style: TextStyle(
                fontSize: 16.sp,
              ),
            ),
            Gap.h12,
            Text(
              description ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            Gap.h24,
            Row(
              children: [
                const Expanded(child: SizedBox()),
                Material(
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(BaseSize.radiusSm),
                  ),
                  child: InkWell(
                    onTap: () {
                      onPressedConfirm();
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: BaseSize.w12,
                        vertical: BaseSize.h12,
                      ),
                      child: Center(
                        child: Text(
                          confirmText ?? 'HAPUS',
                          style: const TextStyle(
                            color: BaseColor.primary3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
