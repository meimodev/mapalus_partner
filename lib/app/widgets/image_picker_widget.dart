import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/shared/shared.dart';
import 'package:mapalus_flutter_commons/widgets/widgets.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({
    super.key,
    this.imageUrl = "",
    this.height,
    this.label,
    this.errorText = "",
    this.cameras = const [],
    this.onChangedImage,
  });

  final String? imageUrl;
  final String? label;
  final double? height;
  final String errorText;
  final List<CameraDescription> cameras;
  final void Function(File)? onChangedImage;

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String imageUrl = "";
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.imageUrl!.isNotEmpty) {
      setState(() {
        imageUrl = widget.imageUrl!;
      });
    }
  }

  void onPressedImage() async {
    final res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _ImagePickerScreen(
          cameras: widget.cameras,
        ),
      ),
    );
    if (res != null) {
      setState(() {
        imageFile = File(res as String);
      });
      widget.onChangedImage?.call(imageFile!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: BaseTypography.bodyMedium.toSecondary,
              )
            : const SizedBox(),
        widget.label != null ? Gap.h8 : const SizedBox(),
        Material(
          clipBehavior: Clip.hardEdge,
          borderRadius: BorderRadius.circular(BaseSize.radiusMd),
          child: InkWell(
            onTap: onPressedImage,
            child: SizedBox(
              height: widget.height ?? BaseSize.h96,
              child: imageFile == null
                  ? CustomImage(
                      imageUrl: imageUrl,
                      assetPath: imageFile?.path,
                    )
                  : Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        widget.errorText.isEmpty ? const SizedBox() : Gap.h4,
        widget.errorText.isEmpty
            ? const SizedBox()
            : Text(
                widget.errorText,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: BaseTypography.bodySmall.toError,
              ),
      ],
    );
  }
}

class _ImagePickerScreen extends StatefulWidget {
  const _ImagePickerScreen({
    required this.cameras,
  });

  final List<CameraDescription> cameras;

  @override
  State<_ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<_ImagePickerScreen> {
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    if (cameraController == null) {
      initCamera();
    }
  }

  void initCamera() async {
    cameraController = CameraController(
      widget.cameras[0],
      ResolutionPreset.medium,
      enableAudio: false,
    );
    cameraController?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }

  void onPressedTakePicture() {
    cameraController?.takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          if (file != null) {
            Navigator.pop(context, file.path);
          }
        });
      }
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return const SizedBox();
    }
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: CameraPreview(cameraController!),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: BaseSize.h48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ButtonWidget(
                  backgroundColor: BaseColor.cardBackground1,
                  icon: Icons.arrow_back_outlined,
                  onPressed: () => Navigator.pop(context),
                ),
                ButtonWidget(
                  icon: Icons.camera_alt_outlined,
                  onPressed: onPressedTakePicture,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
