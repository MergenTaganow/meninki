import 'package:bloc/bloc.dart';
import 'package:meninki/features/store/models/market.dart';
import 'package:meta/meta.dart';

import '../../../../core/failure.dart';
import '../../../reels/model/query.dart';
import '../../data/store_remote_data_source.dart';

part 'get_stores_event.dart';
part 'get_stores_state.dart';

class GetStoresBloc extends Bloc<GetStoresEvent, GetStoresState> {
  final StoreRemoteDataSource ds;
  List<Market> stores = [];
  int page = 1;
  int limit = 10;
  bool canPag = false;

  GetStoresBloc(this.ds) : super(GetStoresInitial()) {
    on<GetStoresEvent>((event, emit) async {
      if (event is GetStores) {
        emit(GetStoresLoading());

        canPag = false;
        emit(await _getStores(event));
      }

      if (event is PaginateStores) {
        if (!canPag) return;

        emit(GetStoresPaginating());
        canPag = false;
        emit(await _paginate(event));
      }
    });
  }

  Future<GetStoresState> _getStores(GetStores event) async {
    page = 1;
    final failOrNot = await ds.getStores(
      Query(
        limit: limit,
        offset: page,
        keyword: event.search ?? '',
        sortAs: 'asc',
        sortBy: 'created_at',
      ),
    );
    return failOrNot.fold((l) => GetStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores = r;
      return GetStoresSuccess(stores);
    });
  }

  Future<GetStoresState> _paginate(PaginateStores event) async {
    await Future.delayed(const Duration(milliseconds: 400));
    page++;
    final failOrNot = await ds.getStores(
      Query(offset: page, limit: limit, keyword: event.search, sortAs: 'asc', sortBy: 'created_at'),
    );
    return failOrNot.fold((l) => GetStoresFailed(l), (r) {
      if (r.length == limit) canPag = true;
      stores.addAll(r);
      return GetStoresSuccess(stores);
    });
  }
}
