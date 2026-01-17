import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/api.dart';
import 'package:meninki/core/colors.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/global/widgets/meninki_network_image.dart';
import 'package:meninki/features/home/bloc/get_profile_cubit/get_profile_cubit.dart';
import 'package:meninki/features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'package:meninki/features/store/widgets/ColorPicker.dart';

import '../../province/blocks/province_selecting_cubit/province_selecting_cubit.dart';
import '../../province/widgets/province_selection.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';

class StoreCreatePage extends StatefulWidget {
  const StoreCreatePage({super.key});

  @override
  State<StoreCreatePage> createState() => _StoreCreatePageState();
}

class _StoreCreatePageState extends State<StoreCreatePage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController descriptionTMController = TextEditingController();

  final TextEditingController descriptionRuController = TextEditingController();

  final TextEditingController descriptionENController = TextEditingController();

  final TextEditingController addressTMController = TextEditingController();

  final TextEditingController addressRuController = TextEditingController();

  final TextEditingController addressENController = TextEditingController();

  final TextEditingController usernameController = TextEditingController();

  final TextEditingController numberController = TextEditingController();

  MeninkiFile? coverImage;

  final TextEditingController email = TextEditingController();

  final TextEditingController webpage = TextEditingController();

  final TextEditingController telegram = TextEditingController();

  final TextEditingController instagram = TextEditingController();

  final TextEditingController tictok = TextEditingController();

  Map<String, TextEditingController> contacts = {};
  Color selectedColor = Colors.white;

  @override
  void deactivate() {
    context.read<FileUplCoverImageBloc>().add(Clear());
    super.deactivate();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionTMController.dispose();
    descriptionRuController.dispose();
    descriptionENController.dispose();
    addressTMController.dispose();
    addressRuController.dispose();
    addressENController.dispose();
    usernameController.dispose();
    numberController.dispose();
    email.dispose();
    webpage.dispose();
    telegram.dispose();
    instagram.dispose();
    tictok.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreCreateCubit, StoreCreateState>(
          listener: (context, state) {
            if (state is StoreCreateFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? "smthWentWrong",
                isError: true,
              );
            }
            if (state is StoreCreateSuccess) {
              CustomSnackBar.showSnackBar(context: context, title: "Success", isError: false);
              Navigator.pop(context);
              context.read<GetProfileCubit>().getMyProfile();
            }
          },
        ),
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) {
            if (state is FileUploadCoverImageFailure) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? "smthWentWrong",
                isError: true,
              );
            }
            if (state is FileUploadCoverImageSuccess) {
              coverImage = state.file;
              CustomSnackBar.showSnackBar(context: context, title: "Success", isError: false);
            }
          },
        ),
        BlocListener<FileProcessingCubit, FileProcessingState>(
          listener: (context, state) {
            if (state is FileProcessingUpdated) {
              if (state.file.id == coverImage?.id) {
                coverImage = state.file;
                setState(() {});
              }
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: selectedColor,
        appBar: AppBar(
          backgroundColor: selectedColor,
          title: Text("Новый магазин", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        body: SingleChildScrollView(
          child: Padd(
            hor: 10,
            ver: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
                  builder: (context, state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(100),
                      onTap: () async {
                        if (state is! FileUploadingCoverImage) {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.image,
                            lockParentWindow: true,
                          );

                          if (result != null) {
                            File file = File(result.files.single.path!);
                            context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                          }
                        }
                      },
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
                              child: UploadingCoverImage(
                                coverImage: coverImage,
                                loadingProgress:
                                    state is FileUploadingCoverImage ? state.progress : null,
                              ),
                            ),
                          ),
                          Box(w: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Аватар вашего магазина"),
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

                //name
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Название магазина"),
                    TexField(
                      ctx: context,
                      cont: nameController,
                      border: true,
                      borderColor: Color(0xFF474747),
                      borderRadius: 14,
                      hint: "Обязательно",
                    ),
                  ],
                ),

                //description
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Box(h: 16),
                    Text("Приветствие или краткое описание"),
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

                //address
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Box(h: 16),
                    Text("Адрес магазина"),
                    TexField(
                      ctx: context,
                      cont: addressTMController,
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
                        cont: addressRuController,
                        border: false,
                        borderColor: Color(0xFF474747),
                        preTex: "RU: ",
                        maxLine: 3,
                        minLine: 1,
                      ),
                    ),
                    TexField(
                      ctx: context,
                      cont: addressENController,
                      border: true,
                      borderColor: Color(0xFF474747),
                      borderRadiusType: BorderRadius.vertical(bottom: Radius.circular(14)),
                      preTex: "EN: ",
                      maxLine: 3,
                      minLine: 1,
                    ),
                  ],
                ),

                //username
                Box(h: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Придумайте юзернейм"),
                    TexField(
                      ctx: context,
                      cont: usernameController,
                      border: true,
                      borderColor: Color(0xFF474747),
                      borderRadius: 14,
                      preTex: "@ ",
                    ),
                  ],
                ),

                ///provicne
                Box(h: 10),
                ProvinceSelection(
                  selectionKey: ProvinceSelectingCubit.product_creating_province,
                  singleSelection: true,
                ),

                //phoneNumber
                Box(h: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                ...List.generate(contacts.length, (index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Box(h: 10),
                      Text(contacts.keys.toList()[index]),
                      TexField(
                        ctx: context,
                        cont: contacts.values.toList()[index],
                        border: true,
                        borderColor: Color(0xFF474747),
                        borderRadius: 14,
                        suffixWidget: InkWell(
                          onTap: () {
                            setState(() {
                              contacts.remove(contacts.keys.toList()[index]);
                            });
                          },
                          child: Padd(right: 12, child: Icon(Icons.clear, size: 18)),
                        ),
                      ),
                    ],
                  );
                }),

                Box(h: 10),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    splashColor: Colors.black.withOpacity(0.12),
                    highlightColor: Colors.black.withOpacity(0.06),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 120), () {
                        addContactsSheet(context);
                      });
                    },
                    child: Ink(
                      height: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "Добавить контакт",
                              style: TextStyle(
                                color: Color(0xFF474747),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(Icons.add_circle_outline_rounded, color: Color(0xFF474747)),
                        ],
                      ),
                    ),
                  ),
                ),
                Box(h: 10),

                // ColorPicker(
                //   selectedColor: selectedColor,
                //   onColorSelected: (color) {
                //     setState(() {
                //       selectedColor = color;
                //     });
                //   },
                // ),
                Box(h: 50),
                BlocBuilder<StoreCreateCubit, StoreCreateState>(
                  builder: (context, state) {
                    return SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Col.primary),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),

                          /// ⭐ Ripple tuning
                          overlayColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white.withOpacity(0.18);
                            }
                            if (states.contains(MaterialState.hovered)) {
                              return Colors.white.withOpacity(0.08);
                            }
                            return null;
                          }),

                          /// Optional: remove elevation jump
                          elevation: MaterialStateProperty.resolveWith(
                            (states) => states.contains(MaterialState.pressed) ? 1 : 2,
                          ),
                        ),
                        onPressed: () {
                          HapticFeedback.mediumImpact();

                          if (state is! StoreCreateLoading) {
                            var provinces =
                                context
                                    .read<ProvinceSelectingCubit>()
                                    .selectedMap[ProvinceSelectingCubit.product_creating_province];
                            context.read<StoreCreateCubit>().createStore({
                              "name": nameController.text.trim(),
                              "description": {
                                "tk": descriptionTMController.text.trim(),
                                "ru": descriptionRuController.text.trim(),
                                "en": descriptionENController.text.trim(),
                              },
                              "address": {
                                "tk": addressTMController.text.trim(),
                                "ru": addressRuController.text.trim(),
                                "en": addressENController.text.trim(),
                              },
                              "location": {"longitude": 38.7373, "latitude": 52.7373},
                              "cover_image_id": coverImage?.id,
                              if (provinces?.isNotEmpty ?? false)
                                "province_id": provinces?.first.id,
                              "username": usernameController.text.trim(),
                              "profile_color": '#${selectedColor.value.toRadixString(16)}',
                              "file_ids": [1],
                              "contact_info": {
                                if (email.text.isNotEmpty) "email": email.text,
                                if (numberController.text.isNotEmpty)
                                  "phone": numberController.text,
                                if (webpage.text.isNotEmpty) "webpage": webpage.text,
                                if (telegram.text.isNotEmpty) "telegram": telegram.text,
                                if (instagram.text.isNotEmpty) "instagram": instagram.text,
                                if (tictok.text.isNotEmpty) "tictok": tictok.text,
                              },
                            });
                          }
                        },
                        child:
                            state is StoreCreateLoading
                                ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                                : Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        "Отправить на проверку",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Icon(Icons.send, color: Colors.white),
                                  ],
                                ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> addContactsSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          color: Color(0xFFF3F3F3),
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Добавить контакт', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              Text('Выберите тип контакта'),
              Box(h: 20),
              singleSheetButton(type: "email", title: "Email", icon: Icons.email_outlined),
              Box(h: 8),
              singleSheetButton(type: "webpage", title: "Web sahypanyz", icon: Icons.language),
              Box(h: 8),
              singleSheetButton(
                type: "telegram",
                title: "Telegram sahypanyz",
                icon: Icons.language,
              ),
              Box(h: 8),
              singleSheetButton(
                type: "instagram",
                title: "Instagram sahypanyz",
                icon: Icons.language,
              ),
              Box(h: 8),
              singleSheetButton(type: "tictok", title: "TicTok sahypanyz", icon: Icons.language),
            ],
          ),
        );
      },
    );
  }

  Widget singleSheetButton({required String type, required String title, required IconData icon}) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        splashColor: Colors.black.withOpacity(0.08),
        highlightColor: Colors.black.withOpacity(0.04),
        onTap: () {
          HapticFeedback.selectionClick();

          Future.delayed(const Duration(milliseconds: 120), () {
            if (contacts.containsKey(type)) return;

            var controller;
            if (type == "email") controller = email;
            if (type == "webpage") controller = webpage;
            if (type == "telegram") controller = telegram;
            if (type == "instagram") controller = instagram;
            if (type == "tictok") controller = tictok;
            if (controller == null) return;

            setState(() {
              contacts.addAll({type: controller});
            });
            Navigator.pop(context);
          });
        },
        child: Ink(
          height: 45,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF474747), fontWeight: FontWeight.w500),
                ),
              ),
              Icon(icon, color: const Color(0xFF474747)),
            ],
          ),
        ),
      ),
    );
  }
}

class UploadingCoverImage extends StatelessWidget {
  const UploadingCoverImage({super.key, required this.coverImage, required this.loadingProgress});

  final MeninkiFile? coverImage;
  final double? loadingProgress;

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          (loadingProgress != null)
              ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(value: loadingProgress, color: Colors.blue),
              )
              : (coverImage != null)
              ? ((coverImage?.status == 'ready' &&
                      (coverImage?.resizedFiles?.small?.isNotEmpty ?? false))
                  ? MeninkiNetworkImage(
                    file: coverImage!,
                    networkImageType: NetworkImageType.small,
                    fit: BoxFit.contain,
                  )
                  : Image.asset('assets/images/app_logo.png', fit: BoxFit.cover))
              : Icon(Icons.camera_alt_outlined),
    );
  }
}
