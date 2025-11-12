part of 'file_upl_bloc.dart';

@immutable
sealed class FileUplState {}

final class FileUplInitial extends FileUplState {}

class FileUploading extends FileUplState {
  final double progress;

  FileUploading(this.progress);
}

class FileUploadSuccess extends FileUplState {
  final MeninkiFile file;

  FileUploadSuccess(this.file);
}

class FileUploadFailure extends FileUplState {
  final Failure failure;

  FileUploadFailure(this.failure);
}
