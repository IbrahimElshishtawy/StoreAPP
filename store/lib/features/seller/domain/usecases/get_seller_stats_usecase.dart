import 'package:dartz/dartz.dart';
import 'package:store/core/error/failures.dart';
import 'package:store/features/seller/domain/entities/seller_stats.dart';
import 'package:store/features/seller/domain/repositories/seller_repository.dart';

class GetSellerStatsUseCase {
  final SellerRepository repository;
  GetSellerStatsUseCase(this.repository);

  Future<Either<Failure, SellerStats>> call() async {
    return await repository.getSellerStats();
  }
}
