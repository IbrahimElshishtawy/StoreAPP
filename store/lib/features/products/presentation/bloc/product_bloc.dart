import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/products/domain/repositories/product_repository.dart';
import 'package:store/features/products/presentation/bloc/product_event.dart';
import 'package:store/features/products/presentation/bloc/product_state.dart';
import 'package:store/features/products/domain/entities/product_entity.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  List<ProductEntity> _allProducts = [];

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<GetProductsRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await repository.getProducts();
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) {
          _allProducts = products;
          emit(ProductLoaded(products));
        },
      );
    });

    on<SearchProductsRequested>((event, emit) async {
      if (_allProducts.isEmpty) {
         final result = await repository.getProducts();
         result.fold((_)=>{}, (products) => _allProducts = products);
      }

      final filtered = _allProducts.where((p) {
        final matchQuery = p.title.toLowerCase().contains(event.query.toLowerCase());
        // Add more filters if needed
        return matchQuery;
      }).toList();

      emit(ProductLoaded(filtered));
    });

    on<GetProductsByCategoryRequested>((event, emit) async {
      emit(ProductLoading());
      final result = await repository.getProductsByCategory(event.category);
      result.fold(
        (failure) => emit(ProductError(failure.message)),
        (products) => emit(ProductLoaded(products)),
      );
    });
  }
}
