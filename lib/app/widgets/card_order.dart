import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class CardOrder extends StatelessWidget {
  const CardOrder({
    Key? key,
    required this.order,
    required this.onPressed,
  }) : super(key: key);

  final OrderApp order;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isToday = order.orderTimeStamp.isSame(
      Jiffy(),
      Units.DAY,
    );

    return Material(
      color: Palette.cardForeground,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.medium.sp,
            vertical: Insets.small.sp,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36.w,
                    child: Text(
                      '#${order.idMinified}',
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
                    order.orderingUser.name,
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
                          isToday && order.status == OrderStatus.placed
                              ? "Hari Ini ${order.orderTimeStamp.format('H:mm')}"
                              : order.orderTimeStamp.format('E, dd MMM H:mm'),
                          style: TextStyle(
                            fontWeight:
                                isToday ? FontWeight.w600 : FontWeight.w300,
                            color: Palette.textPrimary,
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
                          order.orderInfo.totalPriceF,
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
              color: Palette.primary,
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
            order.orderInfo.deliveryTime,
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
              color: Palette.accent,
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
              color: Palette.negative,
              fontSize: 9.sp,
            ),
          ),
          Text(
            order.confirmTimeStamp?.format("E, dd MMMM") ?? '-',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Palette.negative,
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
              color: Palette.positive,
            ),
          ),
          Text(
            order.deliverTimeStamp?.format("E, dd MMM HH:mm:ss") ?? '-',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Palette.positive,
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
            order.finishTimeStamp!.format("E, dd MMMM"),
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
