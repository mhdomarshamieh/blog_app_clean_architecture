import 'package:blog_app_clean_architecture/core/error/failures.dart';
import 'package:blog_app_clean_architecture/core/use_case/use_case.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/entities/blog.dart';
import 'package:blog_app_clean_architecture/features/blog/domain/repositories/i_blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParams> {
  final IBlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);

  @override
  Future<Either<Failure, List<Blog>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
