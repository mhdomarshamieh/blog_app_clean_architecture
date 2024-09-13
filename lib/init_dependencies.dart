import 'package:blog_app_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_architecture/core/network/connection_checker.dart';
import 'package:blog_app_clean_architecture/core/secrets/app_secrets.dart';
import 'package:blog_app_clean_architecture/features/authentication/data/data_sources/auth_remote_data_source.dart';
import 'package:blog_app_clean_architecture/features/authentication/data/repositories/auth_repository.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/repositories/i_auth_repository.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/current_user.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/user_login.dart';
import 'package:blog_app_clean_architecture/features/authentication/domain/use_cases/user_sign_up.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_architecture/features/blog/data/data_sources/blog_local_data_source.dart';
import 'package:blog_app_clean_architecture/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_architecture/features/blog/data/repositories/blog_repository.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/repositories/i_blog_repository.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/use_cases/get_all_blogs.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/use_cases/upload_blog.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;
  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'blogs'),
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory(
    () => InternetConnection(),
  );
  serviceLocator.registerFactory<IConnectionChecker>(
    () => ConnectionChecker(
      serviceLocator(),
    ),
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

void _initBlog() {
  serviceLocator
    ..registerFactory<IBlogRemoteDataSource>(
      () => BlogRemoteDataSource(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<IBlogLocalDataSource>(
      () => BlogLocalDataSource(
        serviceLocator(),
      ),
    )
    ..registerFactory<IBlogRepository>(
      () => BlogRepository(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadBlog(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
