import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_partner/app/widgets/dialog_confirm.dart';

class CardCartItem extends StatelessWidget {
  const CardCartItem({
    super.key,
    required this.index,
    required this.productOrder,
    required this.onPressedDelete,
  });

  final int index;
  final ProductOrder productOrder;
  final Function(ProductOrder productOrder) onPressedDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: BaseSize.w12,
        vertical: BaseSize.h12,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: BaseSize.w12,
        vertical: BaseSize.h12,
      ),
      decoration: BoxDecoration(
          color: BaseColor.cardBackground1,
          borderRadius: BorderRadius.circular(9.sp)),
      child: Row(
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              (index + 1).toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Gap.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productOrder.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${productOrder.product} / ${productOrder.product.unit}",
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                _BuildAlterQuantity(
                  productOrder: productOrder,
                ),
              ],
            ),
          ),
          Gap.h12,
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => DialogConfirm(
                  onPressedConfirm: () => onPressedDelete(productOrder),
                  description:
                      'Hapus ${productOrder.product.name} dari keranjang ?',
                ),
              ),
              child: SizedBox(
                height: 60.h,
                width: 30.w,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/vectors/cross.svg',
                    width: 21.sp,
                    height: 21.sp,
                    colorFilter: const ColorFilter.mode(
                      BaseColor.negative,
                      BlendMode.srcIn,
                    ),
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

// class _BuildAlterQuantity extends StatefulWidget {
//   const _BuildAlterQuantity({
//     Key? key,
//     required this.productOrder,
//   }) : super(key: key);
//
//   final ProductOrder productOrder;
//
//   @override
//   State<_BuildAlterQuantity> createState() => _BuildAlterQuantityState();
// }
//
// class _BuildAlterQuantityState extends State<_BuildAlterQuantity> {
//   TextEditingController tecWeight = TextEditingController();
//   TextEditingController tecPrice = TextEditingController();
//
//   @override
//   void dispose() {
//     tecWeight.dispose();
//     tecPrice.dispose();
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     tecWeight.text = widget.productOrder.quantityString;
//     tecPrice.text = widget.productOrder.totalPriceString;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 6.h),
//         _buildAlterRowItem(
//           controller: tecWeight,
//           context: context,
//           onAdd: () {},
//           onSub: () {},
//           value: widget.productOrder.product.unit,
//         ),
//         SizedBox(height: 6.h),
//         _buildAlterRowItem(
//           context: context,
//           controller: tecPrice,
//           onAdd: () {},
//           onSub: () {},
//           value: 'rupiah',
//         ),
//       ],
//     );
//   }
//
//   _buildAlterRowItem({
//     required BuildContext context,
//     required String value,
//     required VoidCallback onAdd,
//     required VoidCallback onSub,
//     required TextEditingController controller,
//   }) {
//     return Row(
//       children: [
//         Container(
//           width: 120.w,
//           height: 30.h,
//           padding: EdgeInsets.symmetric(
//             horizontal: 6.w,
//           ),
//           decoration: BoxDecoration(
//             color: BaseColor.editable,
//             borderRadius: BorderRadius.circular(3.sp),
//           ),
//           child: TextField(
//             controller: controller,
//             enabled: false,
//             maxLines: 1,
//             autocorrect: false,
//             style: TextStyle(
//               color: BaseColor.accent,
//               fontFamily: fontFamily,
//               fontSize: 12.sp,
//             ),
//             cursorColor: BaseColor.primary,
//             decoration: InputDecoration(
//                 hintStyle: TextStyle(
//                   color: Colors.grey,
//                   fontFamily: fontFamily,
//                   fontSize: 12.sp,
//                 ),
//                 isDense: true,
//                 border: InputBorder.none,
//                 hintText: value,
//                 suffix: Text(
//                   value,
//                   style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                     fontWeight: FontWeight.w300,
//                     fontSize: 12.sp,
//                     color: Colors.grey,
//                   ),
//                 )),
//           ),
//         ),
//         // SizedBox(width: 6.w),
//         // _buildQuantityAlterButton(
//         //   context: context,
//         //   title: '-',
//         //   onPressed: onAdd,
//         // ),
//         // SizedBox(width: 6.w),
//         // _buildQuantityAlterButton(
//         //   context: context,
//         //   title: '+',
//         //   onPressed: onSub,
//         // ),
//       ],
//     );
//   }
//
//   _buildQuantityAlterButton({
//     required BuildContext context,
//     required VoidCallback onPressed,
//     required String title,
//   }) {
//     return Material(
//       clipBehavior: Clip.hardEdge,
//       color: BaseColor.editable,
//       borderRadius: BorderRadius.circular(3.sp),
//       child: InkWell(
//         onTap: onPressed,
//         child: SizedBox(
//           height: 30.h,
//           width: 30.h,
//           child: Center(
//             child: Text(
//               title,
//               style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w300,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class _BuildAlterQuantity extends StatelessWidget {
  const _BuildAlterQuantity({
    required this.productOrder,
  });

  final ProductOrder productOrder;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 6.h),
        _buildAlterRowItem(
          context: context,
          value: productOrder.quantity.toString(),
          unit: productOrder.product.unit?.name ?? "",
        ),
        SizedBox(height: 6.h),
        _buildAlterRowItem(
          context: context,
          value: productOrder.totalPrice.formatNumberToCurrency(),
          unit: 'Rupiah',
        ),
      ],
    );
  }

  Widget _buildAlterRowItem({
    required BuildContext context,
    required String value,
    required String unit,
  }) {
    return Row(
      children: [
        Container(
          width: 120.w,
          height: 30.h,
          padding: EdgeInsets.symmetric(
            horizontal: 6.w,
          ),
          decoration: BoxDecoration(
            color: BaseColor.editable,
            borderRadius: BorderRadius.circular(3.sp),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: BaseColor.accent,
                  fontFamily: fontFamily,
                  fontSize: 12.sp,
                ),
              ),
              Text(
                unit,
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: fontFamily,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        // SizedBox(width: 6.w),
        // _buildQuantityAlterButton(
        //   context: context,
        //   title: '-',
        //   onPressed: onAdd,
        // ),
        // SizedBox(width: 6.w),
        // _buildQuantityAlterButton(
        //   context: context,
        //   title: '+',
        //   onPressed: onSub,
        // ),
      ],
    );
  }
}
