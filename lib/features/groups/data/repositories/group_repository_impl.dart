import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_remote_data_source.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupRemoteDataSource remoteDataSource;

  GroupRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Group>>> getMyGroups() async {
    try {
      final groups = await remoteDataSource.getMyGroups();
      return Right(groups);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required double contributionAmount,
    required String frequency,
    required String startDate,
  }) async {
    try {
      final group = await remoteDataSource.createGroup(
        name: name,
        contributionAmount: contributionAmount,
        frequency: frequency,
        startDate: startDate,
      );
      return Right(group);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> startGroup(int groupId, bool randomize) async {
    try {
      await remoteDataSource.startGroup(groupId, randomize);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
