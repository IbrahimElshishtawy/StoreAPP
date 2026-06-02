import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/reviews/domain/entities/review_entity.dart';
import 'package:store/features/reviews/domain/repositories/review_repository.dart';

class AddReviewUseCase {
  final ReviewRepository repository;

  AddReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(ReviewEntity review) async {
    return await repository.addReview(review);
  }
}
