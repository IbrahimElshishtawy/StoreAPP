import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/domain/usecases/seller_usecases.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  final GetSellerStatsUseCase getSellerStatsUseCase;
  final AddProductUseCase addProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;
  final PromoteProductUseCase promoteProductUseCase;

  SellerBloc({
    required this.getSellerStatsUseCase,
    required this.addProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
    required this.promoteProductUseCase,
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
      final result = await addProductUseCase(event.product, event.imageFile);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Product added successfully')),
      );
    });

    on<UpdateProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await updateProductUseCase(event.product, event.imageFile);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Product updated successfully')),
      );
    });

    on<DeleteProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await deleteProductUseCase(event.productId);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Product deleted successfully')),
      );
    });

    on<PromoteProductRequested>((event, emit) async {
      emit(SellerLoading());
      final result = await promoteProductUseCase(event.productId);
      result.fold(
        (failure) => emit(SellerError(failure.message)),
        (_) => emit(SellerActionSuccess('Product promoted successfully')),
      );
    });
  }
}
