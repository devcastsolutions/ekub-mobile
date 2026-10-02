import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, List<Group>>> getMyGroups();
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required double contributionAmount,
    required String frequency,
    required String startDate,
  });
  Future<Either<Failure, void>> startGroup(int groupId, bool randomize);
}
