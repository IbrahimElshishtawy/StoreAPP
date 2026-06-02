import 'package:store/features/reviews/domain/entities/review_entity.dart';

abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewsLoaded extends ReviewState {
  final List<ReviewEntity> reviews;
  ReviewsLoaded(this.reviews);
}

class ReviewAddedSuccess extends ReviewState {}

class ReviewError extends ReviewState {
  final String message;
  ReviewError(this.message);
}
