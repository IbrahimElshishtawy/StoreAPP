import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerBloc extends Bloc<SellerEvent, SellerState> {
  SellerBloc() : super(SellerInitial()) {
    on<GetSellerStatsRequested>((event, emit) async {
      emit(SellerLoading());
      try {
        // Simulated stats data
        final stats = {
          'totalSales': 15000.0,
          'ordersCount': 120,
          'topProduct': 'Classic T-Shirt',
          'salesData': [10.0, 20.0, 15.0, 30.0, 25.0, 40.0],
        };
        emit(SellerStatsLoaded(stats));
      } catch (e) {
        emit(SellerError(e.toString()));
      }
    });

    on<UploadProductRequested>((event, emit) async {
      emit(SellerLoading());
      try {
        // Logic to upload product to Firebase/API
        await Future.delayed(const Duration(seconds: 2));
        emit(SellerInitial()); // Success
      } catch (e) {
        emit(SellerError(e.toString()));
      }
    });
  }
}
