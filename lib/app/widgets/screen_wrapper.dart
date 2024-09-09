import 'package:flutter/material.dart';
import 'package:mapalus_flutter_commons/mapalus_flutter_commons.dart';

class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor ?? BaseColor.white,
        body: child,
      ),
    );
  }
}
