import 'dart:io';

import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class IBlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });

  Future<Either<Failure, List<Blog>>> getAllBlogs();
}
