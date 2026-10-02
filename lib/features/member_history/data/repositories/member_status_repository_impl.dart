import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/member_status.dart';
import '../../domain/repositories/member_status_repository.dart';
import '../datasources/member_status_remote_data_source.dart';

class MemberStatusRepositoryImpl implements MemberStatusRepository {
  final MemberStatusRemoteDataSource remoteDataSource;
  MemberStatusRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, MemberStatus>> getMyStatus(int groupId) async {
    try {
      final status = await remoteDataSource.getMyStatus(groupId);
      return Right(status);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
