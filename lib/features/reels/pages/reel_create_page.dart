import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/auth/data/employee_local_data_source.dart';
import 'package:meninki/features/global/widgets/custom_snack_bar.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meninki/features/reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import 'package:meninki/features/reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/reels/model/reels.dart';

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
  MeninkiFile? file;
  BetterPlayerController? controller;

  @override
  void initState() {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var fileState = sl<FileUplCoverImageBloc>().state;
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
              context.read<GetReelsBloc>().add(GetReel());
              CustomSnackBar.showSnackBar(context: context, title: "Успешно", isError: false);
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
        BlocListener<FileUplCoverImageBloc, FileUplCoverImageState>(
          listener: (context, state) async {
            if (state is FileUploadCoverImageSuccess) {
              file = state.file;
              await initController();
              setState(() {});
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text("Новый обзор на товар", style: TextStyle(fontWeight: FontWeight.w500)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: BlocBuilder<ReelCreateCubit, ReelCreateState>(
          builder: (context, state) {
            return GestureDetector(
              onTap: () {
                var map = {
                  'title': title.text.trim(),
                  'description': description.text.trim(),
                  if (file != null) 'file_id': file?.id,
                  'product_id': widget.product.id,
                  "link": "string",
                  "type": "product",
                  "is_active": true,
                  "market_id": 1,
                  "tags": ["string"],
                };
                if (file == null && fileState is FileUploadingCoverImage) {
                  context.read<ReelCreateCubit>().setReel(map);
                  Go.pop();
                  return;
                }
                if (state is! ReelCreateLoading) {
                  context.read<ReelCreateCubit>().createReel(map);
                }
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
                      state is ReelCreateLoading
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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(10),
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
                                "Магазин-название",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Box(w: 10),
                            Icon(Icons.navigate_next),
                          ],
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

                BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
                  builder: (context, state) {
                    if (state is FileUploadCoverImageSuccess) {
                      return InkWell(
                        onTap: () {},
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color:
                                        (controller?.isVideoInitialized() ?? false)
                                            ? Colors.black
                                            : Colors.grey.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child:
                                        (controller != null &&
                                                (controller?.isVideoInitialized() ?? false) &&
                                                (controller?.isPlaying() ?? false))
                                            ? BetterPlayer(controller: controller!)
                                            : MeninkiNetworkImage(
                                              file: state.file,
                                              networkImageType: NetworkImageType.small,
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state is FileUploadingCoverImage) {
                      return Container(
                        height: 240,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        child: Center(child: CircularProgressIndicator(value: state.progress)),
                      );
                    }

                    return GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.media,
                          lockParentWindow: true,
                          allowMultiple: false,
                        );

                        if (result != null) {
                          File file = File(result.files.single.path!);
                          context.read<FileUplCoverImageBloc>().add(UploadFile(file));
                        }
                      },
                      child: Container(
                        height: 106,
                        width: 106,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFEAEAEA),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle, color: Colors.black),
                              Text(
                                "Добавить медиа",
                                style: TextStyle(fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Box(h: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  initController() async {
    final dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      "$baseUrl/public/${file?.video_chunks?.first}",
      useAsmsAudioTracks: false,
      useAsmsSubtitles: false,
      useAsmsTracks: false,
      bufferingConfiguration: BetterPlayerBufferingConfiguration(
        minBufferMs: 2000, // lower → faster start
        maxBufferMs: 10000, // enough for stability
        bufferForPlaybackMs: 300, // super fast start
        bufferForPlaybackAfterRebufferMs: 1000,
      ),
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        maxCacheSize: 500 * 1024 * 1024, // 50 MB
        maxCacheFileSize: 50 * 1024 * 1024, // 10 MB per file
      ),
    );

    final betterPlayerConfiguration = BetterPlayerConfiguration(
      looping: false,
      allowedScreenSleep: false,
      controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
    );

    final controller = BetterPlayerController(
      betterPlayerConfiguration,
      betterPlayerDataSource: dataSource,
    );
    // Save immediately

    // Wait until ready
    await controller.setVolume(0);
  }
}
