import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mapalus_partner/app/widgets/builder_switcher_order_status.dart';
import 'package:mapalus_partner/data/models/order.dart';
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
    return Material(
      borderRadius: BorderRadius.circular(9.sp),
      color: Palette.cardForeground,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(Insets.small.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 39.w,
                child: Text(
                  '#${order.id!.replaceRange(0, 12, '')}',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dipesan',
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w300,
                          ),
                    ),
                    Text(
                      order.orderTimeStamp!.format('E, dd MMMM'),
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            fontWeight: FontWeight.w600,
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
                      order.orderInfo.totalPrice,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              SizedBox(
                width: 100.w,
                child: BuilderSwitchOrderStatus(
                  order: order,
                  placed: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Menunggu konfirmasi',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  accepted: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.orderInfo.deliveryTime,
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  rejected: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ditolak',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  finished: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'selesai',
                        style: Theme.of(context).textTheme.caption?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                      order.rating.ratingTimeStamp == null
                          ? const SizedBox()
                          : Text(
                              order.rating.ratingTimeStamp!
                                  .format("E, dd MMMM"),
                              style:
                                  Theme.of(context).textTheme.caption?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}