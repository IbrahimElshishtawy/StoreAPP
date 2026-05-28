import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/reviews/domain/entities/review.dart';
import 'package:store/features/reviews/domain/repositories/review_repository.dart';

class GetProductReviewsUseCase {
  final ReviewRepository repository;
  GetProductReviewsUseCase(this.repository);
  Future<Either<Failure, List<Review>>> call(String productId) =>
      repository.getProductReviews(productId);
}

class AddReviewUseCase {
  final ReviewRepository repository;
  AddReviewUseCase(this.repository);
  Future<Either<Failure, void>> call(Review review) =>
      repository.addReview(review);
}
