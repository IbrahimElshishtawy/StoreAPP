import 'package:store/features/reviews/domain/entities/review.dart';

abstract class ReviewEvent {}

class GetProductReviewsRequested extends ReviewEvent {
  final String productId;
  GetProductReviewsRequested(this.productId);
}

class AddReviewRequested extends ReviewEvent {
  final Review review;
  AddReviewRequested(this.review);
}
