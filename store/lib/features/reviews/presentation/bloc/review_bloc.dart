import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/reviews/domain/usecases/review_usecases.dart';
import 'package:store/features/reviews/presentation/bloc/review_event.dart';
import 'package:store/features/reviews/presentation/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetProductReviewsUseCase getProductReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  ReviewBloc({
    required this.getProductReviewsUseCase,
    required this.addReviewUseCase,
  }) : super(ReviewInitial()) {
    on<GetProductReviewsRequested>((event, emit) async {
      emit(ReviewLoading());
      final result = await getProductReviewsUseCase(event.productId);
      result.fold(
        (failure) => emit(ReviewError(failure.message)),
        (reviews) => emit(ReviewsLoaded(reviews)),
      );
    });

    on<AddReviewRequested>((event, emit) async {
      emit(ReviewLoading());
      final result = await addReviewUseCase(event.review);
      result.fold(
        (failure) => emit(ReviewError(failure.message)),
        (_) => emit(ReviewActionSuccess('Review added successfully')),
      );
    });
  }
}
