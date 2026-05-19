import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/domain/usecases/add_product_usecase.dart';
import 'package:store/features/seller/domain/usecases/delete_product_usecase.dart';
import 'package:store/features/seller/domain/usecases/get_seller_stats_usecase.dart';
import 'package:store/features/seller/domain/usecases/update_product_usecase.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final GetSellerStatsUseCase getSellerStatsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  SellerBloc({
    required this.getSellerStatsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  }) : super(SellerInitial()) {
    on<GetSellerStatsRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await getSellerStatsUseCase(event.sellerId);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (stats) => emit(SellerStatsLoaded(stats)),
      );
    });

    on<AddProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await addProductUseCase(event.product, event.imageFile);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerInitial()), // or Success state
      );
    });

    on<UpdateProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await updateProductUseCase(event.product, event.imageFile);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerInitial()),
      );
    });

    on<DeleteProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await deleteProductUseCase(event.productId);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerInitial()),
      );
    });

    on<CreatePromotionRequested>((event, emit) async {
      emit(SellerLoading());
      // Simulation of creating a promotion
      await Future.delayed(const Duration(seconds: 1));
      emit(SellerInitial()); // or a specific success state
    });
  }
}
