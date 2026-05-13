import 'package:flutter_bloc/flutter_bloc.dart';
import 'seller_event.dart';
import 'seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  SellerBloc() : super(SellerInitial()) {
    on<GetSellerStatsRequested>((event, emit) async {
      emit(SellerLoading());
      await Future.delayed(const Duration(seconds: 1));
      final stats = SellerStats(
        totalSales: 1540.50,
        totalOrders: 42,
        dailySales: [120, 150, 80, 200, 170, 250, 310],
      );
      emit(SellerStatsLoaded(stats));
    });

    on<UploadProductRequested>((event, emit) async {
      emit(SellerLoading());
      await Future.delayed(const Duration(seconds: 1));
      emit(SellerProductUploaded());
    });
  }
}
