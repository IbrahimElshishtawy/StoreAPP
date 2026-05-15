import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/seller/presentation/bloc/seller_event.dart';
import 'package:store/features/seller/presentation/bloc/seller_state.dart';

class SellerStats {
  final double totalSales;
  final int totalOrders;
  final List<double> dailySales;

  SellerStats({
    required this.totalSales,
    required this.totalOrders,
    required this.dailySales,
  });
}

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
      )));
    });

    on<AddProductRequested>((event, emit) async {
      emit(SellerLoading());
      try {
        await FirebaseFirestore.instance.collection('products').add({
          'name': event.name,
          'description': event.description,
          'price': event.price,
          'imageUrl': event.imageUrl,
          'createdAt': Timestamp.now(),
        });
        emit(SellerInitial());
      } catch (e) {
        emit(SellerError("Failed to add product: ${e.toString()}"));
      }
    });

    on<UpdateProductRequested>((event, emit) async {
      emit(SellerLoading());
      try {
        // Update product logic
        await Future.delayed(const Duration(seconds: 1));
        emit(SellerInitial());
      } catch (e) {
        emit(SellerError("Failed to update product: ${e.toString()}"));
      }
    });

    on<DeleteProductRequested>((event, emit) async {
      emit(SellerLoading());
      try {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(event.productId)
            .delete();
        emit(SellerInitial());
      } catch (e) {
        emit(SellerError("Failed to delete product: ${e.toString()}"));
      }
    });
  }
}
