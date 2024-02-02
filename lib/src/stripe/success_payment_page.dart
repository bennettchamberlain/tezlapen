import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:vrouter/vrouter.dart';

class SuccessPayment extends StatefulWidget {
  const SuccessPayment({super.key});

  @override
  State<SuccessPayment> createState() => _SuccessPaymentState();
}

class _SuccessPaymentState extends State<SuccessPayment> {
  final confettiController = ConfettiController();

  bool isPaid = false;
  @override
  void initState() {
    addUserToPaidCollection();
    confettiController.play();
    Future.delayed(const Duration(seconds: 2), () {
      successDialog(context);
    });
    super.initState();
  }

  Future<void> addUserToPaidCollection() async {
    try {
      await AppRepository().addUidToPaidUsersCollection();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Scaffold(
          body: Center(),
        ),
        ConfettiWidget(
          maximumSize: const Size(50, 50),
          confettiController: confettiController,
          blastDirection: -pi / 2,
          blastDirectionality: BlastDirectionality.explosive,
        ),
      ],
    );
  }
}

Future<void> successDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Congratulation🎉🎉'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                "You've just unlocked our marketplace of Tesla related products!",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Done'),
            onPressed: () {
              context.vRouter.to('/');
            },
          ),
        ],
      );
    },
  );
}
