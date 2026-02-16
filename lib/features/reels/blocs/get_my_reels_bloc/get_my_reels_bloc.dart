import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/reels_remote_data_source.dart';
import '../../model/query.dart';
import '../../model/reels.dart';

part 'get_my_reels_event.dart';
part 'get_my_reels_state.dart';

class GetMyReelsBloc extends Bloc<GetMyReelsEvent, GetMyReelsState> {
  final ReelsRemoteDataSource ds;
  List<Reel> reels = [];

  int page = 1;
  int limit = 15;
  bool canPag = false;
  Query? lastQuery;

  GetMyReelsBloc(this.ds) : super(GetMyReelInitial()) {
    on<GetMyReelsEvent>((event, emit) async {
      if (event is GetMyReel) {
        canPag = false;
        lastQuery = event.query;

        emit.call(GetMyReelLoading());
        emit.call(await _getReels(event));
      }

      if (event is MyReelPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(MyReelPagLoading(reels));
        emit.call(await _paginate(event));
      }
      if (event is UpdateMyReel) {
        var index = reels.indexWhere((e) => e.id == event.reel.id);
        if (index == -1) return;
        reels[index] = event.reel;
        emit.call(GetMyReelSuccess(reels, true));
      }
    });
  }

  /// This is what your RefreshIndicator will call
  Future<void> refresh() async {
    final completer = Completer<void>();

    // listen once for the next success or error state
    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetMyReelSuccess || state is GetMyReelFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    emit.call(await _getReels(GetMyReel(lastQuery)));

    return completer.future;
  }

  Future<GetMyReelsState> _paginate(MyReelPag event) async {
    page += 1;

    final failOrNot = await ds.getMyReels(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'created_at',
      ),
    );

    return failOrNot.fold((l) => GetMyReelFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      reels.addAll(r);
      if (r.length == limit) canPag = true;
      return GetMyReelSuccess(reels, r.length == limit);
    });
  }

  Future<GetMyReelsState> _getReels(GetMyReel event) async {
    page = 1;

    final failOrNot = await ds.getMyReels(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'created_at',
      ),
    );

    return failOrNot.fold((l) => GetMyReelFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.length == limit) canPag = true;
      reels = r;
      return GetMyReelSuccess(r, r.length == limit);
    });
  }
}
