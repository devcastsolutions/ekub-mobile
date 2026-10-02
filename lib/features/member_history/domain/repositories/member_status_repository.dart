import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/member_status.dart';

abstract class MemberStatusRepository {
  Future<Either<Failure, MemberStatus>> getMyStatus(int groupId);
}

class GetMyStatusUseCase {
  final MemberStatusRepository repository;
  GetMyStatusUseCase(this.repository);

  Future<Either<Failure, MemberStatus>> call(int groupId) {
    return repository.getMyStatus(groupId);
  }
}
