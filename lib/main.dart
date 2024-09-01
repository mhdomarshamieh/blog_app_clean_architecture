import 'package:blog_app_clean_architecture/core/core/app_secrets.dart';
import 'package:blog_app_clean_architecture/core/theme/app_theme.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/pages/login_page.dart';
import 'package:blog_app_clean_architecture/router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      theme: AppTheme.darkThemeMode,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const LoginPage(),
    );
  }
}
