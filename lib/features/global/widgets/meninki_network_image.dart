import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../../../core/api.dart';
import '../../reels/model/meninki_file.dart';
import '../pages/image_viewer.dart';

enum NetworkImageType { small, medium, large }

class MeninkiNetworkImage extends StatelessWidget {
  final List<MeninkiFile>? otherFiles;
  final MeninkiFile file;
  final NetworkImageType networkImageType;
  final BoxFit? fit;
  const MeninkiNetworkImage({
    required this.file,
    required this.networkImageType,
    this.otherFiles,
    this.fit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var url =
        '$baseUrl/public/${networkImageType == NetworkImageType.small
            ? file.resizedFiles?.small
            : networkImageType == NetworkImageType.medium
            ? file.resizedFiles?.medium
            : networkImageType == NetworkImageType.large
            ? file.resizedFiles?.large
            : ""}';
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder:
                (context) => CustomImageViewer(
                  url: url,
                  blurhash: file.blurhash,
                  otherFiles: otherFiles,
                  // type: type,
                  file: file,
                ),
          ),
        );
      },
      child: CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder:
            (context, url) =>
                (file.blurhash?.isNotEmpty ?? false)
                    ? BlurHash(hash: file.blurhash ?? "")
                    : Container(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
