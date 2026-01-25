import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../../reels/model/query.dart';
import '../../data/store_remote_data_source.dart';
import '../../models/market.dart';

part 'get_my_stores_event.dart';
part 'get_my_stores_state.dart';

class GetMyStoresBloc extends Bloc<GetMyStoresEvent, GetMyStoresState> {
  final StoreRemoteDataSource ds;
  List<Market> stores = [];
  int page = 1;
  int limit = 10;
  bool canPag = false;

  GetMyStoresBloc(this.ds) : super(GetMyStoresInitial()) {
    on<GetMyStoresEvent>((event, emit) async {
      if (event is GetMyStores) {
        emit(GetMyStoresLoading());

        canPag = false;
        emit(await _getStores(event));
      }

      if (event is PaginateMyStores) {
        if (!canPag) return;

        emit(GetMyStoresPaginating());
        canPag = false;
        emit(await _paginate(event));
      }
    });
  }

  Future<GetMyStoresState> _getStores(GetMyStores event) async {
    page = 1;
    final failOrNot = await ds.getMyStores(
      Query(
        limit: limit,
        offset: page,
        keyword: event.search ?? '',
        orderDirection: 'asc',
        orderBy: 'id',
      ),
    );
    return failOrNot.fold((l) => GetMyStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores = r;
      return GetMyStoresSuccess(stores);
    });
  }

  Future<GetMyStoresState> _paginate(PaginateMyStores event) async {
    await Future.delayed(const Duration(milliseconds: 400));
    page++;
    final failOrNot = await ds.getMyStores(
      Query(
        offset: page,
        limit: limit,
        keyword: event.search,
        orderDirection: 'asc',
        orderBy: 'id',
      ),
    );
    return failOrNot.fold((l) => GetMyStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores.addAll(r);
      return GetMyStoresSuccess(stores);
    });
  }
}
