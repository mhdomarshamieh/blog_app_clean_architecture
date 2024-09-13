import 'package:blog_app_clean_architecture/core/widgets/error.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/pages/login_page.dart';
import 'package:blog_app_clean_architecture/features/authentication/presentation/pages/signup_page.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/blog_viewer_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
      );
    case SignupPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );
    case BlogPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
    case BlogViewerPage.routeName:
      final blog = settings.arguments as Blog;
      return MaterialPageRoute(
        builder: (context) => BlogViewerPage(blog: blog),
      );
    case AddNewBlogPage.routeName:
      return MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(title: "This Page Doesn't Exist"),
        ),
      );
  }
}
