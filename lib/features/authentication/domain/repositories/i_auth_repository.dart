import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IAuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> currentUser();
}
