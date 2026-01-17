part of 'file_processing_cubit.dart';

@immutable
abstract class FileProcessingState {}

class FileProcessingInitial extends FileProcessingState {}

class FileProcessingUpdated extends FileProcessingState {
  final MeninkiFile file;

  FileProcessingUpdated(this.file);
}

class FileProcessingFailure extends FileProcessingState {
  final Failure failure;

  FileProcessingFailure(this.failure);
}