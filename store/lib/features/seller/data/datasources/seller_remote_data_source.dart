import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/core/network/dio_client.dart';
import 'package:store/features/products/data/models/product_model.dart';

abstract class SellerRemoteDataSource {
  Future<void> uploadProduct(ProductModel product);
  Future<void> createAd(String productId, double budget);
  Future<SellerStats> getSalesReport();
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final DioClient dioClient;
  SellerRemoteDataSourceImpl(this.dioClient);

  @override
  Future<void> uploadProduct(ProductModel product) async {
    await dioClient.dio.post('/products', data: product.toJson());
  }

  @override
  Future<void> createAd(String productId, double budget) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<SellerStats> getSalesReport() async {
    return SellerStats(
      totalSales: 15000.0,
      ordersCount: 120,
      dailySales: [
        DailySales(date: DateTime.parse('2023-10-01'), amount: 1200.0),
        DailySales(date: DateTime.parse('2023-10-02'), amount: 1500.0),
        DailySales(date: DateTime.parse('2023-10-03'), amount: 1100.0),
      ],
    );
  }
}
