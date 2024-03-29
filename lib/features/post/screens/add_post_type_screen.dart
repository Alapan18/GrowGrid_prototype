// ignore_for_file: deprecated_member_use

import 'dart:io';
// ignore: unnecessary_import
import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growgrid/core/common/error_text.dart';
import 'package:growgrid/core/common/loader.dart';
import 'package:growgrid/core/utils.dart';
import 'package:growgrid/features/community/controller/community_controller.dart';
import 'package:growgrid/features/post/controller/post_controller.dart';
import 'package:growgrid/models/community_model.dart';
import 'package:growgrid/responsive/responsive.dart';
import 'package:growgrid/theme/pallete.dart';
// ignore: unused_import
import 'package:routemaster/routemaster.dart';
import 'package:tflite/tflite.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List? output;
  File? banner;
  File? bannerFile;
  double minimumconfidence = 0.50;
  double? confidenceValue;
  Uint8List? bannerWebFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  dispose() async {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
    await Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model_unquant.tflite',
      labels: 'assets/labels.txt',
    );
  }

  detectImage(File image) async {
    var prediction = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 1,
      threshold: 0.00001,
      imageMean: 255,
      imageStd: 255,
    );

    setState(() {
      output = prediction;
    });
    return await output?[0]['confidence'];
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      banner = File(res.files.first.path!);

      try {
        confidenceValue = await detectImage(banner as File);
        if (/*confidenceValue != null &&*/ confidenceValue! > minimumconfidence) {
          setState(() {
            bannerFile = banner;
            bannerWebFile = res.files.first.bytes;
          });
        } else {
          setState(() {
            bannerFile = null;
            bannerWebFile = null;

            showSnackBar(context,
                'Selected image is not suitable. Please pick another one.');
          });
        }
      } catch (e) {
        setState(() {
          bannerFile = null;
          bannerWebFile = null;
          showSnackBar(
              context, 'Error processing the image. Please try again.');
        });
      }
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        (bannerFile != null || bannerWebFile != null) &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            file: bannerFile,
            webFile: bannerWebFile,
          );
    } else if (widget.type == 'text' && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            description: descriptionController.text.trim(),
          );
    } else if (widget.type == 'link' &&
        titleController.text.isNotEmpty &&
        linkController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            context: context,
            title: titleController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
            link: linkController.text.trim(),
          );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final currentTheme = ref.watch(themeNotifierProvider);
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'Details....',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18),
                      ),
                      maxLength: 300,
                    ),
                    const SizedBox(height: 10),
                    if (isTypeImage)
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerWebFile != null
                                ? Image.memory(bannerWebFile!)
                                : bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : const Center(
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          size: 40,
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    if (isTypeText)
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter Description here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                        maxLines: 10,
                      ),
                    if (isTypeLink)
                      TextField(
                        controller: linkController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Enter link here',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(18),
                        ),
                      ),
                    const SizedBox(height: 30),
                    if (bannerFile != null)
                      Text(
                          'Type :  ${output?[0]['label'].toString().substring(2)} problem'),
                    Text('Confidence :  ${output?[0]['confidence']}'),
                    const SizedBox(height: 30),
                    const Align(
                      alignment: Alignment.topLeft,
                      child:
                          Text('Select Area -', style: TextStyle(fontSize: 17)),
                    ),
                    ref.watch(userCommunitiesProvider).when(
                          data: (data) {
                            communities = data;

                            if (data.isEmpty) {
                              return const SizedBox();
                            }

                            return DropdownButton(
                              value: selectedCommunity ?? data[0],
                              items: data
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedCommunity = val;
                                });
                              },
                            );
                          },
                          error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                          loading: () => const Loader(),
                        ),
                  ],
                ),
              ),
            ),
    );
  }
}
