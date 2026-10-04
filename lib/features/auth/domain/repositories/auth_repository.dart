import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login(String email, String password);
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String role,
  });
  Future<Either<Failure, String>> googleSignIn();
}
