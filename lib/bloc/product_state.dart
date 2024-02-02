part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class UploadSuccessState extends ProductState {}

final class ProductInfoSuccessState extends ProductState {
  ProductInfoSuccessState({required this.product, required this.video});
  final Product product;
  final String video;
}

final class ProductInfoRebuildState extends ProductState {
  ProductInfoRebuildState({required this.product, required this.video});
  final Product product;
  final String video;
}


