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

  GetMyReelsBloc(this.ds) : super(GetMyReelInitial()) {
    on<GetMyReelsEvent>((event, emit) async {
      if (event is GetMyReel) {
        canPag = false;

        emit.call(GetMyReelLoading());
        emit.call(await _getReels(event));
      }

      if (event is MyReelPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(MyReelPagLoading(reels));
        emit.call(await _paginate(event));
      }
    });
  }

  Future<GetMyReelsState> _paginate(MyReelPag event) async {
    page += 1;

    final failOrNot = await ds.getMyReels(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        sortAs: event.query?.sortAs ?? 'asc',
        sortBy: event.query?.sortBy ?? 'created_at',
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
        sortAs: event.query?.sortAs ?? 'asc',
        sortBy: event.query?.sortBy ?? 'created_at',
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
