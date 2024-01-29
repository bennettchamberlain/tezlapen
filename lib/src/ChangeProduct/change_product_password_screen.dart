import 'package:flutter/material.dart';
import 'package:tezlapen_v2/src/ChangeProduct/change_product_info_screen.dart';
import 'package:vrouter/vrouter.dart';

class ChangeProductPasswordScreen extends StatefulWidget {
  const ChangeProductPasswordScreen({super.key});

  @override
  State<ChangeProductPasswordScreen> createState() =>
      _ChangeProductPasswordScreenState();
}

class _ChangeProductPasswordScreenState
    extends State<ChangeProductPasswordScreen> {
  TextEditingController passwordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  context.vRouter.to('/');
                },
                icon: const Icon(Icons.home),),
            title: const Text('For Admin Use Only'),),
        body: Column(
          children: [
            const SizedBox(height: 40),
            Center(
                child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 3,
                      color: Colors.white,
                    ),
                  ),
                ),
                controller: passwordcontroller,
              ),
            ),),
            TextButton(
                onPressed: () {
                  if (passwordcontroller.text == 'QualityControl') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangeProductInfoScreen(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Incorrect Password')),);
                  }
                },
                child: const Text('Log In'),),
          ],
        ),);
  }
}
