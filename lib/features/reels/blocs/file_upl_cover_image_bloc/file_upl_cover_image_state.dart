part of 'file_upl_cover_image_bloc.dart';

@immutable
sealed class FileUplCoverImageState {}

final class FileUplCoverImageInitial extends FileUplCoverImageState {}

class FileUploadingCoverImage extends FileUplCoverImageState {
  final double progress;
  final File file;

  FileUploadingCoverImage(this.progress, this.file);
}

class FileUploadCoverImageSuccess extends FileUplCoverImageState {
  final MeninkiFile file;

  FileUploadCoverImageSuccess(this.file);
}

class FileUploadCoverImageFailure extends FileUplCoverImageState {
  final Failure failure;

  FileUploadCoverImageFailure(this.failure);
}
