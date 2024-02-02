import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:tezlapen_v2/utils/utils.dart';
import 'package:vrouter/vrouter.dart';

class EmailFormPage extends StatefulWidget {
  const EmailFormPage({super.key});

  @override
  State<EmailFormPage> createState() => _EmailFormPageState();
}

class _EmailFormPageState extends State<EmailFormPage> {
  final emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.red,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(color: Colors.white),
                        constraints: const BoxConstraints(maxWidth: 400),
                        hintText: 'Email',
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      maximumSize: const Size(300, 50),
                      minimumSize: const Size(200, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      if (isEmail(emailController.text)) {
                        setState(() {
                          isLoading = true;
                        });
                        await AppRepository().updateEmail(emailController.text);
                        final sessionId =
                            await AppRepository().customerPaymentInfo();
                        Future.delayed(
                          const Duration(seconds: 1),
                          () {
                            context.vRouter.to('/payment/$sessionId');
                          },
                        );
                        setState(() {
                          isLoading = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Container(
                              child: const Text('Invalid email'),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
