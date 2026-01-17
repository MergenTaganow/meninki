// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:meninki/features/reels/model/meninki_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../core/api.dart';
import '../../../core/colors.dart';
import '../../../core/helpers.dart';

class CustomImageViewer extends StatefulWidget {
  const CustomImageViewer({
    super.key,
    required this.url,
    // this.type,
    this.otherFiles,
    this.path,
    this.file,
    this.blurhash,
  });
  final String url;
  final MeninkiFile? file;
  final List<MeninkiFile?>? otherFiles;
  final String? path;
  final String? blurhash;
  // final String? type;

  @override
  State<CustomImageViewer> createState() => _CustomImageViewerState();
}

class _CustomImageViewerState extends State<CustomImageViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  bool dataVisible = true;
  String localDownloadsDirectory = '';
  var fileExists = false;

  @override
  void initState() {
    super.initState();
    if (widget.file != null && (widget.otherFiles?.isNotEmpty ?? false)) {
      _currentIndex = widget.otherFiles?.indexWhere((e) => e?.id == widget.file?.id) ?? 0;
      _pageController = PageController(initialPage: _currentIndex);
    }
  }

  getLocation() async {
    localDownloadsDirectory =
        (Platform.isAndroid
                ? await getExternalStorageDirectory()
                : await getApplicationDocumentsDirectory())!
            .path;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Col.black,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.path != null) Image.memory(File(widget.path!).readAsBytesSync()),
              if (widget.path == null && (widget.otherFiles?.isEmpty ?? true))
                Padd(
                  top: 50,
                  bot: 20,
                  child: PhotoView(
                    backgroundDecoration: const BoxDecoration(color: Col.black),
                    minScale: PhotoViewComputedScale.contained,
                    imageProvider: CachedNetworkImageProvider(widget.url),
                    loadingBuilder: (context, event) {
                      if (event?.expectedTotalBytes != null) {
                        int total = (event?.expectedTotalBytes)!;
                        return widget.blurhash != null
                            ? BlurHash(hash: widget.blurhash!)
                            : Center(
                              child: Box(
                                d: 40,
                                child: CircularProgressIndicator(
                                  value: (event?.cumulativeBytesLoaded ?? 1) / total,
                                ),
                              ),
                            );
                      }
                      return SizedBox(height: 40, width: 40, child: CircularProgressIndicator());
                    },
                  ),
                ),
              if (widget.path == null && (widget.otherFiles?.isNotEmpty ?? false))
                Padd(
                  top: 50,
                  bot: 80,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        dataVisible = !dataVisible;
                      });
                    },
                    child: PhotoViewGallery.builder(
                      pageController: _pageController,
                      itemCount: widget.otherFiles?.length,
                      backgroundDecoration: const BoxDecoration(color: Col.black),
                      builder: (context, index) {
                        final item = widget.otherFiles?[index];
                        // final EmployeeLocalDataSource emplDs = sl();
                        // var rooturl = '';
                        // String tp = widget.type ?? '';
                        var rootUrl =
                            '$baseUrl/public/${item?.resizedFiles?.large ?? item?.resizedFiles?.medium ?? item?.resizedFiles?.small}';
                        // String ext = (item?.name ?? '').split('.').last.toLowerCase();
                        // var icon = FileFormats.icons[ext];
                        // if (icon == 'img') {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: CachedNetworkImageProvider(rootUrl),
                          minScale: PhotoViewComputedScale.contained,
                          heroAttributes: PhotoViewHeroAttributes(tag: rootUrl),
                        );
                        // } else {
                        //   // var filePath = '$localDownloadsDirectory/${'${item?.uuid ?? ''}.$ext'}';
                        //   // appLog(filePath);
                        //
                        //   return PhotoViewGalleryPageOptions.customChild(
                        //     child: StatefulBuilder(
                        //       builder: (context, setState2) {
                        //         Future.delayed(const Duration(milliseconds: 1)).then((_) async {
                        //           fileExists = await fileExistsFunction(item!);
                        //           setState2(() {});
                        //         });
                        //         return Center(
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Svvg.asset(
                        //                 icon ?? 'errorIcon',
                        //                 fileName: 'file_types',
                        //                 h: 80,
                        //                 w: 80,
                        //               ),
                        //               const SizedBox(height: 14),
                        //               Text(
                        //                 item?.name ?? '',
                        //                 style: const TextStyle(color: Colors.white),
                        //               ),
                        //               const SizedBox(height: 24),
                        //               BlocBuilder<FileDownloadCubit, FileDownloadState>(
                        //                 builder: (context, state) {
                        //                   if (state is FileDownloadSuccess) {}
                        //                   if (state is FileDownloadSuccess &&
                        //                       state.file.uuid == item?.uuid) {
                        //                     setState2(() {
                        //                       fileExists = true;
                        //                     });
                        //                   }
                        //                   if (state is FileDownloading) {
                        //                     var indexInDownloadList = state.downloadingFiles
                        //                         .indexWhere((e) => e.uuid == item?.uuid);
                        //                     double? progressValue;
                        //                     if (indexInDownloadList != -1) {
                        //                       progressValue =
                        //                           state.downloadingProgress[indexInDownloadList];
                        //                     }
                        //                     return Column(
                        //                       mainAxisSize: MainAxisSize.min,
                        //                       children: [
                        //                         if (progressValue != null)
                        //                           Container(
                        //                             width: MediaQuery.of(context).size.width * 0.6,
                        //                             margin: const EdgeInsets.only(bottom: 24),
                        //                             child: Row(
                        //                               children: [
                        //                                 Expanded(
                        //                                   child: LinearProgressIndicator(
                        //                                     borderRadius: BorderRadius.circular(2),
                        //                                     minHeight: 3,
                        //                                     backgroundColor: Col.passiveGreyLight,
                        //                                     color: Col.primBlue,
                        //                                     value: progressValue,
                        //                                   ),
                        //                                 ),
                        //                                 Padding(
                        //                                   padding: const EdgeInsets.only(left: 4),
                        //                                   child: Text(
                        //                                     '${(progressValue).toStringAsFixed(0)}%',
                        //                                     style: Theme.of(context)
                        //                                         .textTheme
                        //                                         .bodySmall
                        //                                         ?.copyWith(height: .5),
                        //                                   ),
                        //                                 ),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                         if ((fileExists == false) &&
                        //                             progressValue == null &&
                        //                             item != null)
                        //                           SizedBox(
                        //                             width: MediaQuery.of(context).size.width * 0.6,
                        //                             height: 30,
                        //                             child: ElevatedButton(
                        //                               style: ElevatedButton.styleFrom(
                        //                                 backgroundColor: Col.primary,
                        //                               ),
                        //                               onPressed: () {
                        //                                 context
                        //                                     .read<FileDownloadCubit>()
                        //                                     .downloadFile(item, rooturl);
                        //                               },
                        //                               child: Text('download'.translate(context)),
                        //                             ),
                        //                           ),
                        //                         if (fileExists && progressValue == null)
                        //                           SizedBox(
                        //                             width: MediaQuery.of(context).size.width * 0.6,
                        //                             height: 30,
                        //                             child: ElevatedButton(
                        //                               style: ElevatedButton.styleFrom(
                        //                                 backgroundColor: Col.primary,
                        //                               ),
                        //                               onPressed: () async {
                        //                                 late Directory directory;
                        //                                 if (Platform.isAndroid) {
                        //                                   // Using getExternalStorageDirectory() might not directly give you the Download directory.
                        //                                   // Typically it gives you the app-specific external directory which is different from the common Downloads folder.
                        //                                   directory = Directory(
                        //                                     '/storage/emulated/0/Download/Timix',
                        //                                   );
                        //                                 } else {
                        //                                   // For iOS, we use the application documents directory, but usually, iOS doesn't use a Downloads folder like Android.
                        //                                   directory = Directory(
                        //                                     '${(await getApplicationDocumentsDirectory()).path}/Timix',
                        //                                   );
                        //                                 }
                        //                                 try {
                        //                                   await OpenFile.open(
                        //                                     '${directory.path}/${item?.name}',
                        //                                   ).timeout(const Duration(seconds: 2));
                        //                                 } catch (e) {
                        //                                   CustomSnackBar.showYellowSnackBar(
                        //                                     context: context,
                        //                                     title: 'cantOpen'.translate(context),
                        //                                   );
                        //                                 }
                        //                               },
                        //                               child: Text('openIt'.translate(context)),
                        //                             ),
                        //                           ),
                        //                       ],
                        //                     );
                        //                   }
                        //                   return Container();
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   );
                        // }
                      },
                      onPageChanged: (index) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                  ),
                ),
              if (dataVisible)
                Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Col.black,
                      border: Border(
                        bottom: BorderSide(color: Colors.white.withOpacity(0.4), width: 0.5),
                      ),
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // ⬅ Back button (left aligned)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.navigate_before, color: Colors.white),
                                Text("Yza", style: const TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),

                        // ⬜ Center text (true center)
                        if (widget.otherFiles?.isNotEmpty ?? false)
                          Text(
                            '${_currentIndex + 1}/${widget.otherFiles?.length}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              if (dataVisible && (widget.otherFiles?.isNotEmpty ?? false))
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Col.black,
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.otherFiles?.length,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemBuilder: (context, index) {
                        final item = widget.otherFiles?[index];
                        final isActive = index == _currentIndex;
                        var rooturl =
                            '$baseUrl/public/${item?.resizedFiles?.small ?? item?.resizedFiles?.medium ?? item?.resizedFiles?.large}';
                        // String ext = (item?.name ?? '').split('.').last.toLowerCase();
                        // var icon = FileFormats.icons[ext];
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isActive ? Colors.white : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child:
                              // icon == 'img'
                              //     ?
                              CachedNetworkImage(
                                imageUrl: rooturl,
                                width: 45,
                                height: 60,
                                fit: BoxFit.cover,
                                placeholder: (context, _) {
                                  return item?.blurhash != null
                                      ? BlurHash(hash: item!.blurhash!)
                                      : Container(color: Colors.grey[900]);
                                },
                                errorWidget:
                                    (_, __, ___) => const Icon(Icons.error, color: Colors.white),
                              ),
                              // : SizedBox(
                              //   width: 45,
                              //   height: 60,
                              //   child: Center(
                              //     child: Svvg.asset(
                              //       icon ?? 'errorIcon',
                              //       fileName: 'file_types',
                              //       w: 25,
                              //     ),
                              //   ),
                              // ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
