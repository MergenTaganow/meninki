import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/features/adds/bloc/add_create_cubit/add_create_cubit.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/widgets/category_selection.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';

import '../../../core/colors.dart';
import '../../../core/failure.dart';
import '../../../core/helpers.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/pages/product_create_page.dart';
import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../province/widgets/province_selection.dart';
import '../../reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import '../../reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../reels/model/meninki_file.dart';
import '../../store/pages/store_create_page.dart';

class AddCreatePage extends StatefulWidget {
  const AddCreatePage({super.key});

  @override
  State<AddCreatePage> createState() => _AddCreatePageState();
}

class _AddCreatePageState extends State<AddCreatePage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController numberController = TextEditingController();
  List<MeninkiFile> addPhotos = [];
  MeninkiFile? coverImage;

  // File? file;
  // BetterPlayerController? controller;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AddCreateCubit, AddCreateState>(
          listener: (context, state) {
            if (state is AddCreateSuccess) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: 'После проверки будет опубликирован',
              );
              Go.pop();
            }
          },
        ),
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageSuccess) {
              coverImage = state.file;
            }
          },
        ),
        BlocListener<FileUplBloc, FileUplState>(
          listener: (context, state) {
            if (state is FileUploadSuccess && state.type == UploadingFileTypes.addPhotos) {
              addPhotos.add(state.file);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
          },
        ),
        BlocListener<FileProcessingCubit, FileProcessingState>(
          listener: (context, state) {
            if (state is FileProcessingUpdated) {
              if (state.file.id == coverImage?.id) {
                coverImage = state.file;
                setState(() {});
              } else {
                var index = addPhotos.indexWhere((element) => element.id == state.file.id);
                if (index != -1) {
                  addPhotos[index] = state.file;
                  setState(() {});
                }
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Новый обзор на товар", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<AddCreateCubit, AddCreateState>(
          builder: (context, state) {
            return InkWell(
              onTap: () {
                print({
                  'title': title.text,
                  'description': description.text,
                  'price': price.text,
                  // 'number': numberController.text,
                  'province_id':
                      context
                          .read<ProvinceSelectingCubit>()
                          .selectedMap[ProvinceSelectingCubit.add_creating_province]
                          ?.single
                          .id,
                  'category_id':
                      context
                          .read<CategorySelectingCubit>()
                          .selectedMap[CategorySelectingCubit.add_creating_category]
                          ?.single
                          .id,
                  'cover_image_id': coverImage?.id,
                  'file_ids': addPhotos.map((e) => e.id).toList(),
                  'link_type': 'product',
                  'link': ' ',
                });
                context.read<AddCreateCubit>().createAdd({
                  'title': title.text,
                  'description': description.text,
                  'price': price.text,
                  // 'number': numberController.text,
                  'province_id':
                      context
                          .read<ProvinceSelectingCubit>()
                          .selectedMap[ProvinceSelectingCubit.add_creating_province]
                          ?.single
                          .id,
                  'category_id':
                      context
                          .read<CategorySelectingCubit>()
                          .selectedMap[CategorySelectingCubit.add_creating_category]
                          ?.single
                          .id,
                  'cover_image_id': coverImage?.id,
                  'file_ids': addPhotos.map((e) => e.id).toList(),
                  'link_type': 'product',
                  "is_active": true,
                  'link': ' ',
                });
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Col.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                margin: EdgeInsets.symmetric(horizontal: 14),
                child: Center(
                  child:
                      state is AddCreateLoading
                          ? CircularProgressIndicator()
                          : Text("Опубликовать", style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
        body: Padd(
          pad: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //cover image
                BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () async {
                        if (state is! FileUploadingCoverImage) {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            lockParentWindow: true,
                          );

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            if (isVideo(file)) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: 'вуберите фотографию',
                              );
                              return;
                            }
                            context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: Color(0xFFF3F3F3), width: 1),
                              ),
                              child:
                                  coverImage?.status != 'ready'
                                      ? UploadingCoverImage(
                                        coverImage: coverImage,
                                        loadingProgress:
                                            state is FileUploadingCoverImage
                                                ? state.progress
                                                : null,
                                      )
                                      : MeninkiNetworkImage(
                                        file: coverImage!,
                                        networkImageType: NetworkImageType.small,
                                        fit: BoxFit.cover,
                                      ),
                              // state is FileUploadCoverImageSuccess
                              //     ? Image.network(
                              //       '$baseUrl/public/${state.file.resizedFiles?.small}',
                              //       fit: BoxFit.cover,
                              //     )
                              //     : Center(
                              //       child:
                              //           state is FileUploadingCoverImage
                              //               ? SizedBox(
                              //                 height: 25,
                              //                 width: 25,
                              //                 child: CircularProgressIndicator(
                              //                   value: state.progress,
                              //                   color: Colors.blue,
                              //                 ),
                              //               )
                              //               : Icon(Icons.camera_alt_outlined),
                              //     ),
                            ),
                          ),
                          Box(w: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Аватар вашего объявления"),
                              Text(
                                'Нажмите, чтобы изменить',
                                style: TextStyle(fontSize: 12, color: Color(0xFF969696)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Box(h: 10),
                //Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Заголовок"),
                    TexField(
                      ctx: context,
                      cont: title,
                      border: true,
                      borderRadius: 14,
                      hint: "Обязательно",
                      hintCol: Color(0xFF969696),
                      borderColor: Colors.black,
                    ),
                  ],
                ),
                //description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Box(h: 20),
                    Text("Описание"),
                    TexField(
                      ctx: context,
                      border: true,
                      cont: description,
                      borderRadius: 14,
                      borderColor: Colors.black,
                      hintCol: Color(0xFF969696),
                      hint: "Необязательно",
                      minLine: 5,
                      maxLine: 5,
                    ),
                  ],
                ),
                //Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Box(h: 20),
                    Text("Стоимость"),
                    TexField(
                      ctx: context,
                      cont: price,
                      border: true,
                      borderRadius: 14,
                      hint: "Обязательно",
                      hintCol: Color(0xFF969696),
                      borderColor: Colors.black,
                      keyboard: TextInputType.number,
                    ),
                  ],
                ),
                Box(h: 20),
                Center(
                  child: Text("Media", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
                Box(h: 20),
                BlocBuilder<FileUplBloc, FileUplState>(
                  builder: (context, state) {
                    List<File> uploadingFiles = [];
                    List<double> uploadingValues = [];
                    List<File>? errorFiles = [];
                    List<Failure>? errors = [];
                    if (state is FileUploading && state.type == UploadingFileTypes.addPhotos) {
                      uploadingFiles = state.uploadingFiles.keys.toList();
                      uploadingValues = state.uploadingFiles.values.toList();
                      errorFiles = state.errorMap?.keys.toList();
                      errors = state.errorMap?.values.toList();
                    }

                    return Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        ...List.generate(addPhotos.length, (index) {
                          var photo = addPhotos[index];
                          return SizedBox(
                            height: 106,
                            width: 106,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 106,
                                    width: 106,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF969696),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: UploadingCoverImage(
                                      coverImage: photo,
                                      loadingProgress: null,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        addPhotos.removeAt(index);
                                        setState(() {});
                                      },
                                      child: Icon(Icons.cancel, color: Color(0xFFF3F3F3)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        ...List.generate(uploadingFiles.length, (index) {
                          return UploadingImageCard(
                            file: uploadingFiles[index],
                            value: uploadingValues[index],
                            onRemoveTap: () {
                              context.read<FileUplBloc>().add(RemoveFile(uploadingFiles[index]));
                            },
                          );
                        }),
                        ...List.generate(errorFiles?.length ?? 0, (index) {
                          return UploadingImageCard(
                            file: errorFiles![index],
                            failure: errors![index],
                            onRemoveTap: () {
                              context.read<FileUplBloc>().add(RemoveFile(uploadingFiles[index]));
                            },
                            onRetryTap: () {
                              context.read<FileUplBloc>().add(
                                RetryFile(errorFiles![index], UploadingFileTypes.addPhotos),
                              );
                            },
                          );
                        }),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            splashColor: Colors.black.withOpacity(0.15),
                            highlightColor: Colors.black.withOpacity(0.08),
                            onTap: () async {
                              HapticFeedback.mediumImpact();

                              // Give ripple time to show
                              await Future.delayed(const Duration(milliseconds: 120));

                              if (state is! FileUploading) {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.media,
                                  lockParentWindow: true,
                                  allowMultiple: true,
                                );

                                if (result != null) {
                                  List<File> files =
                                      result.paths
                                          .where((path) => path != null)
                                          .map((path) => File(path!))
                                          .toList();
                                  context.read<FileUplBloc>().add(
                                    UploadFiles(files, UploadingFileTypes.addPhotos),
                                  );
                                }
                              }
                            },
                            child: Ink(
                              height: 106,
                              width: 106,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: const Color(0xFFEAEAEA),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.add_circle, color: Colors.black),
                                    SizedBox(height: 4),
                                    Text(
                                      "Добавить еще медиа",
                                      style: TextStyle(fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Box(h: 20),
                    Text("Контактный номер"),
                    TexField(
                      ctx: context,
                      cont: numberController,
                      border: true,
                      borderColor: Color(0xFF474747),
                      borderRadius: 14,
                      preTex: "+993 ",
                      hint: 'XX XXXXXX',
                      keyboard: TextInputType.phone,
                    ),
                  ],
                ),
                Box(h: 20),
                ProvinceSelection(
                  selectionKey: ProvinceSelectingCubit.add_creating_province,
                  singleSelection: true,
                ),
                Box(h: 20),
                CategorySelection(
                  selectionKey: CategorySelectingCubit.add_creating_category,
                  singleSelection: true,
                  rootCategorySelection: true,
                ),

                Box(h: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
