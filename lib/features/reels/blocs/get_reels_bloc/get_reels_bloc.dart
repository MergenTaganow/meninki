import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/reels_remote_data_source.dart';
import '../../model/query.dart';
import '../../model/reels.dart';

part 'get_reels_event.dart';
part 'get_reels_state.dart';

class GetVerifiedReelsBloc extends Bloc<GetReelsEvent, GetReelsState> {
  final ReelsRemoteDataSource ds;
  List<Reel> reels = [];

  int page = 1;
  int limit = 15;
  bool canPag = false;
  Query? lastQuery;

  GetVerifiedReelsBloc(this.ds) : super(GetReelInitial()) {
    on<GetReelsEvent>((event, emit) async {
      if (event is GetReel) {
        canPag = false;
        lastQuery = event.query;
        emit.call(GetReelLoading());
        emit.call(await _getReels(event));
      }

      if (event is ReelPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(ReelPagLoading(reels));
        emit.call(await _paginate(event));
      }
      if (event is ClearReels) {
        reels = [];
        page = 1;
        emit.call(GetReelInitial());
      }
      if (event is UpdateReels) {
        var index = reels.indexWhere((e) => e.id == event.reel.id);
        if (index == -1) return;
        reels[index] = event.reel;
        emit.call(GetReelSuccess(reels, true));
      }
    });
  }

  /// This is what your RefreshIndicator will call
  Future<void> refresh() async {
    final completer = Completer<void>();

    // listen once for the next success or error state
    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetReelSuccess || state is GetReelFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    emit.call(await _getReels(GetReel(lastQuery)));

    return completer.future;
  }

  Future<GetReelsState> _paginate(ReelPag event) async {
    page += 1;

    final failOrNot =
        (event.query?.filtered ?? false)
            ///This is wrong but was made for extend Blocs filter problems in endpoint
            ? await ds.getFilteredReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'desc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            )
            : await ds.getReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'desc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            );

    return failOrNot.fold((l) => GetReelFailed(message: l.message, statusCode: l.statusCode), (r) {
      reels.addAll(r);
      if (r.length == limit) canPag = true;
      return GetReelSuccess(reels, r.length == limit);
    });
  }

  Future<GetReelsState> _getReels(GetReel event) async {
    page = 1;

    final failOrNot =
        (event.query?.filtered ?? false)
            ///This is wrong but was made for extend Blocs filter problems in endpoint
            ? await ds.getFilteredReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'desc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            )
            : await ds.getReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'desc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            );

    return failOrNot.fold((l) => GetReelFailed(message: l.message, statusCode: l.statusCode), (r) {
      if (r.length == limit) canPag = true;
      reels = r;
      return GetReelSuccess(r, r.length == limit);
    });
  }
}

class GetProductReelsBloc extends GetVerifiedReelsBloc {
  GetProductReelsBloc(super.ds);
}

class GetStoreReelsBloc extends GetVerifiedReelsBloc {
  GetStoreReelsBloc(super.ds);
}

class GetSearchedReelsBloc extends GetVerifiedReelsBloc {
  GetSearchedReelsBloc(super.ds);
}
