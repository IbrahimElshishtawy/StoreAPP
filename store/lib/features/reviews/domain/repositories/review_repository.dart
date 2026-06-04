import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/reviews/domain/entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, List<Review>>> getProductReviews(String productId);
  Future<Either<Failure, void>> addReview(Review review);
}
