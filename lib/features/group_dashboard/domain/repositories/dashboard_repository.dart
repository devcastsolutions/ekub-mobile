import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dashboard_entities.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<EkubRound>>> getGroupRounds(int groupId);
}

class GetDashboardDataUseCase {
  final DashboardRepository repository;
  GetDashboardDataUseCase(this.repository);

  Future<Either<Failure, List<EkubRound>>> call(int groupId) {
    return repository.getGroupRounds(groupId);
  }
}
