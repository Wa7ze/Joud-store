import 'package:flutter/material.dart';

class PageContainer extends StatelessWidget {
  const PageContainer({super.key, required this.child, this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 24)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
