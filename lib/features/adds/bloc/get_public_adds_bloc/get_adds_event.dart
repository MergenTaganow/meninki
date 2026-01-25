part of 'get_adds_bloc.dart';

@immutable
sealed class GetAddsEvent {}

class GetAdd extends GetAddsEvent {
  final Query? query;
  GetAdd([this.query]);
}

class AddPag extends GetAddsEvent {
  final Query? query;
  AddPag({this.query});
}

class ClearAdds extends GetAddsEvent {}
