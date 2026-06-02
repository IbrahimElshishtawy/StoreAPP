import 'package:store/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewEvent {}

class GetReviewsRequested extends ReviewEvent {
  final String productId;
  GetReviewsRequested(this.productId);
}

class AddReviewRequested extends ReviewEvent {
  final ReviewEntity review;
  AddReviewRequested(this.review);
}
