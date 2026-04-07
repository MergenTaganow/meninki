import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../auth/data/auth_remote_data_source.dart';
import '../../../reels/model/query.dart';
import '../../models/notification_meninki.dart';

part 'get_notifications_event.dart';
part 'get_notifications_state.dart';

class GetNotificationsBloc extends Bloc<GetNotificationsEvent, GetNotificationsState> {
  final AuthRemoteDataSource ds;

  List<NotificationMeninki> notifications = [];

  int page = 1;
  int limit = 10;
  bool canPag = false;
  Query? lastQuery;

  GetNotificationsBloc(this.ds) : super(GetNotificationsInitial()) {
    on<GetNotificationsEvent>((event, emit) async {
      if (event is GetNotifications) {
        canPag = false;
        lastQuery = event.query;
        emit(GetNotificationsLoading());
        emit(await _getNotifications(event));
      }

      if (event is NotificationsPag) {
        if (!canPag) return;

        canPag = false;
        emit(NotificationsPagLoading(notifications));
        emit(await _paginate(event));
      }

      if (event is ClearNotifications) {
        notifications = [];
        page = 1;
        emit(GetNotificationsInitial());
      }
    });
  }

  /// Refresh for RefreshIndicator
  Future<void> refresh() async {
    final completer = Completer<void>();

    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetNotificationsSuccess || state is GetNotificationsFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getNotifications(GetNotifications(lastQuery)));

    return completer.future;
  }

  Future<GetNotificationsState> _paginate(NotificationsPag event) async {
    page += 1;

    final failOrNot = await ds.getNotifications(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold(
      (l) => GetNotificationsFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        notifications.addAll(r);
        if (r.length == limit) canPag = true;
        return GetNotificationsSuccess(notifications, r.length == limit);
      },
    );
  }

  Future<GetNotificationsState> _getNotifications(GetNotifications event) async {
    page = 1;

    final failOrNot = await ds.getNotifications(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: 'id',
        orderDirection: 'desc',
      ),
    );

    return failOrNot.fold(
      (l) => GetNotificationsFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        if (r.length == limit) canPag = true;
        notifications = r;
        return GetNotificationsSuccess(r, r.length == limit);
      },
    );
  }
}
