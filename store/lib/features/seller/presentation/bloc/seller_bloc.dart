import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  SellerBloc() : super(SellerInitial()) {
    on<GetSellerStatsRequested>((event, emit) async {
      emit(SellerLoading());
      // Mock stats
      await Future.delayed(const Duration(seconds: 1));
      emit(SellerStatsLoaded(SellerStats(
        totalSales: 12500.0,
        totalOrders: 45,
        dailySales: [100, 200, 150, 300, 250, 400, 350],
        totalProfit: 4500.0,
        bestSellingProducts: [
          BestSellingProduct(title: "Product A", salesCount: 20, revenue: 2000),
          BestSellingProduct(title: "Product B", salesCount: 15, revenue: 1500),
        ],
        customerBehavior: CustomerBehavior(
          visits: 1000,
          conversions: 45,
          favoriteCategories: ["Electronics", "Clothing"],
        ),
      )));
    });

    on<AddProductRequested>((event, emit) async {
      emit(SellerLoading());
      // Add product logic
      await Future.delayed(const Duration(seconds: 1));
      // Emit stats loaded to satisfy the listener in UploadProductPage for mock purpose
      add(GetSellerStatsRequested());
    });

    on<UpdateProductRequested>((event, emit) async {
       emit(SellerLoading());
      // Update product logic
      await Future.delayed(const Duration(seconds: 1));
      emit(SellerInitial());
    });

    on<DeleteProductRequested>((event, emit) async {
       emit(SellerLoading());
      // Delete product logic
      await Future.delayed(const Duration(seconds: 1));
      emit(SellerInitial());
    });
  }
}
