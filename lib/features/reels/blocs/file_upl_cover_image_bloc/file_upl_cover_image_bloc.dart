import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/blocs/file_processing_cubit/file_processing_cubit.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/api.dart';
import '../../../../core/injector.dart';
import '../../model/meninki_file.dart';

part 'file_upl_cover_image_event.dart';
part 'file_upl_cover_image_state.dart';

class FileUplCoverImageBloc extends Bloc<FileUplCoverImageEvent, FileUplCoverImageState> {
  final ReelsRemoteDataSource ds;
  FileUplCoverImageBloc(this.ds) : super(FileUplCoverImageInitial()) {
    on<FileUplCoverImageEvent>((event, emit) async {
      if (event is UploadFile) {
        await _onUploadFileRequested(event, emit);
      }
      if (event is Clear) {
        emit.call(FileUplCoverImageInitial());
      }
    });
  }

  Future<void> _onUploadFileRequested(
    UploadFile event,
    Emitter<FileUplCoverImageState> emit,
  ) async {
    emit(FileUploadingCoverImage(0, event.file));

    try {
      await for (final (progress, file) in ds.uploadFile(event.file)) {
        emit(FileUploadingCoverImage(progress, event.file));

        if (file != null) {
          emit(FileUploadCoverImageSuccess(file));

          if (file.status == 'pending' || file.status == 'processing') {
            sl<FileProcessingCubit>().trackFile(file);
          }
        }
      }
    } catch (e) {
      emit(FileUploadCoverImageFailure(handleError(e)));
    }
  }

  //ready
  //failed
  //pending
  //processing
}
