import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/contribution.dart';

abstract class ContributionRepository {
  Future<Either<Failure, Contribution>> logContribution({
    required int roundId,
    required int memberId,
    required double amount,
    required String status,
  });
  Future<Either<Failure, void>> closeRound(int roundId);
}

class LogContributionUseCase {
  final ContributionRepository repository;
  LogContributionUseCase(this.repository);

  Future<Either<Failure, Contribution>> call({
    required int roundId,
    required int memberId,
    required double amount,
    required String status,
  }) {
    return repository.logContribution(
      roundId: roundId,
      memberId: memberId,
      amount: amount,
      status: status,
    );
  }
}

class CloseRoundUseCase {
  final ContributionRepository repository;
  CloseRoundUseCase(this.repository);

  Future<Either<Failure, void>> call(int roundId) {
    return repository.closeRound(roundId);
  }
}
