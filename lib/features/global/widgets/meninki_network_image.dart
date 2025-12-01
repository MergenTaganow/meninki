import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../../../core/api.dart';
import '../../reels/model/meninki_file.dart';

enum NetworkImageType { small, medium, large }

class MeninkiNetworkImage extends StatelessWidget {
  final MeninkiFile file;
  final NetworkImageType networkImageType;
  final BoxFit? fit;
  const MeninkiNetworkImage({
    required this.file,
    required this.networkImageType,
    super.key,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl:
          '$baseUrl/public/${networkImageType == NetworkImageType.small
              ? file.resizedFiles?.small
              : networkImageType == NetworkImageType.medium
              ? file.resizedFiles?.medium
              : networkImageType == NetworkImageType.large
              ? file.resizedFiles?.large
              : ""}',
      fit: fit,
      placeholder:
          (context, url) =>
              (file.blurhash?.isNotEmpty ?? false)
                  ? BlurHash(hash: file.blurhash ?? "")
                  : Center(
                    child: SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
                  ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
