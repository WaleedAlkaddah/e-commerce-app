import 'package:flutter/material.dart';

class RefreshIndicatorWidget extends StatelessWidget {
  final Widget childWidget;
  final RefreshCallback onRefreshCall;
  const RefreshIndicatorWidget(
      {super.key, required this.childWidget, required this.onRefreshCall});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        color: const Color(0xff00C569),
        backgroundColor: Colors.white,
        displacement: 10.0,
        onRefresh: onRefreshCall,
        child: childWidget);
  }
}
