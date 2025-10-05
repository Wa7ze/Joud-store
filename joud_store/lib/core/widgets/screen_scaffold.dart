import 'package:flutter/material.dart';

class ScreenScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;

  const ScreenScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}
