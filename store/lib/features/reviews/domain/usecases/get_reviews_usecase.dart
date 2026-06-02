import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/reviews/domain/entities/review_entity.dart';
import 'package:store/features/reviews/domain/repositories/review_repository.dart';

class GetReviewsUseCase {
  final ReviewRepository repository;

  GetReviewsUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call(String productId) async {
    return await repository.getReviews(productId);
  }
}
