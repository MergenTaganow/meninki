import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../data/add_remote_data_source.dart';
import '../../models/add.dart';

part 'get_adds_event.dart';
part 'get_adds_state.dart';

class GetAddsBloc extends Bloc<GetAddsEvent, GetAddsState> {
  final AddRemoteDataSource ds;
  List<Add> adds = [];

  int page = 1;
  int limit = 20;
  bool canPag = false;
  Query? lastQuery;

  GetAddsBloc(this.ds) : super(GetAddInitial()) {
    on<GetAddsEvent>((event, emit) async {
      if (event is GetAdd) {
        canPag = false;

        lastQuery = event.query;
        emit.call(GetAddLoading());
        emit.call(await _getAdds(event));
      }

      if (event is AddPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(AddPagLoading(adds));
        emit.call(await _paginate(event));
      }

      if (event is ClearAdds) {
        adds = [];
        page = 1;
        emit.call(GetAddInitial());
      }
    });
  }

  /// This is what your RefreshIndicator will call
  Future<void> refresh() async {
    final completer = Completer<void>();

    // listen once for the next success or error state
    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetAddSuccess || state is GetAddFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getAdds(GetAdd(lastQuery)));

    return completer.future;
  }

  Future<GetAddsState> _paginate(AddPag event) async {
    page += 1;

    final failOrNot = await ds.getAdds(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: event.query?.orderBy ?? 'id',
        orderDirection: event.query?.orderDirection ?? 'desc',
      ),
    );

    return failOrNot.fold((l) => GetAddFailed(message: l.message, statusCode: l.statusCode), (r) {
      adds.addAll(r);
      if (r.length == limit) canPag = true;
      return GetAddSuccess(adds, r.length == limit);
    });
  }

  Future<GetAddsState> _getAdds(GetAdd event) async {
    page = 1;

    final failOrNot = await ds.getAdds(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: event.query?.orderBy ?? 'id',
        orderDirection: event.query?.orderDirection ?? 'desc',
      ),
    );

    return failOrNot.fold((l) => GetAddFailed(message: l.message, statusCode: l.statusCode), (r) {
      if (r.length == limit) canPag = true;
      adds = r;
      return GetAddSuccess(r, r.length == limit);
    });
  }
}

class GetMyAddsBloc extends GetAddsBloc {
  GetMyAddsBloc(super.ds);
}

class GetFavoriteAddsBloc extends GetAddsBloc {
  GetFavoriteAddsBloc(super.ds);
}
