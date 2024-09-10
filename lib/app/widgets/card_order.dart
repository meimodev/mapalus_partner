import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardOrder extends StatelessWidget {
  const CardOrder({
    super.key,
    required this.order,
    required this.onPressed,
  });

  final OrderApp order;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.cardBackground1,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36.w,
                    child: Text(
                      '#${order.id}',
                      style: TextStyle(
                        fontSize: 10.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Text(
                    " | ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    order.orderBy.name,
                    style: TextStyle(
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'dipesan',
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 9.sp,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          order.status.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: BaseColor.primaryText,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${order.products.length} produk',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          "order.orderInfo.totalPriceF",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 6.w),
                  SizedBox(
                    width: 100.w,
                    child: _buildCardOrderStatus(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardOrderStatus(BuildContext context) {
    if (order.status == OrderStatus.placed) {
      return Column(
        children: [
          Text(
            'Menunggu konfirmasi',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 1.h,
              color: BaseColor.primary3,
            ),
          ),
        ],
      );
    }
    if (order.status == OrderStatus.accepted) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'antar',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 9.sp,
            ),
          ),
          Text(
            "order.orderInfo.deliveryTime",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 3.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 1.h,
              color: BaseColor.accent,
            ),
          ),
        ],
      );
    }
    if (order.status == OrderStatus.rejected) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'batal',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: BaseColor.negative,
              fontSize: 9.sp,
            ),
          ),
          Text(
            order.lastUpdate.EddMMMHHmm,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: BaseColor.negative,
              fontSize: 10.sp,
            ),
          ),
        ],
      );
    }
    if (order.status == OrderStatus.delivered) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'diantar',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 9.sp,
              color: BaseColor.positive,
            ),
          ),
          Text(
            order.lastUpdate.EddMMMHHmm,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: BaseColor.positive,
              fontSize: 11.sp,
            ),
          ),
        ],
      );
    }
    if (order.status == OrderStatus.finished) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selesai',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 10.sp,
            ),
          ),
          Text(
            order.lastUpdate.EddMMMHHmm,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ],
      );
    }
  }
}
