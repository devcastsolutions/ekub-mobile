import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';
import '../repositories/group_repository.dart';

class GetMyGroupsUseCase {
  final GroupRepository repository;
  GetMyGroupsUseCase(this.repository);

  Future<Either<Failure, List<Group>>> call() {
    return repository.getMyGroups();
  }
}

class CreateGroupUseCase {
  final GroupRepository repository;
  CreateGroupUseCase(this.repository);

  Future<Either<Failure, Group>> call({
    required String name,
    required double contributionAmount,
    required String frequency,
    required String startDate,
  }) {
    return repository.createGroup(
      name: name,
      contributionAmount: contributionAmount,
      frequency: frequency,
      startDate: startDate,
    );
  }
}

class StartGroupUseCase {
  final GroupRepository repository;
  StartGroupUseCase(this.repository);

  Future<Either<Failure, void>> call(int groupId, bool randomize) {
    return repository.startGroup(groupId, randomize);
  }
}
