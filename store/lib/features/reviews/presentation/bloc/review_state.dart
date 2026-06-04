import 'package:store/features/reviews/domain/entities/review.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<Review> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewActionSuccess extends ReviewState {
  final String message;
  ReviewActionSuccess(this.message);
}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}
