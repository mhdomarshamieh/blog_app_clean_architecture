import 'dart:io';

import 'package:blog_app_clean_architecture/core/error/exceptions.dart';
import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/features/blog/data/data_sources/blog_remote_data_source.dart';
import 'package:blog_app_clean_architecture/features/blog/data/models/blog_model.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/repositories/i_blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepository implements IBlogRepository {
  final IBlogRemoteDataSource blogRemoteDataSource;

  BlogRepository(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blog: blogModel);

      blogModel = blogModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSource.getAllBlogs();
      return right(blogs);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
