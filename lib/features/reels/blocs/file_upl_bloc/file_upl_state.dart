part of 'file_upl_bloc.dart';

@immutable
sealed class FileUplState {}

final class FileUplInitial extends FileUplState {}

class FileUploading extends FileUplState {
  final Map<File, double> uploadingFiles;
  final Map<File, Failure>? errorMap;
  final UploadingFileTypes type;
  FileUploading({required this.uploadingFiles, required this.type, this.errorMap});
}

class FileUploadSuccess extends FileUplState {
  final MeninkiFile file;
  final UploadingFileTypes type;
  FileUploadSuccess(this.file, this.type);
}

class FileUploadFailure extends FileUplState {
  final Failure failure;

  FileUploadFailure(this.failure);
}
