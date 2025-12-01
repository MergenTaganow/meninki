part of 'file_upl_cover_image_bloc.dart';

@immutable
sealed class FileUplCoverImageEvent {}

class UploadFile extends FileUplCoverImageEvent {
  final File file;

  UploadFile(this.file);
}

class Clear extends FileUplCoverImageEvent {}
