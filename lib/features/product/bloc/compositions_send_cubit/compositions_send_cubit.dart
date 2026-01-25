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

    final List<Map<String, dynamic>> compositionsPayload = [];

    for (int i = 0; i < compositions.length; i++) {
      compositionsPayload.add({
        "is_main": i == 0, // or your own logic
        "is_active": true,
        "quantity": counts[i],
        "product_id": productId,
        "attribute_ids": compositions[i].map((e) => e.id).toList(),
      });
    }

    final failOrNot = await ds.sendComposition({"compositions": compositionsPayload});
    failOrNot.fold(
      (l) => emit.call(CompositionsSendFailed(l)),
      (r) => emit.call(CompositionsSendSuccess()),
    );
  }
}
