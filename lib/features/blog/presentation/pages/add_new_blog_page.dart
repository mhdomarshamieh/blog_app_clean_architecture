import 'dart:io';

import 'package:blog_app_clean_architecture/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app_clean_architecture/core/common/widgets/loader.dart';
import 'package:blog_app_clean_architecture/core/theme/app_palette.dart';
import 'package:blog_app_clean_architecture/core/utils/pick_image.dart';
import 'package:blog_app_clean_architecture/core/utils/show_snackbar.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app_clean_architecture/features/blog/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static const String routeName = '/add-new-blog-page';

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;
  List<String> selectedTopics = [];

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
            BlogUploadEvent(
              posterId: posterId,
              title: titleController.text.trim(),
              content: contentController.text.trim(),
              image: image!,
              topics: selectedTopics,
            ),
          );
    }
  }

  void selectImage() async {
    final selectedImage = await pickImage();

    if (selectedImage != null) {
      setState(() {
        image = selectedImage;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: uploadBlog,
            icon: const Icon(Icons.done_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<BlogBloc, BlogState>(
          listener: (context, state) {
            if (state is BlogFailure) {
              showSnackBar(context, state.message);
            } else if (state is BlogUploadSuccess) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                BlogPage.routeName,
                (error) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is BlogLoading) {
              return const Loader();
            }
            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                              color: AppPalette.borderColor,
                              dashPattern: const [10, 4],
                              radius: const Radius.circular(10),
                              strokeCap: StrokeCap.round,
                              borderType: BorderType.RRect,
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text('Select your image')
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Business',
                          'Programming',
                          'Entertainment',
                        ]
                            .map(
                              (e) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    label: Text(e),
                                    color: selectedTopics.contains(e)
                                        ? const WidgetStatePropertyAll(
                                            AppPalette.gradient1)
                                        : null,
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : const BorderSide(
                                            color: AppPalette.borderColor,
                                          ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                      hintText: 'Blog Title',
                      controller: titleController,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    BlogEditor(
                      hintText: 'Blog Content',
                      controller: contentController,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
