import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/routes.dart';
import 'package:meninki/features/categories/bloc/brand_selecting_cubit/brand_selecting_cubit.dart';
import 'package:meninki/features/categories/bloc/category_selecting_cubit/category_selecting_cubit.dart';
import 'package:meninki/features/categories/models/brand.dart';
import 'package:meninki/features/categories/models/category.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/product/bloc/product_create_cubit/product_create_cubit.dart';
import 'package:meninki/features/reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';

import '../../../core/api.dart';
import '../../../core/helpers.dart';
import '../../reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../store/pages/store_create_page.dart';
import '../models/product.dart';

class ProductCreatePage extends StatefulWidget {
  final int storeId;

  const ProductCreatePage(this.storeId, {super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController nameTMController = TextEditingController();

  final TextEditingController nameRuController = TextEditingController();

  final TextEditingController nameENController = TextEditingController();

  final TextEditingController descriptionTMController = TextEditingController();

  final TextEditingController descriptionRuController = TextEditingController();

  final TextEditingController descriptionENController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController previousPriceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  MeninkiFile? coverImage;
  List<MeninkiFile> productPhotos = [];
  File? coverLoadingImage;
  List<Category> selectedSubCategories = [];
  Brand? selectedBrand;

  Product? createdProduct;

  @override
  void deactivate() {
    context.read<FileUplCoverImageBloc>().add(Clear());
    context.read<FileUplBloc>().add(ClearUploading());
    context.read<CategorySelectingCubit>().emptySelections(
      CategorySelectingCubit.product_creating_category,
    );
    context.read<BrandSelectingCubit>().emptySelections(BrandSelectingCubit.product_creating_brand);
    super.deactivate();
  }

  @override
  void dispose() {
    nameTMController.dispose();
    nameRuController.dispose();
    nameENController.dispose();
    descriptionTMController.dispose();
    descriptionRuController.dispose();
    descriptionENController.dispose();
    priceController.dispose();
    previousPriceController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageSuccess) {
              coverImage = state.file;
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
                var index = productPhotos.indexWhere((element) => element.id == state.file.id);
                if (index != -1) {
                  productPhotos[index] = state.file;
                  setState(() {});
                }
              }
            }
          },
        ),
        BlocListener<ProductCreateCubit, ProductCreateState>(
          listener: (context, state) {
            if (state is ProductCreateSuccess) {
              CustomSnackBar.showSnackBar(context: context, title: "Успешно", isError: false);
              createdProduct = state.product;
              setState(() {});
              scrollController.animateTo(
                0,
                duration: Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            }
            if (state is ProductCreateFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? "error",
                isError: true,
              );
            }
          },
        ),
        BlocListener<FileUplBloc, FileUplState>(
          listener: (context, state) {
            if (state is FileUploadSuccess && state.type == UploadingFileTypes.productPhotos) {
              productPhotos.add(state.file);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
          },
        ),
        BlocListener<CategorySelectingCubit, CategorySelectingState>(
          listener: (context, state) {
            if (state is CategorySelectingSuccess) {
              selectedSubCategories =
                  state.selectedMap[CategorySelectingCubit.product_creating_category] ?? [];
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
          },
        ),
        BlocListener<BrandSelectingCubit, BrandSelectingState>(
          listener: (context, state) {
            if (state is BrandSelectingSuccess) {
              selectedBrand =
                  (state.selectedMap[BrandSelectingCubit.product_creating_brand] ?? []).single;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Новый товар")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            createdProduct == null
                ? BlocBuilder<ProductCreateCubit, ProductCreateState>(
                  builder: (context, state) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          splashColor: Colors.white.withOpacity(0.22),
                          highlightColor: Colors.white.withOpacity(0.10),
                          onTap: () {
                            var valid = _formKey.currentState?.validate();
                            if (valid == false) return;

                            if (coverImage == null) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Выберите обложку",
                              );
                              return;
                            }
                            if (productPhotos.isEmpty) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Добавьте фото",
                              );
                              return;
                            }

                            if (selectedBrand == null) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Выберите бренд",
                              );
                              return;
                            }
                            if (selectedSubCategories.isEmpty) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Выберите категорию",
                              );
                              return;
                            }
                            if (nameENController.text.isEmpty ||
                                nameRuController.text.isEmpty ||
                                nameTMController.text.isEmpty) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Заполните все поля",
                              );
                              return;
                            }

                            if (descriptionENController.text.isEmpty ||
                                descriptionRuController.text.isEmpty ||
                                descriptionTMController.text.isEmpty) {
                              CustomSnackBar.showYellowSnackBar(
                                context: context,
                                title: "Заполните все поля",
                              );
                              return;
                            }

                            if (state is! ProductCreateLoading) {
                              HapticFeedback.mediumImpact();

                              // Give ripple time to show
                              Future.delayed(const Duration(milliseconds: 120), () {
                                context.read<ProductCreateCubit>().createProduct({
                                  "name": {
                                    "tk": nameTMController.text.trim(),
                                    "en": nameENController.text.trim(),
                                    "ru": nameRuController.text.trim(),
                                  },
                                  "description": {
                                    "tk": descriptionTMController.text.trim(),
                                    "en": descriptionENController.text.trim(),
                                    "ru": descriptionRuController.text.trim(),
                                  },
                                  "is_active": true,
                                  "cover_image_id": coverImage?.id,
                                  "market_id": widget.storeId,
                                  "price": priceController.text,
                                  "brand_id": selectedBrand?.id,
                                  if (previousPriceController.text.isNotEmpty)
                                    "discount": previousPriceController.text,
                                  "category_ids": selectedSubCategories.map((e) => e.id).toList(),
                                  "file_ids": productPhotos.map((e) => e.id).toList(),
                                });
                              });
                            }
                          },
                          child: Ink(
                            height: 45,
                            decoration: BoxDecoration(
                              color: Col.primary,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child:
                                  state is ProductCreateLoading
                                      ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0,
                                          valueColor: AlwaysStoppedAnimation(Colors.white),
                                        ),
                                      )
                                      : const Text(
                                        "Опубликовать",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
                : null,
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padd(
            hor: 10,
            ver: 20,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                              coverLoadingImage = file;
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
                                    coverImage?.status == 'ready'
                                        ? MeninkiNetworkImage(
                                          file: coverImage!,
                                          networkImageType: NetworkImageType.small,
                                          fit: BoxFit.cover,
                                        )
                                        : UploadingCoverImage(
                                          coverImage: coverImage,
                                          loadingProgress:
                                              state is FileUploadingCoverImage
                                                  ? state.progress
                                                  : null,
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
                                Text("Аватар вашего продукта"),
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
                  Box(h: 20),
                  if (createdProduct != null)
                    Column(
                      children: [
                        Center(
                          child: Text(
                            "Характеристики товара",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),

                        Text(
                          "Здесь вы сможете добавить характеристики к вашему товару и создать вариации к каждой характеристике товара.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF969696)),
                        ),
                        Box(h: 10),
                        InkWell(
                          onTap: () {
                            Go.to(
                              Routes.productParametersPage,
                              argument: {"product": createdProduct},
                            );
                          },
                          child: Container(
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: EdgeInsets.all(14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Добавить характеристики",
                                  style: TextStyle(
                                    color: Color(0xFF474747),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Icon(Icons.add_circle_outline),
                              ],
                            ),
                          ),
                        ),
                        Box(h: 20),
                      ],
                    ),

                  //name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Название"),
                      TexField(
                        ctx: context,
                        cont: nameTMController,
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadiusType: BorderRadius.vertical(top: Radius.circular(14)),
                        preTex: "TM: ",
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(color: Color(0xFF474747), width: 1),
                          ),
                        ),
                        child: TexField(
                          ctx: context,
                          cont: nameRuController,
                          border: false,
                          borderColor: Color(0xFF474747),
                          preTex: "RU: ",
                        ),
                      ),
                      TexField(
                        ctx: context,
                        cont: nameENController,
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadiusType: BorderRadius.vertical(bottom: Radius.circular(14)),
                        preTex: "EN: ",
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Box(h: 16),
                      Text("Описание"),
                      TexField(
                        ctx: context,
                        cont: descriptionTMController,
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadiusType: BorderRadius.vertical(top: Radius.circular(14)),
                        preTex: "TM: ",
                        maxLine: 3,
                        minLine: 1,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(color: Color(0xFF474747), width: 1),
                          ),
                        ),
                        child: TexField(
                          ctx: context,
                          cont: descriptionRuController,
                          border: false,
                          borderColor: Color(0xFF474747),
                          preTex: "RU: ",
                          maxLine: 3,
                          minLine: 1,
                        ),
                      ),
                      TexField(
                        ctx: context,
                        cont: descriptionENController,
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadiusType: BorderRadius.vertical(bottom: Radius.circular(14)),
                        preTex: "EN: ",
                        maxLine: 3,
                        minLine: 1,
                      ),
                    ],
                  ),

                  Box(h: 30),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      splashColor: Colors.black.withOpacity(0.08),
                      highlightColor: Colors.black.withOpacity(0.04),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Future.delayed(const Duration(milliseconds: 120), () {
                          Go.to(
                            Routes.categoriesSelectingPage,
                            argument: {
                              "selectionKey": CategorySelectingCubit.product_creating_category,
                              "singleSelection": false,
                            },
                          );
                        });
                      },
                      child: Ink(
                        height: 45,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF474747)),
                        ),
                        child: Row(
                          children: const [
                            Expanded(child: Text("Выбрать категорию")),
                            Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Box(h: 10),
                  Wrap(
                    children: List.generate(selectedSubCategories.length, (index) {
                      return InkWell(
                        onTap: () {
                          context.read<CategorySelectingCubit>().selectCategory(
                            key: CategorySelectingCubit.product_creating_category,
                            category: selectedSubCategories[index],
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Col.passiveGreyQuick),
                          ),
                          margin: EdgeInsets.only(right: 8, bottom: 4),
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(selectedSubCategories[index].name?.tk ?? ""),
                              Box(w: 4),
                              Icon(Icons.clear, size: 14, color: Color(0xFF474747)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Box(h: 30),
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      splashColor: Colors.black.withOpacity(0.08),
                      highlightColor: Colors.black.withOpacity(0.04),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Future.delayed(const Duration(milliseconds: 120), () {
                          Go.to(Routes.brandSelectingPage);
                        });
                      },
                      child: Ink(
                        height: 45,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFF474747)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedBrand == null ? "Выбрать Brand" : selectedBrand!.name,
                                style: const TextStyle(
                                  color: Color(0xFF474747),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const Icon(Icons.navigate_next),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Box(h: 30),
                  BlocBuilder<FileUplBloc, FileUplState>(
                    builder: (context, state) {
                      List<File> uploadingFiles = [];
                      List<double> uploadingValues = [];
                      List<File>? errorFiles = [];
                      List<Failure>? errors = [];
                      if (state is FileUploading &&
                          state.type == UploadingFileTypes.productPhotos) {
                        uploadingFiles = state.uploadingFiles.keys.toList();
                        uploadingValues = state.uploadingFiles.values.toList();
                        errorFiles = state.errorMap?.keys.toList();
                        errors = state.errorMap?.values.toList();
                      }

                      return Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        children: [
                          ...List.generate(productPhotos.length, (index) {
                            var photo = productPhotos[index];
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
                                          productPhotos.removeAt(index);
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
                                  RetryFile(errorFiles![index], UploadingFileTypes.productPhotos),
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
                                    type: FileType.image,
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
                                      UploadFiles(files, UploadingFileTypes.productPhotos),
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
                  Box(h: 30),

                  //price
                  Center(
                    child: Text("Ценообразование", style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Стоимость"),
                      TexField(
                        ctx: context,
                        cont: priceController,
                        border: true,
                        borderColor: Color(0xFF474747),
                        hint: "Обязательно",
                        borderRadiusType: BorderRadius.circular(14),
                        keyboard: TextInputType.numberWithOptions(decimal: true),
                        validate: (text) => (text?.isEmpty ?? false) ? 'Обязательноe поле' : null,
                      ),
                      Box(h: 10),
                      Text("Стоимость до скидки"),
                      TexField(
                        ctx: context,
                        cont: previousPriceController,
                        border: true,
                        hint: "Если есть скидка",
                        borderColor: Color(0xFF474747),
                        borderRadiusType: BorderRadius.circular(14),
                        keyboard: TextInputType.numberWithOptions(decimal: true),
                      ),
                    ],
                  ),
                  Box(h: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UploadingImageCard extends StatelessWidget {
  const UploadingImageCard({
    super.key,
    required this.file,
    this.value,
    this.failure,
    this.onRemoveTap,
    this.onRetryTap,
  });

  final File file;
  final double? value;
  final Failure? failure;
  final void Function()? onRemoveTap;
  final void Function()? onRetryTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 106,
        width: 106,
        decoration: BoxDecoration(
          color: Color(0xFF969696),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Center(child: Image.file(file, fit: BoxFit.cover)),
            GestureDetector(
              onTap: onRemoveTap,
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(Icons.cancel, color: Color(0xFFF3F3F3)),
              ),
            ),

            Align(
              alignment: Alignment.center,
              child:
                  (value != null)
                      ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(value: value),
                      )
                      : failure != null
                      ? GestureDetector(
                        onTap: onRetryTap,
                        child: Icon(Icons.refresh, color: Colors.red),
                      )
                      : null,
            ),
          ],
        ),
      ),
    );
  }
}
