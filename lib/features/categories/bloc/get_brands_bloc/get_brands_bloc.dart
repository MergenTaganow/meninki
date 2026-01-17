import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/data/reels_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';
import '../../models/brand.dart';

part 'get_brands_event.dart';
part 'get_brands_state.dart';

class GetBrandsBloc extends Bloc<GetBrandsEvent, GetBrandsState> {
  final ReelsRemoteDataSource ds; // <-- Change to your DS class
  List<Brand> brands = [];

  int page = 1;
  int limit = 15;
  bool canPag = false;

  GetBrandsBloc(this.ds) : super(GetBrandInitial()) {
    on<GetBrandsEvent>((event, emit) async {
      if (event is GetBrand) {
        canPag = false;

        emit(GetBrandLoading());
        emit(await _getBrands(event));
      }

      if (event is BrandPag) {
        if (!canPag) return;

        canPag = false;
        emit(BrandPagLoading(brands));
        emit(await _paginate(event));
      }
    });
  }

  Future<GetBrandsState> _paginate(BrandPag event) async {
    page += 1;

    final failOrNot = await ds.getBrands(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold((l) => GetBrandFailed(message: l.message, statusCode: l.statusCode), (r) {
      brands.addAll(r);
      if (r.length == limit) canPag = true;
      return GetBrandSuccess(brands, r.length == limit);
    });
  }

  Future<GetBrandsState> _getBrands(GetBrand event) async {
    page = 1;

    final failOrNot = await ds.getBrands(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold((l) => GetBrandFailed(message: l.message, statusCode: l.statusCode), (r) {
      if (r.length == limit) canPag = true;
      brands = r;
      return GetBrandSuccess(r, r.length == limit);
    });
  }
}
