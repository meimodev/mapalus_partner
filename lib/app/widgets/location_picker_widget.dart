import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapalus_flutter_commons/models/models.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/button_widget.dart';
import 'package:mapalus_flutter_commons/widgets/loading_wrapper.dart';
import 'package:mapalus_flutter_commons/widgets/screen_wrapper.dart';
import 'package:mapalus_partner/app/widgets/google_map_wrapper.dart';
import 'package:mapalus_partner/app/widgets/widgets.dart';

class LocationPickerWidget extends StatefulWidget {
  const LocationPickerWidget({
    super.key,
    this.label,
    required this.onChanged,
    this.errorText,
    required this.hint,
    this.currentValue,
  });

  final String? label;
  final String? errorText;
  final String hint;
  final Location? currentValue;
  final void Function(double latitude, double longitude) onChanged;

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  Location? location;
  String errorText = "";

  @override
  void initState() {
    super.initState();
    if (widget.errorText != null) {
      setState(() {
        errorText = widget.errorText!;
      });
    }
    if (widget.currentValue != null) {
      setState(() {
        location = widget.currentValue!;
      });
    }
  }

  void onPressed() async {
    //Open the activity with map then rebuild the widget

    final result = await Navigator.push<LatLng?>(
      context,
      MaterialPageRoute(
        builder: (context) => _GoogleMapPicker(
          onPressedSelectedLocation: (value) =>
              Navigator.pop<LatLng?>(context, value),
          defaultLatLng: LatLng(
            location?.latitude ?? -6.163131674850957,
            location?.longitude ?? 106.83531972017443,
          ),
        ),
      ),
    );
    if (result != null) {
      setState(() {
        location = Location(
            place: "", latitude: result.latitude, longitude: result.longitude);
      });
      widget.onChanged(result.latitude, result.longitude);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label == null
            ? const SizedBox()
            : Text(
                widget.label!,
                style: BaseTypography.bodyMedium.toSecondary,
              ),
        Gap.h4,
        Material(
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(BaseSize.radiusLg),
            side: BorderSide(
              color:
                  errorText.isNotEmpty ? BaseColor.error : BaseColor.primary3,
              width: 3,
            ),
          ),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: BaseSize.h12,
                horizontal: BaseSize.w12,
              ),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: BaseColor.primary3,
                      size: BaseSize.customRadius(20),
                    ),
                    Gap.w12,
                    Expanded(
                      child: Text(
                        location != null
                            ? "Lokasi sudah di pilih"
                            : widget.hint,
                        style: BaseTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Gap.h4,
        errorText.isEmpty
            ? const SizedBox()
            : Text(
                errorText,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: BaseTypography.bodySmall.toError,
              ),
      ],
    );
  }
}

class _GoogleMapPicker extends StatefulWidget {
  const _GoogleMapPicker({
    required this.onPressedSelectedLocation,
    required this.defaultLatLng,
  });

  final void Function(LatLng value) onPressedSelectedLocation;
  final LatLng defaultLatLng;

  @override
  State<_GoogleMapPicker> createState() => _GoogleMapPickerState();
}

class _GoogleMapPickerState extends State<_GoogleMapPicker> {
  LatLng selectedLatLng = LatLng(
    -6.163131674850957,
    106.83531972017443,
  );

  @override
  void initState() {
    super.initState();
    selectedLatLng = widget.defaultLatLng;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            left: 0,
            child: GoogleMapWrapper(
              onCameraIdle: (value) {
                if (value != null) {
                  selectedLatLng = value;
                }
              },
              onMapCreated: (controller) {},
              defaultPosition: widget.defaultLatLng,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CardNavigation(
                  title: 'Pilih Lokasi',
                ),
                Expanded(
                  child: LoadingWrapper(
                    loading: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: BaseSize.customWidth(100),
                          child: ButtonWidget(
                            text: "Pilih",
                            onPressed: () => widget
                                .onPressedSelectedLocation(selectedLatLng),
                          ),
                        ),
                        Gap.h12,
                        Icon(
                          Icons.location_on,
                          color: BaseColor.primary3,
                          size: BaseSize.customRadius(30),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
