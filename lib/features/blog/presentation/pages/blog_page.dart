import 'package:blog_app_clean_architecture/core/common/widgets/loader.dart';
import 'package:blog_app_clean_architecture/core/theme/app_palette.dart';
import 'package:blog_app_clean_architecture/core/utils/show_snackbar.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static const String routeName = '/blog-page';

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  void _navigateToAddBlogPage(BuildContext context) {
    Navigator.of(context).pushNamed(AddNewBlogPage.routeName);
  }

  @override
  void initState() {
    super.initState();
    context.read<BlogBloc>().add(BlogFetchAllBlogsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(
            onPressed: () => _navigateToAddBlogPage(context),
            icon: const Icon(
              CupertinoIcons.add_circled,
            ),
          ),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          if (state is BlogsDisplaySuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];

                return BlogCard(
                  blog: blog,
                  color: index % 2 == 0
                      ? AppPalette.gradient1
                      : AppPalette.gradient2,
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
