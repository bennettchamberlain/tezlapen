import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tezlapen_v2/src/model/paid_user.dart';
import 'package:tezlapen_v2/src/model/product_model.dart';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:tezlapen_v2/src/model/payment_response.dart';

class AppRepository {
  /// {@macro studios_repository}

  AppRepository();

  Future<bool> doesUIDExistInCollection(String targetUID) async {
    // Replace 'users' and 'boughtProducts' with your actual collection names
    final usersCollection = await FirebaseFirestore.instance
        .collection('users')
        .doc(targetUID)
        .get();

    if (usersCollection.exists) {
      return PaidUser.fromMap(usersCollection.data()!).boughtProduct;
    } else {
      return false;
    }
  }

  Future<void> addUidToPaidUsersCollection() async {
    final paidUser = PaidUser(
      userUuid: FirebaseAuth.instance.currentUser!.uid,
      boughtProduct: true,
      createdAt: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(paidUser.userUuid)
        .set(
          paidUser.toMap(),
          SetOptions(merge: true),
        );
  }

  Future<Product> getProductInfo() async {
    final collectionRef = await FirebaseFirestore.instance
        .collection('product')
        .doc('product1')
        .get();
    //final documentRef = collectionRef.doc('product1');
    // Get the document with the given product name
    // final documentSnapshot = await documentRef.get();

    // Check if the document exists
    if (collectionRef.exists) {
      return Product.fromMap(
        collectionRef.data()!,
      );
    } else {
      // Document does not exist
      print(
        'Document with product name "${collectionRef.data()!['productName']}" does not exist.',
      );
      return Product.fromMap(
        collectionRef.data()!,
      );
    }
  }

  Future<bool> uploadProductUrlToFirestore(
    String dataName,
    String dataValue,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('product')
          .doc('product1')
          .set(
        {
          dataName: dataValue,
        },
        SetOptions(merge: true),
      );
      return true;
    } catch (e) {
      print('there was an error: $e');
      return false;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> checkOutSessionStream({
    required String checkoutSessionId,
  }) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .collection('checkout_sessions')
        .doc(checkoutSessionId)
        .snapshots();
  }

  Future<void> updateEmail(String email) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(userId)
        .update({
      'email': email,
    });
  }

  /// returns checkoutsessionId
  Future<String> customerPaymentInfo() async {
    final firestore = FirebaseFirestore.instance;
    //get the products from cloud firestore
    final getProduct = await firestore.collection('products').get();
    // used the product id to get fetch  the price, the reason for this 2 api call is you can add
    //products to allow customers to pay without touching the code
    final price = await FirebaseFirestore.instance
        .collection('products')
        .doc(getProduct.docs.first.id)
        .collection('prices')
        .where('active', isEqualTo: true)
        .limit(1)
        .get();
    final docRef = await firestore
        .collection('customers')
        .doc(
          FirebaseAuth.instance.currentUser?.uid,
        )
        .collection('checkout_sessions')
        .add({
      'client': 'web',
      'mode': 'payment',
      'price': price.docs.first.id,
      'success_url': 'https://tezlapen.com/successpayment/',
      'cancel_url': 'https://tezlapen.com/',
    });
    return docRef.id;
  }

  Future<PaymentResponse> payPalPayment(double amount) async {
    final clientID = dotenv.get('clientID');
    final clientSecret = dotenv.get('clientSecret');

    final credentials = base64Encode(utf8.encode('$clientID:$clientSecret'));
    try {
      final response = await http.post(
        Uri.parse('https://api.sandbox.paypal.com/v1/payments/payment'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $credentials',
        },
        body: jsonEncode(
          {
            'intent': 'sale',
            'payer': {
              'payment_method': 'paypal',
            },
            'transactions': [
              {
                'amount': {
                  'total': amount,
                  'currency': 'USD',
                },
              },
            ],
            'redirect_urls': {
              'return_url': 'https://tezlapen.com/successpayment/',
              'cancel_url': 'https://tezlapen.com/',
            },
          },
        ),
      );
      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final approvalUrl = responseData['links']
                .firstWhere((link) => link['rel'] == 'approval_url')['href']
            as String;
        return PaymentResponse(
          isSuccess: true,
          message: approvalUrl,
        );
      } else {
        return PaymentResponse(
          isSuccess: false,
          message: 'Error ${response.body}',
        );
      }
    } catch (e) {
      return PaymentResponse(
        isSuccess: false,
        message: 'Error $e',
      );
    }
  }
}
