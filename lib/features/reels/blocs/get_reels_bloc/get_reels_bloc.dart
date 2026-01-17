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

  GetVerifiedReelsBloc(this.ds) : super(GetReelInitial()) {
    on<GetReelsEvent>((event, emit) async {
      if (event is GetReel) {
        canPag = false;

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
    });
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
                orderDirection: event.query?.orderDirection ?? 'asc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            )
            : await ds.getReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'asc',
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
                orderDirection: event.query?.orderDirection ?? 'asc',
                orderBy: event.query?.orderBy ?? 'created_at',
              ),
            )
            : await ds.getReels(
              (event.query ?? Query()).copyWith(
                offset: page,
                limit: limit,
                orderDirection: event.query?.orderDirection ?? 'asc',
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
