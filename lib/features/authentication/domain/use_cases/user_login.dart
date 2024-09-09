import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/core/use_case/use_case.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogin implements UseCase<User, UserLoginParams> {
  final IAuthRepository iAuthRepository;

  const UserLogin(this.iAuthRepository);

  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    return await iAuthRepository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class UserLoginParams {
  final String email;
  final String password;

  UserLoginParams({required this.email, required this.password});
}
