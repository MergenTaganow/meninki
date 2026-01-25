import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meninki/features/store/bloc/get_my_stores_bloc/get_my_stores_bloc.dart';
import 'package:meninki/features/store/models/market.dart';

import '../../../core/api.dart';
import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/injector.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../blocs/get_reels_bloc/get_reels_bloc.dart';

class ReelCreatePage extends StatefulWidget {
  final Product product;
  final Map<String, dynamic>? laterCreateReel;

  const ReelCreatePage({required this.product, this.laterCreateReel, super.key});

  @override
  State<ReelCreatePage> createState() => _ReelCreatePageState();
}

class _ReelCreatePageState extends State<ReelCreatePage> {
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  File? file;
  BetterPlayerController? controller;
  Market? uploadingFromMarket;

  @override
  void initState() {
    context.read<GetMyStoresBloc>().add(GetMyStores());
    if (widget.laterCreateReel != null) {
      title.text = widget.laterCreateReel!['title'];
      description.text = widget.laterCreateReel!['description'];
    }
    super.initState();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReelCreateCubit, ReelCreateState>(
          listener: (context, state) {
            if (state is ReelCreateFailed) {
              CustomSnackBar.showSnackBar(
                context: context,
                title: state.failure.message ?? "error",
                isError: true,
              );
            }
            if (state is ReelCreateSuccess) {
              CustomSnackBar.showSnackBar(context: context, title: "Успешно", isError: false);
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
        // BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
        //   listener: (context, state) async {
        //     if (state is FileUploadCoverImageSuccess) {
        //       // file = state.file;
        //       // await initController();
        //       // setState(() {});
        //     }
        //   },
        // ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Новый обзор на товар", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: createButton(),
        body: Padd(
          pad: 10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //product and store
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name.tk ?? "",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      Box(h: 10),
                      Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          splashColor: Colors.black.withOpacity(0.08),
                          highlightColor: Colors.black.withOpacity(0.04),
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: const Color(0xFFF3F3F3),
                              isScrollControlled: true,
                              builder: (context) {
                                return reelUploaderSelection();
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFF3F3F3),
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                ),
                                Box(w: 10),
                                Expanded(
                                  child: Text(
                                    uploadingFromMarket == null
                                        ? "От своего аккаунта"
                                        : uploadingFromMarket!.name.trans(context),
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Box(w: 10),
                                Icon(Icons.navigate_next),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //Title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Box(h: 20),
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
                Box(h: 20),
                Text("Media", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Box(h: 20),
                if (file != null)
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(10),
                  //   child:
                  //       controller == null
                  //           ? Container(
                  //             color: Colors.grey.withOpacity(0.3),
                  //             child: const Center(child: Icon(Icons.play_circle_outline)),
                  //           )
                  //           : AspectRatio(
                  //             aspectRatio:
                  //                 controller!.getAspectRatio() ??
                  //                 controller?.videoPlayerController?.value.aspectRatio ??
                  //                 9 / 16, // dynamic or fallback
                  //             child: BetterPlayer(controller: controller!),
                  //           ),
                  // )
                  Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              controller == null
                                  ? const Center(child: Icon(Icons.play_circle_outline))
                                  : BetterPlayer(controller: controller!),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              file = null;
                              controller = null;
                              setState(() {});
                            },
                            child: Icon(Icons.cancel, color: Color(0xFFF3F3F3)),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      splashColor: Colors.black.withOpacity(0.15),
                      highlightColor: Colors.black.withOpacity(0.08),
                      onTap: () async {
                        HapticFeedback.mediumImpact();

                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.video,
                          lockParentWindow: true,
                          allowMultiple: false,
                        );

                        if (result != null) {
                          file = File(result.files.single.path!);
                          controller = null;

                          controller = BetterPlayerController(
                            const BetterPlayerConfiguration(
                              autoPlay: true,
                              looping: true,
                              fit: BoxFit.cover,

                              controlsConfiguration: BetterPlayerControlsConfiguration(
                                showControls: true,
                              ),
                            ),
                            betterPlayerDataSource: BetterPlayerDataSource(
                              BetterPlayerDataSourceType.file,
                              file!.path,
                            ),
                          );
                          controller?.setVolume(0);
                          setState(() {});
                          // context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                        }
                      },

                      child: Ink(
                        height: 106,
                        width: 106,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: const Color(0xFFEAEAEA),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_circle, color: Colors.black),
                              SizedBox(height: 4),
                              Text(
                                "Добавить медиа",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Box(h: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DraggableScrollableSheet reelUploaderSelection() {
    return DraggableScrollableSheet(
      minChildSize: 0.4,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Обзор на товар',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text('Выберите тип опубликования'),
                    SizedBox(height: 20),
                  ],
                ),
              ),

              BlocBuilder<GetMyStoresBloc, GetMyStoresState>(
                builder: (context, state) {
                  if (state is GetMyStoresLoading) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }
                  if (state is GetMyStoresSuccess) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  uploadingFromMarket = null;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'От своего аккаунта',
                                          style: TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Icon(Icons.person),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          var store = state.stores[index - 1];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Material(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () {
                                  uploadingFromMarket = store;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  height: 46,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            store.name.trans(context),
                                            style: TextStyle(fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                          ),
                                        ),
                                        Icon(Icons.storefront_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      }, childCount: state.stores.length + 1),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),
            ],
          ),
        );
      },
    );
  }

  BlocBuilder<ReelCreateCubit, ReelCreateState> createButton() {
    return BlocBuilder<ReelCreateCubit, ReelCreateState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              splashColor: Colors.white.withOpacity(0.25),
              highlightColor: Colors.white.withOpacity(0.15),
              onTap:
                  state is ReelCreateLoading
                      ? null
                      : () {
                        HapticFeedback.mediumImpact();

                        final map = {
                          'title': title.text.trim(),
                          'description': description.text.trim(),
                          'link_id': widget.product.id,
                          "link": "string",
                          "type": "product",
                          "is_active": true,
                          if (uploadingFromMarket != null) "market_id": uploadingFromMarket?.id,
                          "tags": ["string"],
                        };

                        if (file != null) {
                          context.read<FileUplCoverImageBloc>().add(UploadFile(file!));
                          CustomSnackBar.showSnackBar(
                            context: context,
                            title: 'reel will be created',
                            isError: false,
                          );
                          context.read<ReelCreateCubit>().setReel(map);
                          Go.pop();
                        } else {
                          CustomSnackBar.showYellowSnackBar(context: context, title: "choose file");
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
                      state is ReelCreateLoading
                          ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                          : const Text("Опубликовать", style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
