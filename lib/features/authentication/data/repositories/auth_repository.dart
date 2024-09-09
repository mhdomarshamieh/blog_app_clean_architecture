import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:blog_app_clean_architecture/core/error/exceptions.dart';
import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepository implements IAuthRepository {
  final IAuthRemoteDataSource remoteDataSource;

  const AuthRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signupWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<User> Function() fn) async {
    try {
      final user = await fn();

      return right(user);
    } on sb.AuthException catch (e) {
      return left(
        Failure(e.message),
      );
    } on ServerException catch (e) {
      return left(
        Failure(e.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUserData();

      if (user == null) {
        return left(
          Failure('User is not logged in!'),
        );
      }

      return right(user);
    } on ServerException catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }
}
