import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../data/reels_remote_data_source.dart';
import '../../model/meninki_file.dart';

part 'file_processing_state.dart';

class FileProcessingCubit extends Cubit<FileProcessingState> {
  final ReelsRemoteDataSource ds;

  FileProcessingCubit(this.ds) : super(FileProcessingInitial());

  final Set<int> _processingIds = {};

  void trackFile(MeninkiFile file) {
    if (file.status == 'ready' || file.status == 'failed') return;

    if (_processingIds.contains(file.id)) return;

    _processingIds.add(file.id);
    _poll(file.id);
  }

  void stopAll() {
    _processingIds.clear();
    emit(FileProcessingInitial());
  }

  Future<void> _poll(int fileId) async {
    while (!isClosed && _processingIds.contains(fileId)) {
      await Future.delayed(const Duration(seconds: 3));

      final result = await ds.getFileById(fileId);

      result.fold(
        (failure) {
          // emit(FileProcessingFailure(failure));
          // _processingIds.remove(fileId);
        },
        (file) {
          emit(FileProcessingUpdated(file));

          if (file.status == 'ready' || file.status == 'failed') {
            _processingIds.remove(fileId);
          }
        },
      );
    }
  }
}
