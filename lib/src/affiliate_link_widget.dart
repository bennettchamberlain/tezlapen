import 'package:flutter/material.dart';

class AffiliateLinkWidget extends StatefulWidget {
  const AffiliateLinkWidget({super.key});

  @override
  State<AffiliateLinkWidget> createState() => _AffiliateLinkWidgetState();
}

class _AffiliateLinkWidgetState extends State<AffiliateLinkWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100,
      child: const Text('Affiliate programm'),
    );
  }
}
