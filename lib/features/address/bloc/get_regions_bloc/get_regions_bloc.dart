import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meninki/features/address/data/address_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../models/region.dart';

part 'get_regions_event.dart';
part 'get_regions_state.dart';

class GetRegionsBloc extends Bloc<GetRegionsEvent, GetRegionsState> {
  final AddressRemoteDataSource ds;
  List<Region> regions = [];

  int page = 1;
  int limit = 20;
  bool canPag = false;
  Query? lastQuery;

  GetRegionsBloc(this.ds) : super(GetRegionInitial()) {
    on<GetRegionsEvent>((event, emit) async {
      if (event is GetRegion) {
        canPag = false;
        lastQuery = event.query;
        emit(GetRegionLoading());
        emit(await _getRegions(event));
      }

      if (event is RegionPag) {
        if (!canPag) return;

        canPag = false;
        emit(RegionPagLoading(regions));
        emit(await _paginate(event));
      }

      if (event is ClearRegions) {
        regions = [];
        page = 1;
        emit(GetRegionInitial());
      }
    });
  }

  /// Used by RefreshIndicator
  Future<void> refresh() async {
    final completer = Completer<void>();

    late final StreamSubscription sub;
    sub = stream.listen((state) {
      if (state is GetRegionSuccess || state is GetRegionFailed) {
        completer.complete();
        sub.cancel();
      }
    });

    canPag = false;
    emit(await _getRegions(GetRegion(lastQuery)));

    return completer.future;
  }

  Future<GetRegionsState> _paginate(RegionPag event) async {
    page += 1;

    final failOrNot = await ds.getRegions(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: "id",
        orderDirection: "asc",
      ),
    );

    return failOrNot.fold((l) => GetRegionFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      regions.addAll(r);
      if (r.length == limit) canPag = true;
      return GetRegionSuccess(regions, r.length == limit);
    });
  }

  Future<GetRegionsState> _getRegions(GetRegion event) async {
    page = 1;

    final failOrNot = await ds.getRegions(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderBy: "id",
        orderDirection: "asc",
      ),
    );

    return failOrNot.fold((l) => GetRegionFailed(message: l.message, statusCode: l.statusCode), (
      r,
    ) {
      if (r.length == limit) canPag = true;
      regions = r;
      return GetRegionSuccess(r, r.length == limit);
    });
  }
}
