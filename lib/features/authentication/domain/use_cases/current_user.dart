import 'package:blog_app_clean_architecture/core/common/entities/user.dart';
import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/core/use_case/use_case.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class CurrentUser implements UseCase<User, NoParams> {
  final IAuthRepository iAuthRepository;

  CurrentUser(this.iAuthRepository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await iAuthRepository.currentUser();
  }
}
