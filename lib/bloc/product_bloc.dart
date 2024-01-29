import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tezlapen_v2/app_repository.dart';
import 'package:tezlapen_v2/src/product_model.dart';
import 'package:video_player/video_player.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<GetProductInfoEvent>((event, emit) async {
      emit(ProductInitial());
      final productInfo = await AppRepository().getProductInfo();

      // if (event.videoIndex == 0) {
      emit(
        ProductInfoSuccessState(
          product: productInfo,
          video: productInfo.videoUrl,
        ),
      );
      // } else {
      //   emit(
      //     ProductInfoRebuildState(
      //       product: productInfo,
      //       video: productInfo.testimonials[event.videoIndex - 1]
      //               ['testimonialVideo']
      //           .toString(),
      //     ),
      //  );
      // }
    });

    on<UploadUrlToFirestoreEvent>((event, emit) async {
      await AppRepository().uploadProductUrlToFirestore(
        event.dataName,
        event.dataValue,
      );
      emit(UploadSuccessState());
    });
  }
}
