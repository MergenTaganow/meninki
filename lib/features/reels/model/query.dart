// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class Query {
  String? keyword;
  bool? isActive;
  bool? isBlocked;
  bool? history;
  bool? hasApplied;
  bool? hasEffect;
  int? limit;
  int? yearIn;
  int? yearOut;
  int? offset;
  String? companyUuids;
  List<String?>? companyUuids2;
  List<String?>? departmentUuids;
  String? divisionUuids;
  String? jobUuids;
  List<String?>? groupUuids;
  List<String?>? topicUuids;
  List<String?>? employeeUuids;
  List<String?>? executorUuids;
  List<String?>? treeUuids;
  List<String?>? testUuids;
  List<String?>? skillUuid;
  List<String?>? vacancyUuids;
  List<String?>? educationLevelUuids;
  String? modelUuid;
  String? modelName;
  String? date;
  bool? lastWeek;
  bool? lastMonth;
  bool? skipMinus;
  int? scoreFrom;
  int? scoreTo;
  String? status;
  List? statuses;
  String? sortBy;
  String? sortAs;
  String? dateFrom;
  String? dateTo;
  String? orderBy;
  String? approachType;
  String? type;
  bool? ignoreEmpty;
  int? parameter_id;
  Query({
    this.keyword,
    this.isActive,
    this.isBlocked,
    this.yearIn,
    this.yearOut,
    this.history,
    this.limit,
    this.offset,
    this.companyUuids,
    this.companyUuids2,
    this.departmentUuids,
    this.divisionUuids,
    this.vacancyUuids,
    this.jobUuids,
    this.skillUuid,
    this.testUuids,
    this.groupUuids,
    this.topicUuids,
    this.modelUuid,
    this.treeUuids,
    this.modelName,
    this.date,
    this.lastWeek,
    this.lastMonth,
    this.skipMinus,
    this.scoreFrom,
    this.scoreTo,
    this.status,
    this.statuses,
    this.sortBy,
    this.sortAs,
    this.dateFrom,
    this.dateTo,
    this.orderBy,
    this.approachType,
    this.employeeUuids,
    this.type,
    this.hasApplied,
    this.hasEffect,
    this.ignoreEmpty,
    this.educationLevelUuids,
    this.executorUuids,
    this.parameter_id,
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
    String? companyUuids,
    List<String?>? companyUuids2,
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
      history: history ?? this.history,
      limit: limit ?? this.limit,
      yearIn: yearIn ?? this.yearIn,
      yearOut: yearOut ?? this.yearOut,
      offset: offset ?? this.offset,
      skillUuid: skillUuid ?? this.skillUuid,
      companyUuids: companyUuids ?? this.companyUuids,
      companyUuids2: companyUuids2 ?? this.companyUuids2,
      departmentUuids: departmentUuids ?? this.departmentUuids,
      divisionUuids: divisionUuids ?? this.divisionUuids,
      testUuids: testUuids ?? this.testUuids,
      vacancyUuids: vacancyUuids ?? this.vacancyUuids,
      treeUuids: treeUuids ?? this.treeUuids,
      jobUuids: jobUuids ?? this.jobUuids,
      groupUuids: groupUuids ?? this.groupUuids,
      topicUuids: topicUuids ?? this.topicUuids,
      employeeUuids: employeeUuids ?? this.employeeUuids,
      modelUuid: modelUuid ?? this.modelUuid,
      modelName: modelName ?? this.modelName,
      date: date ?? this.date,
      lastWeek: lastWeek ?? this.lastWeek,
      lastMonth: lastMonth ?? this.lastMonth,
      skipMinus: skipMinus ?? this.skipMinus,
      scoreFrom: scoreFrom ?? this.scoreFrom,
      scoreTo: scoreTo ?? this.scoreTo,
      status: status ?? this.status,
      statuses: statuses ?? this.statuses,
      sortBy: sortBy ?? this.sortBy,
      sortAs: sortAs ?? this.sortAs,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      orderBy: orderBy ?? this.orderBy,
      approachType: approachType ?? this.approachType,
      type: type ?? this.type,
      ignoreEmpty: ignoreEmpty ?? this.ignoreEmpty,
      educationLevelUuids: educationLevelUuids ?? this.educationLevelUuids,
      hasApplied: hasApplied ?? this.hasApplied,
      hasEffect: hasEffect ?? this.hasEffect,
      executorUuids: executorUuids ?? this.executorUuids,
      parameter_id: parameter_id ?? this.parameter_id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (keyword != null) 'search': keyword,
      if (isActive != null) 'isActive': isActive,
      if (isBlocked != null) 'isBlocked': isBlocked,
      if (history != null) 'history': history,
      if (limit != null) 'limit': limit,
      if (yearIn != null) 'yearIn': yearIn,
      if (yearOut != null) 'yearOut': yearOut,
      if (offset != null) 'page': offset,
      if (companyUuids != null || companyUuids2 != null)
        'companyUuids[]': [if (companyUuids != null) companyUuids, ...?companyUuids2],
      if (departmentUuids != null) 'departmentUuids[]': departmentUuids,
      if (divisionUuids != null) 'divisionUuids[]': divisionUuids,
      if (treeUuids != null) 'treeUuids[]': treeUuids,
      if (jobUuids != null) 'jobUuids[]': jobUuids,
      if (groupUuids != null) 'groupUuids[]': groupUuids,
      if (topicUuids != null) 'topicUuids[]': topicUuids,
      if (employeeUuids != null) 'employeeUuids[]': employeeUuids,
      if (executorUuids != null) 'executorUuids[]': executorUuids,
      if (testUuids != null) 'testUuids[]': testUuids,
      if (vacancyUuids != null) 'vacancyUuids[]': vacancyUuids,
      if (modelUuid != null) 'modelUuid': modelUuid,
      if (modelName != null) 'modelName': modelName,
      if (date != null) 'date': date,
      if (lastWeek != null) 'lastWeek': lastWeek,
      if (lastMonth != null) 'lastMonth': lastMonth,
      if (scoreFrom != null) 'scoreFrom': scoreFrom,
      if (scoreTo != null) 'scoreTo': scoreTo,
      if (status != null) 'status': status,
      if (statuses != null) 'statuses[]': statuses,
      if (sortBy != null) 'order_by': sortBy,
      if (sortAs != null) 'order_direction': sortAs,
      if (dateFrom != null) 'dateFrom': dateFrom,
      if (dateTo != null) 'dateTo': dateTo,
      if (orderBy != null) 'orderBy': orderBy,
      if (skipMinus != null) 'skipMinus': skipMinus,
      if (approachType != null) 'approachType': approachType,
      if (type != null) 'type': type,
      if (skillUuid != null) 'skillUuids[]': skillUuid,
      if (ignoreEmpty != null) 'ignoreEmpty': ignoreEmpty,
      if (hasApplied != null) 'hasApplied': hasApplied,
      if (hasEffect != null) 'hasEffect': hasEffect,
      if (parameter_id != null) 'parameter_id': parameter_id,
      if (educationLevelUuids?.isNotEmpty ?? false) 'levelUuids': educationLevelUuids,
    };
  }

  factory Query.fromMap(Map<String, dynamic> map) {
    return Query(
      keyword: map['search'] != null ? map['search'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      isBlocked: map['isBlocked'] != null ? map['isBlocked'] as bool : null,
      history: map['history'] != null ? map['history'] as bool : null,
      limit: map['limit'] != null ? map['limit'] as int : null,
      yearIn: map['yearIn'] != null ? map['yearIn'] as int : null,
      yearOut: map['yearOut'] != null ? map['yearOut'] as int : null,
      offset: map['offset'] != null ? map['offset'] as int : null,
      companyUuids: map['companyUuids'] != null ? map['companyUuids'] as String : null,
      departmentUuids: map['departmentUuids'],
      divisionUuids: map['divisionUuids'] != null ? map['divisionUuids'] as String : null,
      skillUuid: map['skillUuids'] != null ? map['skillUuids'] as List<String> : null,
      treeUuids: map['treeUuids'] != null ? map['treeUuids'] as List<String> : null,
      jobUuids: map['jobUuids'] != null ? map['jobUuids'] as String : null,
      employeeUuids: map['employeeUuids'],
      executorUuids: map['executorUuids'],
      groupUuids: map['groupUuids'],
      topicUuids: map['topicUuids'],
      modelUuid: map['modelUuid'] != null ? map['modelUuid'] as String : null,
      modelName: map['modelName'] != null ? map['modelName'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      lastWeek: map['lastWeek'] != null ? map['lastWeek'] as bool : null,
      lastMonth: map['lasMonth'] != null ? map['lasMonth'] as bool : null,
      scoreFrom: map['scoreFrom'] != null ? map['scoreFrom'] as int : null,
      scoreTo: map['scoreTo'] != null ? map['scoreTo'] as int : null,
      status: map['status'] != null ? map['status'] as String : null,
      statuses: map['statuses'],
      sortBy: map['sortBy'] != null ? map['sortBy'] as String : null,
      sortAs: map['sortAs'] != null ? map['sortAs'] as String : null,
      dateFrom: map['dateFrom'] != null ? map['dateFrom'] as String : null,
      dateTo: map['dateTo'] != null ? map['dateTo'] as String : null,
      orderBy: map['orderBy'] != null ? map['orderBy'] as String : null,
      approachType: map['approachType'] != null ? map['approachType'] as String : null,
      skipMinus: map['skipMinus'],
      ignoreEmpty: map['ignoreEmpty'] != null ? map['ignoreEmpty'] as bool : null,
      type: map['type'],
      parameter_id: map['parameter_id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Query.fromJson(String source) =>
      Query.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Query(search: $keyword, isActive: $isActive, isBlocked: $isBlocked, history: $history, limit: $limit, offset: $offset, companyUuids: $companyUuids, departmentUuids: $departmentUuids, divisionUuids: $divisionUuids, jobUuids: $jobUuids, groupUuids: $groupUuids, topicUuids : $topicUuids, modelUuid: $modelUuid, modelName: $modelName, date: $date, lastWeek: $lastWeek, lasMonth: $lastMonth, skipMinus: $skipMinus, scoreFrom: $scoreFrom, scoreTo: $scoreTo, status: $status, statuses: $statuses, sortBy: $sortBy, sortAs: $sortAs, dateFrom: $dateFrom, dateTo: $dateTo, orderBy: $orderBy, approachType: $approachType)';
  }

  @override
  bool operator ==(covariant Query other) {
    if (identical(this, other)) return true;

    return other.keyword == keyword &&
        other.isActive == isActive &&
        other.isBlocked == isBlocked &&
        other.history == history &&
        other.limit == limit &&
        other.offset == offset &&
        other.companyUuids == companyUuids &&
        listEquals(other.departmentUuids, departmentUuids) &&
        other.divisionUuids == divisionUuids &&
        other.jobUuids == jobUuids &&
        listEquals(other.groupUuids, groupUuids) &&
        listEquals(other.skillUuid, skillUuid) &&
        listEquals(other.topicUuids, topicUuids) &&
        listEquals(other.employeeUuids, employeeUuids) &&
        listEquals(other.vacancyUuids, vacancyUuids) &&
        other.modelUuid == modelUuid &&
        other.modelName == modelName &&
        other.date == date &&
        other.lastWeek == lastWeek &&
        other.lastMonth == lastMonth &&
        other.skipMinus == skipMinus &&
        other.scoreFrom == scoreFrom &&
        other.scoreTo == scoreTo &&
        other.status == status &&
        other.statuses == statuses &&
        other.sortBy == sortBy &&
        other.sortAs == sortAs &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.type == type &&
        other.approachType == approachType &&
        other.orderBy == orderBy;
  }

  @override
  int get hashCode {
    return keyword.hashCode ^
        isActive.hashCode ^
        isBlocked.hashCode ^
        history.hashCode ^
        limit.hashCode ^
        offset.hashCode ^
        companyUuids.hashCode ^
        departmentUuids.hashCode ^
        divisionUuids.hashCode ^
        jobUuids.hashCode ^
        groupUuids.hashCode ^
        skillUuid.hashCode ^
        vacancyUuids.hashCode ^
        topicUuids.hashCode ^
        employeeUuids.hashCode ^
        modelUuid.hashCode ^
        modelName.hashCode ^
        date.hashCode ^
        lastWeek.hashCode ^
        lastMonth.hashCode ^
        skipMinus.hashCode ^
        scoreFrom.hashCode ^
        scoreTo.hashCode ^
        status.hashCode ^
        statuses.hashCode ^
        sortBy.hashCode ^
        sortAs.hashCode ^
        dateFrom.hashCode ^
        dateTo.hashCode ^
        type.hashCode ^
        orderBy.hashCode;
  }
}
