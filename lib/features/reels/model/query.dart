// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Query {
  String? keyword;
  bool? isActive;
  bool? isBlocked;
  int? limit;
  int? offset;
  List<int?>? market_ids;
  List<int?>? product_ids;
  List<int?>? category_ids;
  String? date;
  String? status;
  List? statuses;
  String? sortBy;
  String? sortAs;
  String? dateFrom;
  String? dateTo;
  String? orderBy;
  bool? ignoreEmpty;
  int? parameter_id;
  int? user_id;
  Query({
    this.keyword,
    this.isActive,
    this.isBlocked,
    this.limit,
    this.offset,
    this.date,
    this.status,
    this.statuses,
    this.sortBy,
    this.sortAs,
    this.dateFrom,
    this.dateTo,
    this.orderBy,
    this.ignoreEmpty,
    this.parameter_id,
    this.user_id,
    this.market_ids,
    this.product_ids,
    this.category_ids,
  });

  Query copyWith({
    String? keyword,
    bool? isActive,
    bool? isBlocked,
    bool? history,
    int? limit,
    int? offset,
    int? yearIn,
    int? yearOut,
    int? parameter_id,
    int? user_id,
    String? companyUuids,
    List<String?>? companyUuids2,
    List<int?>? market_ids,
    List<int?>? product_ids,
    List<int?>? category_ids,
    List<String?>? departmentUuids,
    List<String?>? testUuids,
    List<String?>? vacancyUuids,
    List<String?>? skillUuid,
    String? divisionUuids,
    String? jobUuids,
    List<String?>? groupUuids,
    List<String?>? topicUuids,
    List<String?>? employeeUuids,
    List<String?>? executorUuids,
    List<String?>? treeUuids,
    List<String?>? educationLevelUuids,
    String? modelUuid,
    String? modelName,
    String? date,
    bool? lastWeek,
    bool? lastMonth,
    bool? skipMinus,
    int? scoreFrom,
    int? scoreTo,
    String? status,
    List? statuses,
    String? sortBy,
    String? sortAs,
    String? dateFrom,
    String? dateTo,
    String? orderBy,
    String? approachType,
    String? type,
    bool? ignoreEmpty,
    bool? hasApplied,
    bool? hasEffect,
  }) {
    return Query(
      keyword: keyword ?? this.keyword,
      isActive: isActive ?? this.isActive,
      isBlocked: isBlocked ?? this.isBlocked,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      date: date ?? this.date,
      status: status ?? this.status,
      statuses: statuses ?? this.statuses,
      sortBy: sortBy ?? this.sortBy,
      sortAs: sortAs ?? this.sortAs,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      orderBy: orderBy ?? this.orderBy,
      ignoreEmpty: ignoreEmpty ?? this.ignoreEmpty,
      parameter_id: parameter_id ?? this.parameter_id,
      market_ids: market_ids ?? this.market_ids,
      product_ids: product_ids ?? this.product_ids,
      user_id: user_id ?? this.user_id,
      category_ids: category_ids ?? this.category_ids,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (keyword?.isNotEmpty ?? false) 'search': keyword,
      if (isActive != null) 'isActive': isActive,
      if (isBlocked != null) 'isBlocked': isBlocked,
      if (limit != null) 'limit': limit,
      if (offset != null) 'page': offset,
      if (market_ids != null) 'market_ids': market_ids,
      if (product_ids != null) 'product_ids': product_ids,
      if (category_ids != null) 'category_ids': category_ids,
      if (date != null) 'date': date,
      if (status != null) 'status': status,
      if (statuses != null) 'statuses[]': statuses,
      if (sortBy != null) 'order_by': sortBy,
      if (sortAs != null) 'order_direction': sortAs,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (orderBy != null) 'orderBy': orderBy,
      if (ignoreEmpty != null) 'ignoreEmpty': ignoreEmpty,
      if (parameter_id != null) 'parameter_id': parameter_id,
      if (user_id != null) 'user_id': user_id,
    };
  }

  // factory Query.fromMap(Map<String, dynamic> map) {
  //   return Query(
  //     keyword: map['search'] != null ? map['search'] as String : null,
  //     isActive: map['isActive'] != null ? map['isActive'] as bool : null,
  //     isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null,
  //     limit: map['limit'] != null ? map['limit'] as int : null,
  //     offset: map['offset'] != null ? map['offset'] as int : null,
  //     date: map['date'] != null ? map['date'] as String : null,
  //     scoreTo: map['scoreTo'] != null ? map['scoreTo'] as int : null,
  //     status: map['status'] != null ? map['status'] as String : null,
  //     statuses: map['statuses'],
  //     sortBy: map['sortBy'] != null ? map['sortBy'] as String : null,
  //     sortAs: map['sortAs'] != null ? map['sortAs'] as String : null,
  //     dateFrom: map['dateFrom'] != null ? map['dateFrom'] as String : null,
  //     dateTo: map['dateTo'] != null ? map['dateTo'] as String : null,
  //     orderBy: map['orderBy'] != null ? map['orderBy'] as String : null,
  //     approachType: map['approachType'] != null ? map['approachType'] as String : null,
  //     skipMinus: map['skipMinus'],
  //     ignoreEmpty: map['ignoreEmpty'] != null ? map['ignoreEmpty'] as bool : null,
  //     type: map['type'],
  //     parameter_id: map['parameter_id'],
  //   );
  // }

  String toJson() => json.encode(toMap());

  // factory Query.fromJson(String source) =>
  //     Query.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'Query(search: $keyword, isActive: $isActive, isBlocked: $isBlocked, history: $history, limit: $limit, offset: $offset, companyUuids: $companyUuids, departmentUuids: $departmentUuids, divisionUuids: $divisionUuids, jobUuids: $jobUuids, groupUuids: $groupUuids, topicUuids : $topicUuids, modelUuid: $modelUuid, modelName: $modelName, date: $date, lastWeek: $lastWeek, lasMonth: $lastMonth, skipMinus: $skipMinus, scoreFrom: $scoreFrom, scoreTo: $scoreTo, status: $status, statuses: $statuses, sortBy: $sortBy, sortAs: $sortAs, dateFrom: $dateFrom, dateTo: $dateTo, orderBy: $orderBy, approachType: $approachType)';
  // }

  @override
  bool operator ==(covariant Query other) {
    if (identical(this, other)) return true;

    return other.keyword == keyword &&
        other.isActive == isActive &&
        other.isBlocked == isBlocked &&
        other.limit == limit &&
        other.offset == offset &&
        listEquals(other.market_ids, market_ids) &&
        other.date == date &&
        other.status == status &&
        other.statuses == statuses &&
        other.sortBy == sortBy &&
        other.sortAs == sortAs &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.user_id == user_id &&
        other.product_ids == product_ids &&
        other.category_ids == category_ids &&
        other.orderBy == orderBy;
  }

  @override
  int get hashCode {
    return keyword.hashCode ^
        isActive.hashCode ^
        isBlocked.hashCode ^
        limit.hashCode ^
        offset.hashCode ^
        market_ids.hashCode ^
        date.hashCode ^
        status.hashCode ^
        statuses.hashCode ^
        sortBy.hashCode ^
        sortAs.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode ^
        user_id.hashCode ^
        category_ids.hashCode ^
        product_ids.hashCode ^
        orderBy.hashCode;
  }
}
