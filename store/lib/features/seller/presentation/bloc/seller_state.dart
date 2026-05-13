import 'package:store/features/seller/domain/entities/seller_stats.dart';

abstract class SellerState {}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerStatsLoaded extends SellerState {
  final SellerStats stats;
  SellerStatsLoaded(this.stats);
}

class SellerError extends SellerState {
  final String message;
  SellerError(this.message);
}

class SellerActionSuccess extends SellerState {
  final String message;
  SellerActionSuccess(this.message);
}
