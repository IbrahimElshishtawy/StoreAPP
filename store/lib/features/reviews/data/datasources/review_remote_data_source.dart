import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/features/reviews/domain/entities/review.dart';

abstract class ReviewRemoteDataSource {
  Future<List<Review>> getProductReviews(String productId);
  Future<void> addReview(Review review);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    final snapshot = await firestore
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Review(
        id: doc.id,
        productId: productId,
        userName: data['userName'] ?? 'Anonymous',
        comment: data['comment'] ?? '',
        rating: (data['rating'] ?? 0).toDouble(),
        date: (data['date'] as Timestamp).toDate(),
      );
    }).toList();
  }

  @override
  Future<void> addReview(Review review) async {
    await firestore
        .collection('products')
        .doc(review.productId)
        .collection('reviews')
        .add({
      'userName': review.userName,
      'comment': review.comment,
      'rating': review.rating,
      'date': FieldValue.serverTimestamp(),
    });
  }
}
