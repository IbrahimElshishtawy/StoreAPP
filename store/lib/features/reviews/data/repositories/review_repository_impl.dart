import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/reviews/domain/entities/review.dart';
import 'package:store/features/reviews/domain/repositories/review_repository.dart';
import 'package:store/features/reviews/data/datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Review>>> getProductReviews(String productId) async {
    try {
      final reviews = await remoteDataSource.getProductReviews(productId);
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addReview(Review review) async {
    try {
      await remoteDataSource.addReview(review);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
