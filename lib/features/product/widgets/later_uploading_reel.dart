import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/colors.dart';
import '../../../core/go.dart';
import '../../../core/helpers.dart';
import '../../../core/routes.dart';
import '../../reels/blocs/file_upl_cover_image_bloc/file_upl_cover_image_bloc.dart';
import '../../reels/blocs/reel_create_cubit/reel_create_cubit.dart';
import '../models/product.dart';

class LaterUploadingReel extends StatelessWidget {
  final Product product;
  const LaterUploadingReel({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReelCreateCubit, ReelCreateState>(
      builder: (context, reelCreateState) {
        if (reelCreateState is LaterCreateReel) {}
        if (reelCreateState is LaterCreateReel && reelCreateState.map['link_id'] == product.id) {
          return Container(
            height: 66,
            decoration: BoxDecoration(
              color: Color(0xFFF3F3F3),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: BlocBuilder<FileUplCoverImageBloc, FileUplCoverImageState>(
              builder: (context, fileState) {
                if (fileState is FileUploadCoverImageFailure) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Reel uploading error',
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Box(w: 10),
                      InkWell(
                        onTap: () {
                          Go.to(
                            Routes.reelCreatePage,
                            argument: {'laterCreateReel': reelCreateState.map, 'product': product},
                          );
                        },
                        child: Container(
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(child: Icon(Icons.refresh, color: Col.black)),
                        ),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Text(
                      'Reel is uploading',
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Box(w: 10),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: fileState is FileUploadingCoverImage ? fileState.progress : null,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
