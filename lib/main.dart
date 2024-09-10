import 'package:blog_app_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_architecture/core/theme/app_theme.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/pages/login_page.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_clean_architecture/init_dependencies.dart';
import 'package:blog_app_clean_architecture/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => serviceLocator<AppUserCubit>(),
        ),
        BlocProvider(create: (_) => serviceLocator<BlogBloc>())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) => state is AppUserLoggedIn,
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const BlogPage();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
