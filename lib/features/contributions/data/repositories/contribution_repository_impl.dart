import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/contribution.dart';
import '../../domain/repositories/contribution_repository.dart';
import '../datasources/contribution_remote_data_source.dart';

class ContributionRepositoryImpl implements ContributionRepository {
  final ContributionRemoteDataSource remoteDataSource;
  ContributionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, Contribution>> logContribution({
    required int roundId,
    required int memberId,
    required double amount,
    required String status,
  }) async {
    try {
      final contrib = await remoteDataSource.logContribution(
        roundId: roundId,
        memberId: memberId,
        amount: amount,
        status: status,
      );
      return Right(contrib);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> closeRound(int roundId) async {
    try {
      await remoteDataSource.closeRound(roundId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
