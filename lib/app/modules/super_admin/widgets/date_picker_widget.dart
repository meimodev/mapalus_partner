import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';

class DateRangePickerWidget extends StatefulWidget {
  const DateRangePickerWidget({super.key, required this.onChangedDate});

  final void Function(DateTimeRange value) onChangedDate;

  @override
  State<DateRangePickerWidget> createState() => _DateRangePickerWidgetState();
}

class _DateRangePickerWidgetState extends State<DateRangePickerWidget> {
  DateTimeRange? value;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderOnForeground: true,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(BaseSize.radiusSm),
        side: BorderSide(),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () async {
          final firstDate = DateTime(2025);
          final result = await showDateRangePicker(
            context: context,
            firstDate: firstDate,
            lastDate: firstDate.add(const Duration(days: 360)),
          );
          if (result != null) {
            setState(() {
              value = result;
            });
            widget.onChangedDate(result);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: BaseSize.w12,
            vertical: BaseSize.h12,
          ),
          child: Text(
            value == null ? "Select Date Range" : "${value!.start
                .ddMmmmYyyy} - ${value!.end.ddMmmmYyyy}",
            style: BaseTypography.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
