part of 'compositions_send_cubit.dart';

@immutable
sealed class CompositionsSendState {}

final class CompositionsSendInitial extends CompositionsSendState {}

final class CompositionsSendLoading extends CompositionsSendState {}

final class CompositionsSendFailed extends CompositionsSendState {
  final Failure failure;
  CompositionsSendFailed(this.failure);
}

final class CompositionsSendSuccess extends CompositionsSendState {}
