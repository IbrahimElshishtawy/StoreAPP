import 'package:store/features/reviews/domain/entities/review.dart';

abstract class ReviewRemoteDataSource {
  Future<List<Review>> getProductReviews(String productId);
  Future<void> addReview(Review review);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  @override
  Future<List<Review>> getProductReviews(String productId) async {
    // Mock reviews
    return [
      Review(
        id: '1',
        productId: productId,
        userName: 'John Doe',
        comment: 'Great product!',
        rating: 5.0,
        date: DateTime.now(),
      ),
      Review(
        id: '2',
        productId: productId,
        userName: 'Jane Smith',
        comment: 'Satisfied with the quality.',
        rating: 4.0,
        date: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> addReview(Review review) async {
    // Implement Firestore logic
  }
}
