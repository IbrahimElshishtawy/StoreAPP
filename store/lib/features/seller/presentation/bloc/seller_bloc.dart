import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/usecases/get_seller_stats.dart';
import 'package:store/features/seller/domain/usecases/upload_product.dart';
import 'package:store/features/seller/domain/usecases/create_ad.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final GetSellerStats getSellerStats;
  final UploadProduct uploadProduct;
  final CreateAd createAd;

  SellerBloc({
    required this.getSellerStats,
    required this.uploadProduct,
    required this.createAd,
  }) : super(SellerInitial()) {
    on<GetSellerStatsRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await getSellerStats();
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (stats) => emit(SellerStatsLoaded(stats)),
      );
    });

    on<UploadProductRequested>((event, emit) async {
      emit(SellerLoading());
      final product = ProductEntity(
        id: '',
        title: event.title,
        category: event.category,
        price: event.price,
        description: event.description,
        image: event.image,
      );
      final result = await uploadProduct(product);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Product uploaded successfully')),
      );
    });

    on<CreateAdRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await createAd(event.productId, event.budget);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Advertisement created successfully')),
      );
    });
  }
}
