part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class GetProductInfoEvent extends ProductEvent {
  GetProductInfoEvent({required this.videoIndex});
  final int videoIndex;
}

class UploadUrlToFirestoreEvent extends ProductEvent {
  UploadUrlToFirestoreEvent({
    required this.dataName,
    required this.dataValue,
  });

  final String dataName;
  final String dataValue;
}

class UploadProductToFirestoreEvent extends ProductEvent {
  UploadProductToFirestoreEvent({required this.product});

  final Product product;
}
