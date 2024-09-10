import 'dart:io';

import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/core/use_case/use_case.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/repositories/i_blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final IBlogRepository blogRepository;

  UploadBlog(this.blogRepository);

  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
