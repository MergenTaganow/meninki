import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/api.dart';
import '../../model/meninki_file.dart';

part 'file_upl_event.dart';
part 'file_upl_state.dart';

class FileUplBloc extends Bloc<FileUplEvent, FileUplState> {
  final ReelsRemoteDataSource ds;
  FileUplBloc(this.ds) : super(FileUplInitial()) {
    on<FileUplEvent>((event, emit) async {
      if (event is UploadFile) {
        await _onUploadFileRequested(event, emit);
      }
    });
  }

  Future<void> _onUploadFileRequested(UploadFile event, Emitter<FileUplState> emit) async {
    emit(FileUploading(0));

    // try {
    await for (final (progress, file) in ds.uploadFile(event.file)) {
      emit(FileUploading(progress));

      if (file != null) {
        emit(FileUploadSuccess(file));
      }
    }
    // } catch (e) {
    //   emit(FileUploadFailure(handleError(e)));
    // }
  }
}
