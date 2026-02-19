import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meninki/features/firebase_messaging/models/notification_meninki.dart';


part 'notification_tap_state.dart';

class NotificationTapCubit extends Cubit<NotificationTapState> {
  NotificationTapCubit() : super(NotificationTapInitial());

  void moveTo({required NotificationMeninki? notification}) {
    emit.call(NotificationTapLoading());

    emit.call(NotificationTapSuccess(notification: notification));
  }

  void onMessage(Map<String, dynamic> data) {
    emit.call(NotificationTapLoading());
    emit.call(NotificationOnMessage(data));
  }
}
