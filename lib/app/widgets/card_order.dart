import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mapalus_partner/data/models/order.dart';
import 'package:mapalus_partner/shared/enums.dart';
import 'package:mapalus_partner/shared/theme.dart';

class CardOrder extends StatelessWidget {
  const CardOrder({
    Key? key,
    required this.order,
    required this.onPressed,
  }) : super(key: key);

  final Order order;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final isToday = order.orderTimeStamp!.isSame(
      Jiffy(),
      Units.DAY,
    );

    return Material(
      borderRadius: BorderRadius.circular(9.sp),
      color: Palette.cardForeground,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(Insets.medium.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 39.w,
                child: Text(
                  '#${order.idMinified}',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(width: 9.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dipesan',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 10.sp,
                      ),
                    ),
                    Text(
                      isToday && order.status == OrderStatus.placed
                          ? "Hari Ini ${order.orderTimeStamp!.format('H:mm')}"
                          : order.orderTimeStamp!.format('E, dd MMM H:mm'),
                      style: TextStyle(
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w300,
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
                      style: Theme.of(context).textTheme.caption,
                    ),
                    Text(
                      order.orderInfo.totalPriceF,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              SizedBox(
                width: 100.w,
                child: _buildCardStatus(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardStatus(BuildContext context) {
    if (order.status == OrderStatus.placed) {
      return Column(
        children: [
          Text(
            'Menunggu konfirmasi',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w600,
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
            'diantar',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10.sp,
                ),
          ),
          Text(
            order.orderInfo.deliveryTime,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w600,
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
      return Text(
        'ditolak',
        style: Theme.of(context).textTheme.caption?.copyWith(
              fontWeight: FontWeight.w600,
              color: Palette.negative,
            ),
      );
    }
    if (order.status == OrderStatus.finished) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'selesai',
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 10.sp,
                ),
          ),
          Text(
            order.rating.ratingTimeStamp.format("E, dd MMMM"),
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      );
    }
  }
}
