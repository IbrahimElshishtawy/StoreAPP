abstract class SellerEvent {}

class GetSellerStatsRequested extends SellerEvent {}

class UploadProductRequested extends SellerEvent {
  final Map<String, dynamic> productData;
  UploadProductRequested(this.productData);
}
