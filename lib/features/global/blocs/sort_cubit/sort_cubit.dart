import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'sort_state.dart';

class SortCubit extends Cubit<SortState> {
  SortCubit() : super(SortSuccess(null));
  Map<String, Sort?> sortMap = {};

  selectSort({required String key, Sort? newSort}) {
    sortMap[key] = newSort;
    emit.call(SortSuccess(sortMap));
  }

  static String productSearchSort = 'productSearchSort';
}

class Sort {
  String? orderBy;
  String? orderDirection;
  String? text;

  Sort({this.text, this.orderBy, this.orderDirection});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (orderBy != null) 'order_by': orderBy,
      if (orderDirection != null) 'order_direction': orderDirection,
    };
  }

  @override
  bool operator ==(covariant Sort other) {
    if (identical(this, other)) return true;

    return other.orderDirection == orderDirection && other.orderBy == orderBy && other.text == text;
  }

  @override
  int get hashCode {
    return orderDirection.hashCode ^ orderBy.hashCode ^ text.hashCode;
  }
}
