part of 'get_adds_bloc.dart';

@immutable
sealed class GetAddsState {}

class GetAddInitial extends GetAddsState {}

class GetAddLoading extends GetAddsState {}

class AddPagLoading extends GetAddsState {
  final List<Add> adds;
  AddPagLoading(this.adds);
}

class GetAddSuccess extends GetAddsState {
  final List<Add> adds;
  final bool canPag;
  GetAddSuccess(this.adds, this.canPag);
}

class GetAddFailed extends GetAddsState {
  final String? message;
  final int? statusCode;
  GetAddFailed({this.message, this.statusCode});
}
