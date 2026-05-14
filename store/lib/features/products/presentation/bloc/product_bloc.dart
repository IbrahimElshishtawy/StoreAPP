import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/domain/usecases/product_usecases.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;
  final GetProductsByCategoryUseCase getProductsByCategoryUseCase;
  List<ProductEntity> _allProducts = [];

  ProductBloc({
    required this.getProductsUseCase,
    required this.getProductsByCategoryUseCase,
  }) : super(ProductInitial()) {
    on<GetProductsRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductsUseCase();
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) {
          _allProducts = products;
          if (products.isEmpty) {
            emit(ProductEmpty());
          } else {
            emit(ProductLoaded(products));
          }
        },
      );
    });

    on<SearchProductsRequested>((event, emit) async {
      if (_allProducts.isEmpty) {
        final result = await getProductsUseCase();
        result.fold((_) => {}, (products) => _allProducts = products);
      }

      final filtered = _allProducts.where((p) {
        final matchQuery = p.title.toLowerCase().contains(event.query.toLowerCase());
        final matchCategory = event.category == null || p.category == event.category;
        final matchMinPrice = event.minPrice == null || p.price >= event.minPrice!;
        final matchMaxPrice = event.maxPrice == null || p.price <= event.maxPrice!;
        final matchRating = event.minRating == null || p.rating >= event.minRating!;

        return matchQuery && matchCategory && matchMinPrice && matchMaxPrice && matchRating;
      }).toList();

      if (filtered.isEmpty) {
        emit(ProductEmpty());
      } else {
        emit(ProductLoaded(filtered));
      }
    });

    on<GetProductsByCategoryRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await getProductsByCategoryUseCase(event.category);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) =>
            products.isEmpty ? emit(ProductEmpty()) : emit(ProductLoaded(products)),
      );
    });
  }
}
