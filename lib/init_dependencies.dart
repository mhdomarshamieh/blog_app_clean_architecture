import 'package:blog_app_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_architecture/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_architecture/features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/features/authentication/data/repositories/auth_repository.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/current_user.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/user_login.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/user_sign_up.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<IAuthRemoteDataSource>(
    () => AuthRemoteDataSource(
      serviceLocator<SupabaseClient>(),
    ),
  );

  serviceLocator.registerFactory<IAuthRepository>(
    () => AuthRepository(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => UserLogin(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => CurrentUser(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignUp: serviceLocator(),
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(),
    ),
  );
}
