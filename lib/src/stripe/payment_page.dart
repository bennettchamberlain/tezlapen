import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:vrouter/vrouter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
   
    super.key,
  });


  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {


  @override
  Widget build(BuildContext context) {
    final sessionId = context.vRouter.pathParameters['sessionId'];

    return Scaffold(
      body: Center(
        child:
         StreamBuilder(
          stream: AppRepository().checkOutSessionStream(
            checkoutSessionId:sessionId!,
          ),
          builder: (
            BuildContext context,
            snapshot,
          ) {
            if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.hasData == false) {
              return const Text('Something went wrong');
            }
            final data = snapshot.requireData.data()!;
            if (data.containsKey('sessionId') && data.containsKey('url')) {
              html.window.location.href = data['url'] as String;
              return const SizedBox();
            } else if (data.containsKey('error')) {
              return Text(
                data['error']['message'] as String? ??
                    'Error processing payment.',
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
