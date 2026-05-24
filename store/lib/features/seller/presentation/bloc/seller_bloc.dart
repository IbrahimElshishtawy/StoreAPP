import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/domain/usecases/get_seller_stats_usecase.dart';
import 'package:store/features/seller/domain/usecases/seller_usecases.dart';
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
      final result = await getSellerStatsUseCase();
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (stats) => emit(SellerStatsLoaded(stats)),
      );
    });

    on<AddProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await addProductUseCase(event.product);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerInitial()), // Or a success state
      );
    });

    on<UpdateProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await updateProductUseCase(event.product);
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
  }
}
