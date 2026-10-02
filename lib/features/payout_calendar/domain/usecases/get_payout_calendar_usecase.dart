import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../group_dashboard/domain/entities/dashboard_entities.dart';
import '../../../group_dashboard/domain/repositories/dashboard_repository.dart';

class GetPayoutCalendarUseCase {
  final DashboardRepository repository;
  GetPayoutCalendarUseCase(this.repository);

  Future<Either<Failure, List<EkubRound>>> call(int groupId) {
    return repository.getGroupRounds(groupId);
  }
}
