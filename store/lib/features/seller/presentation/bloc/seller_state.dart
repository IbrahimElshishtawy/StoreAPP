import 'package:store/features/products/domain/entities/product_entity.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';

abstract class SellerState {}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerStatsLoaded extends SellerState {
  final SellerStats stats;
  SellerStatsLoaded(this.stats);
}

class SellerProductActionSuccess extends SellerState {
  final String message;
  SellerProductActionSuccess(this.message);
}

class SellerError extends SellerState {
  final String message;
  SellerError(this.message);
}
