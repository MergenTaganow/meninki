import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../../core/api.dart';
import '../../model/meninki_file.dart';

part 'file_upl_event.dart';
part 'file_upl_state.dart';

enum UploadingFileTypes { productPhotos }

class FileUplBloc extends Bloc<FileUplEvent, FileUplState> {
  final ReelsRemoteDataSource ds;
  Map<File, double> uploadingFiles = {};
  Map<File, Failure> errorMap = {};
  UploadingFileTypes? lastType;
  FileUplBloc(this.ds) : super(FileUplInitial()) {
    on<FileUplEvent>((event, emit) async {
      if (event is UploadFiles) {
        if (event.type != lastType) {
          uploadingFiles = {};
          errorMap = {};
          lastType = event.type;
        }
        await _onUploadFileRequested(event, emit);
      }
      if (event is ClearUploading) {
        uploadingFiles = {};
        errorMap = {};
        lastType = null;
        emit.call(FileUplInitial());
      }

      if (event is RemoveFile) {
        uploadingFiles.remove(event.file);
        errorMap.remove(event.file);
        emit(FileUploading(uploadingFiles: uploadingFiles, type: lastType!, errorMap: errorMap));
      }

      if (event is RetryFile) {
        add(RemoveFile(event.file));
        add(UploadFiles([event.file], event.type));
      }
    });
  }

  Future<void> _onUploadFileRequested(UploadFiles event, Emitter<FileUplState> emit) async {
    for (var i in event.files) {
      uploadingFiles.addAll({i: 0});
    }
    emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));
    for (var i in event.files) {
      try {
        await for (final (progress, file) in ds.uploadFile(i)) {
          uploadingFiles[i] = progress;
          emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));

          if (file != null) {
            emit(FileUploadSuccess(file, event.type));
            uploadingFiles.remove(i);
          }
        }
      } catch (e) {
        errorMap.addAll({i: handleError(e)});
        uploadingFiles.remove(i);
        emit(FileUploading(uploadingFiles: uploadingFiles, type: event.type, errorMap: errorMap));
      }
    }
  }
}
