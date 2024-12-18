import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class CardCartPeak extends StatelessWidget {
  const CardCartPeak({
    super.key,
    required this.onPressed,
    // required this.productOrders,
    required this.totalPrice,
    required this.cartOverview,
  });

  final VoidCallback onPressed;
  // final List<ProductOrder> productOrders;
  final String totalPrice;
  final String cartOverview;

  @override
  Widget build(BuildContext context) {
    // print('cart card');
    // String _calculateTotalPrice() {
    //   double total = 0;
    //   for (var element in productOrders) {
    //     total += element.totalPrice;
    //   }
    //   return Utils.formatNumberToCurrency(total);
    // }
    //
    // String _calculateProductTotalUnitAndWeight() {
    //   int tProduct = 0;
    //   double tWeight = 0;
    //   for (var element in productOrders) {
    //     tProduct++;
    //     tWeight += element.quantity;
    //   }
    //
    //   return "$tProduct produk, ${tWeight.toStringAsFixed(2)} kilogram"
    //       .replaceFirst(".00", '');
    // }

    return Material(
      clipBehavior: Clip.hardEdge,
      elevation: 9,
      color: BaseColor.accent,
      borderRadius: BorderRadius.circular(30.sp),
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 210.w,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: BaseSize.h12,
              horizontal: BaseSize.w12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // CircleAvatar(
                //   backgroundColor: BaseColor.primary,
                //   child: Padding(
                //     padding: EdgeInsets.all(9.sp),
                //     child: SvgPicture.asset(
                //       "assets/vectors/cart.svg",
                //     ),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(9.sp),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: BaseColor.primary3,
                  ),
                  child: SvgPicture.asset(
                    "assets/vectors/cart.svg",
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
                Gap.w12,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      totalPrice,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                        color: BaseColor.cardBackground1,
                        fontWeight: FontWeight.w400,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      cartOverview,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w300,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
