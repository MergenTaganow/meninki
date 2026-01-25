import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reorderable_grid_view/widgets/reorderable_builder.dart';
import 'package:meninki/core/go.dart';
import 'package:meninki/core/helpers.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:meninki/features/store/bloc/store_create_cubit/store_create_cubit.dart';
import 'package:meninki/features/store/models/market.dart';
import '../../../core/colors.dart';
import '../../../core/failure.dart';
import '../../global/widgets/custom_snack_bar.dart';
import '../../global/widgets/meninki_network_image.dart';
import '../../product/widgets/uploading_file.dart';
import '../../reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import '../../reels/blocs/file_upl_bloc/file_upl_bloc.dart';
import '../bloc/get_market_by_id/get_market_by_id_cubit.dart';

class MarketBannersPage extends StatefulWidget {
  final Market market;

  const MarketBannersPage({required this.market, super.key});

  @override
  State<MarketBannersPage> createState() => _MarketBannersPageState();
}

class _MarketBannersPageState extends State<MarketBannersPage> {
  List<MeninkiFile> files = [];
  final _wrapViewKey = GlobalKey();

  @override
  void initState() {
    for (var i in widget.market.files!) {
      files.add(i.copyWith(status: 'ready'));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations lg = AppLocalizations.of(context)!;
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreCreateCubit, StoreCreateState>(
          listener: (context, state) {
            if (state is StoreEditSuccess) {
              context.read<GetMarketByIdCubit>().getStoreById(widget.market.id);
              CustomSnackBar.showSnackBar(context: context, title: lg.success, isError: false);
              Go.pop();
            }
          },
        ),
        BlocListener<FileUplBloc, FileUplState>(
          listener: (context, state) {
            if (state is FileUploadSuccess && state.type == UploadingFileTypes.marketBanners) {
              files.add(state.file);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {});
              });
            }
          },
        ),
        BlocListener<FileProcessingCubit, FileProcessingState>(
          listener: (context, state) {
            if (state is FileProcessingUpdated) {
              var index = files.indexWhere((element) => element.id == state.file.id);
              if (index != -1) {
                files[index] = state.file;
                setState(() {});
              }
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Обявлния магазина")),
        body: Padd(
          hor: 10,
          ver: 14,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Вы можете выбырать последоватолностъ обявлений",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                    ),
                    const SizedBox(height: 20),

                    ReorderableBuilder(
                      enableDraggable: true,
                      onReorder: (ReorderedListFunction reorderedListFunction) {
                        setState(() {
                          files = reorderedListFunction(files) as List<MeninkiFile>;
                        });
                      },
                      builder: (List<Widget> children) {
                        return Wrap(
                          key: _wrapViewKey,
                          spacing: 14,
                          runSpacing: 14,
                          children: children,
                        );
                      },
                      children:
                          files
                              .map(
                                (e) => SizedBox(
                                  key: Key(e.id.toString()),
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
                                          child:
                                              ((e.status == 'ready' &&
                                                      (e.resizedFiles?.small?.isNotEmpty ?? false))
                                                  ? MeninkiNetworkImage(
                                                    file: e,
                                                    networkImageType: NetworkImageType.small,
                                                    fit: BoxFit.cover,
                                                  )
                                                  : Image.asset(
                                                    'assets/images/app_logo.png',
                                                    fit: BoxFit.cover,
                                                  )),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: GestureDetector(
                                            onTap: () {
                                              files.removeWhere((rem) => rem.id == e.id);
                                              setState(() {});
                                            },
                                            child: Icon(Icons.cancel, color: Color(0xFFF3F3F3)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                    ),

                    const SizedBox(height: 20),
                    Divider(),
                    const SizedBox(height: 20),

                    BlocBuilder<FileUplBloc, FileUplState>(
                      builder: (context, state) {
                        List<File> uploadingFiles = [];
                        List<double> uploadingValues = [];
                        List<File>? errorFiles = [];
                        List<Failure>? errors = [];
                        if (state is FileUploading &&
                            state.type == UploadingFileTypes.marketBanners) {
                          uploadingFiles = state.uploadingFiles.keys.toList();
                          uploadingValues = state.uploadingFiles.values.toList();
                          errorFiles = state.errorMap?.keys.toList();
                          errors = state.errorMap?.values.toList();
                        }

                        return Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            ...List.generate(uploadingFiles.length, (index) {
                              return UploadingImageCard(
                                file: uploadingFiles[index],
                                value: uploadingValues[index],
                                onRemoveTap: () {
                                  context.read<FileUplBloc>().add(
                                    RemoveFile(uploadingFiles[index]),
                                  );
                                },
                              );
                            }),
                            ...List.generate(errorFiles?.length ?? 0, (index) {
                              return UploadingImageCard(
                                file: errorFiles![index],
                                failure: errors![index],
                                onRemoveTap: () {
                                  context.read<FileUplBloc>().add(
                                    RemoveFile(uploadingFiles[index]),
                                  );
                                },
                                onRetryTap: () {
                                  context.read<FileUplBloc>().add(
                                    RetryFile(errorFiles![index], UploadingFileTypes.marketBanners),
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
                                        UploadFiles(files, UploadingFileTypes.marketBanners),
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
                                      children: [
                                        const Icon(Icons.add_circle, color: Colors.black),
                                        const SizedBox(height: 4),
                                        Text(
                                          AppLocalizations.of(context)!.addMoreMedia,
                                          style: const TextStyle(fontSize: 12),
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
                  ],
                ),
              ),
              Padd(
                bot: 20,
                child: BlocBuilder<StoreCreateCubit, StoreCreateState>(
                  builder: (context, state) {
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      splashColor: Colors.white.withOpacity(0.22),
                      highlightColor: Colors.white.withOpacity(0.10),
                      onTap: () {
                        if (state is! StoreCreateLoading) {
                          context.read<StoreCreateCubit>().editStoreFiles(widget.market.id, files);
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
                              state is StoreCreateLoading
                                  ? SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: const CircularProgressIndicator(color: Colors.white),
                                  )
                                  : Text(lg.save, style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
