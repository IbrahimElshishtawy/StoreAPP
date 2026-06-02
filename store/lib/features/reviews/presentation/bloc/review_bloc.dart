import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/reviews/domain/usecases/add_review_usecase.dart';
import 'package:store/features/reviews/domain/usecases/get_reviews_usecase.dart';
import 'package:store/features/reviews/presentation/bloc/review_event.dart';
import 'package:store/features/reviews/presentation/bloc/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final GetReviewsUseCase getReviewsUseCase;
  final AddReviewUseCase addReviewUseCase;

  ReviewBloc({
    required this.getReviewsUseCase,
    required this.addReviewUseCase,
  }) : super(ReviewInitial()) {
    on<GetReviewsRequested>((event, emit) async {
      emit(ReviewLoading());
      final result = await getReviewsUseCase(event.productId);
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
        (_) => emit(ReviewAddedSuccess()),
      );
    });
  }
}
