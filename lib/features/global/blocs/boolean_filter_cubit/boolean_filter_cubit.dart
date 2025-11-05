import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'boolean_filter_state.dart';

class BooleanFilterCubit extends Cubit<BooleanFilterState> {
  BooleanFilterCubit() : super(BooleanFilterSuccess(const {}));
  Map<String, bool?> savedMap = {};

  select(String key, bool? value) {
    savedMap[key] = value;
    emit.call(BooleanFilterSuccess(savedMap));
  }

  static String dashboard_overDue = 'dashboard_overDue';
  static String delivered_orders = 'delivered_orders';
  static String reworked_orders = 'reworked_orders';
}
