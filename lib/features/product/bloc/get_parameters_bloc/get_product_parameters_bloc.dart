import 'package:bloc/bloc.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/product/models/product_parameters.dart';
import 'package:meta/meta.dart';

import '../../../reels/model/query.dart';

part 'get_product_parameters_event.dart';
part 'get_product_parameters_state.dart';

class GetProductParametersBloc extends Bloc<GetProductParametersEvent, GetProductParametersState> {
  final ProductRemoteDataSource ds;
  List<ProductParameter> productParameters = [];

  int page = 1;
  int limit = 15;
  bool canPag = false;

  GetProductParametersBloc(this.ds) : super(GetProductParameterInitial()) {
    on<GetProductParametersEvent>((event, emit) async {
      if (event is GetProductParameter) {
        if (event.query == null && productParameters.isNotEmpty) {
          emit.call(GetProductParameterSuccess(productParameters, true));
          return;
        }
        canPag = false;

        emit.call(GetProductParameterLoading());
        emit.call(await _getProductParameters(event));
      }

      if (event is ProductParameterPag) {
        if (!canPag) return;

        canPag = false;
        emit.call(ProductParameterPagLoading(productParameters));
        emit.call(await _paginate(event));
      }
    });
  }

  Future<GetProductParametersState> _paginate(ProductParameterPag event) async {
    page += 1;

    final failOrNot = await ds.getParameters(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold(
      (l) => GetProductParameterFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        productParameters.addAll(r);
        if (r.length == limit) canPag = true;
        return GetProductParameterSuccess(productParameters, r.length == limit);
      },
    );
  }

  Future<GetProductParametersState> _getProductParameters(GetProductParameter event) async {
    page = 1;

    final failOrNot = await ds.getParameters(
      (event.query ?? Query()).copyWith(
        offset: page,
        limit: limit,
        orderDirection: event.query?.orderDirection ?? 'asc',
        orderBy: event.query?.orderBy ?? 'id',
      ),
    );

    return failOrNot.fold(
      (l) => GetProductParameterFailed(message: l.message, statusCode: l.statusCode),
      (r) {
        if (r.length == limit) canPag = true;
        productParameters = r;
        return GetProductParameterSuccess(r, r.length == limit);
      },
    );
  }
}
