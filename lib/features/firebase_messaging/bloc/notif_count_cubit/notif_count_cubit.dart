import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'notif_count_state.dart';

class NotifCountCubit extends Cubit<NotifCountState> {
  final AuthRemoteDataSource ds;
  NotifCountCubit(this.ds) : super(NotifCountInitial());

  init() async {
    emit(NotifCountLoading());
    var failOrNot = await ds.getNotifCount();
    failOrNot.fold((l) => emit(NotifCountFailed(l)), (r) => emit(NotifCountSuccess(r)));
  }

  refresh() async {
    var failOrNot = await ds.getNotifCount();
    failOrNot.fold((l) => emit(NotifCountFailed(l)), (r) => emit(NotifCountSuccess(r)));
  }
}
