import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meninki/features/store/models/market.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../model/query.dart';

part 'get_reel_markets_event.dart';
part 'get_reel_markets_state.dart';

class ReelMarket {
  String reel_count;
  Market? market;

  ReelMarket({required this.reel_count, required this.market});

  factory ReelMarket.fromJson(Map<String, dynamic> json) {
    return ReelMarket(
      reel_count: (json["reel_count"]),
      market: json["market"] != null ? Market.fromJson(json["market"]) : null,
    );
  }
}

class GetReelMarketsBloc extends Bloc<GetReelMarketsEvent, GetReelMarketsState> {
  final ReelsRemoteDataSource ds;
  List<ReelMarket> reelMarkets = [];

  int page = 1;
  int limit = 10;
  bool canPag = false;

  GetReelMarketsBloc(this.ds) : super(GetReelMarketsInitial()) {
    on<GetReelMarketsEvent>((event, emit) async {
      if (event is GetReelMarkets) {
        emit(GetReelMarketsLoading());

        canPag = false;
        emit(await _getReelMarkets(event));
      }

      if (event is PaginateReelMarkets) {
        if (!canPag) return;

        emit(GetReelMarketsPaginating());
        canPag = false;
        emit(await _paginate(event));
      }
    });
  }

  Future<GetReelMarketsState> _getReelMarkets(GetReelMarkets event) async {
    page = 1;
    final failOrNot = await ds.getReelMarkets(
      Query(
        limit: limit,
        offset: page,
        keyword: event.search ?? '',
        orderDirection: 'asc',
        orderBy: 'created_at',
      ),
    );
    return failOrNot.fold((l) => GetReelMarketsFailed(l), (r) {
      if (r.length == limit) canPag = true;
      reelMarkets = r;
      return GetReelMarketsSuccess(reelMarkets);
    });
  }

  Future<GetReelMarketsState> _paginate(PaginateReelMarkets event) async {
    await Future.delayed(const Duration(milliseconds: 400));
    page++;

    final failOrNot = await ds.getReelMarkets(
      Query(
        offset: page,
        limit: limit,
        keyword: event.search,
        orderDirection: 'asc',
        orderBy: 'created_at',
      ),
    );

    return failOrNot.fold((l) => GetReelMarketsFailed(l), (r) {
      if (r.length == limit) canPag = true;
      reelMarkets.addAll(r);
      return GetReelMarketsSuccess(reelMarkets);
    });
  }
}
