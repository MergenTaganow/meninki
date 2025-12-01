import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../models/product_atribute.dart';

part 'compositions_send_state.dart';

class CompositionsSendCubit extends Cubit<CompositionsSendState> {
  ProductRemoteDataSource ds;
  CompositionsSendCubit(this.ds) : super(CompositionsSendInitial());

  send({
    required int productId,
    required List<List<ProductAttribute>> compositions,
    required List<num> counts,
  }) async {
    emit.call(CompositionsSendLoading());

    for (int i = 0; i < compositions.length; i++) {
      var failOrNot = await ds.sendComposition({
        "is_main": false,
        "is_active": false,
        "quantity": counts[i],
        "product_id": productId,
        "attribute_ids": compositions[i].map((e) => e.id).toList(),
      });
      failOrNot.fold((l) => print("$i was error: ${l.message}"), (r) => print("$i was success"));
    }
    emit.call(CompositionsSendSuccess());
  }
}
