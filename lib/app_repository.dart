import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tezlapen_v2/src/product_model.dart';

class AppRepository {
  /// {@macro studios_repository}

  AppRepository();

  Future<bool> doesUIDExistInCollection(String targetUID) async {
    // Replace 'users' and 'boughtProducts' with your actual collection names
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    final docSnapshot = await usersCollection.doc(targetUID).get();

    return docSnapshot['boughtProducts'] as bool;
  }

  Future<void> AddUidToUsersCollection(String targetUID) async {
    await FirebaseFirestore.instance.collection('users').doc(targetUID).set(
      {'boughtProduct': true},
      SetOptions(merge: true),
    );
  }

  Future<Product> getProductInfo() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('product');
    final documentRef = collectionRef.doc('product1');
    // Get the document with the given product name
    final documentSnapshot = await documentRef.get();

    // Check if the document exists
    if (documentSnapshot.exists) {
      return Product(
        productName: documentSnapshot['productName'].toString(),
        videoUrl: documentSnapshot['videoUrl'].toString(),
        description: documentSnapshot['description'].toString(),
        testimonials: documentSnapshot['testimonials'] as List<dynamic>,
        affiliateProducts: documentSnapshot['affiliate'] as List<dynamic>,
        price: documentSnapshot['price'] as double,
      );
    } else {
      // Document does not exist
      print(
        'Document with product name "${documentSnapshot['productName']}" does not exist.',
      );
      return Product(
        productName: documentSnapshot['productName'].toString(),
        videoUrl: documentSnapshot['videoUrl'].toString(),
        description: documentSnapshot['description'].toString(),
        testimonials:
            documentSnapshot['testimonials'] as List<Map<String, String>>,
        affiliateProducts:
            documentSnapshot['affiliate'] as List<Map<String, String>>,
        price: documentSnapshot['price'] as double,
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
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('checkout_sessions')
        .add({
      'client': 'web',
      'mode': 'payment',
      'price': price.docs.first.id,
      'success_url': 'http://localhost:57608/',
      'cancel_url': 'http://localhost:57608/my-product',
    });
    return docRef.id;
  }
}
