import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meninki/features/product/models/product.dart';
import 'package:meta/meta.dart';

part 'get_product_by_id_state.dart';

class GetProductByIdCubit extends Cubit<GetProductByIdState> {
  final ProductRemoteDataSource ds;
  GetProductByIdCubit(this.ds) : super(GetProductByIdInitial());

  getProduct(int id) async {
    emit.call(GetProductByIdLoading());
    var failOrNot = await ds.getProductById(id);
    failOrNot.fold(
      (l) => emit.call(GetProductByIdFailed(l)),
      (r) => emit.call(GetProductByIdSuccess(r)),
    );
  }

  clear() {
    emit.call(GetProductByIdInitial());
  }
}
