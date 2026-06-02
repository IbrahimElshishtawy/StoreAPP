import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store/features/reviews/data/models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getReviews(String productId);
  Future<void> addReview(ReviewModel review);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<ReviewModel>> getReviews(String productId) async {
    final querySnapshot = await firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ReviewModel.fromJson({...doc.data(), 'id': doc.id}))
        .toList();
  }

  @override
  Future<void> addReview(ReviewModel review) async {
    await firestore.collection('reviews').doc(review.id).set(review.toJson());
  }
}
