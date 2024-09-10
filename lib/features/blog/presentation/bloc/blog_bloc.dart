import 'dart:io';

import 'package:blog_app_clean_architecture/core/use_case/use_case.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/use_cases/get_all_blogs.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/use_cases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({
    required UploadBlog uploadBlog,
    required GetAllBlogs getAllBlogs,
  })  : _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<BlogUploadEvent>(_onBlogUpload);
    on<BlogFetchAllBlogsEvent>(_onBlogFetchAllBlogs);
  }

  void _onBlogUpload(BlogUploadEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (onRight) => emit(BlogUploadSuccess()),
    );
  }

  void _onBlogFetchAllBlogs(
      BlogFetchAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(
      NoParams(),
    );

    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (blogs) => emit(BlogsDisplaySuccess(blogs: blogs)),
    );
  }
}
