import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/product/data/product_remote_data_source.dart';
import 'package:meta/meta.dart';

import '../../models/product.dart';
import '../../models/product_atribute.dart';
import '../../widgets/composition.dart';

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

  edit({
    required Product product,
    required List<List<ProductAttribute>> compositions,
    required List<num> counts,
  }) async {
    emit(CompositionsSendLoading());

    // 1️⃣ Index old compositions
    final Map<String, Composition> oldMap = {
      for (final c in product.compositions ?? []) compositionKey(c.attributes ?? []): c,
    };

    final List<Map<String, dynamic>> payload = [];

    // 2️⃣ Build payload
    for (int i = 0; i < compositions.length; i++) {
      final attrs = compositions[i];
      final key = compositionKey(attrs);
      final old = oldMap[key];

      payload.add({
        if (old?.id != null) "id": old!.id,
        // "is_main": i == 0,
        // "is_active": true,
        "quantity": counts[i],
        "product_id": product.id,
        "attribute_ids": attrs.map((e) => e.id).toList(),
      });
    }


    await ds.editComposition({"compositions": payload});
  }

  String compositionKey(List<ProductAttribute> attrs) {
    final ids = attrs.map((e) => e.id).toList()..sort();
    return ids.join('_');
  }
}
