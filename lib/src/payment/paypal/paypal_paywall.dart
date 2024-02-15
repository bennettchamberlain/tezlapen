import 'package:flutter/material.dart';
import 'dart:html' as html;

class PayPalPayWall extends StatefulWidget {
  const PayPalPayWall({required this.url, super.key});
  final String url;

  @override
  State<PayPalPayWall> createState() => _PayPalPayWallState();
}

class _PayPalPayWallState extends State<PayPalPayWall> {
  @override
  Widget build(BuildContext context) {
    html.window.location.href = widget.url;
    return const Scaffold(
      body: SizedBox(),
    );
  }
}
