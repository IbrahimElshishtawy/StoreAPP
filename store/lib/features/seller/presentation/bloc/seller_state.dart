abstract class SellerState {}

class SellerInitial extends SellerState {}

class SellerLoading extends SellerState {}

class SellerStatsLoaded extends SellerState {}

class SellerError extends SellerState {
  final String message;
  SellerError(this.message);
}
