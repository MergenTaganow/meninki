import 'package:bloc/bloc.dart';
import 'package:meninki/core/failure.dart';
import 'package:meninki/features/auth/data/auth_remote_data_source.dart';
import 'package:meta/meta.dart';

part 'appeal_state.dart';

class AppealCubit extends Cubit<AppealState> {
  final AuthRemoteDataSource dataSource;
  AppealCubit(this.dataSource) : super(AppealInitial());

  doAppeal({
    required String id,
    required String topic,
    required String type,
    required String body,
  }) async {
    emit(AppealLoading());
    var res = await dataSource.doAppeal({
      "type_id": id,
      "topic": topic,
      "type": type,
      "body": body,
    });
    res.fold((l) => emit(AppealFailed(l)), (r) => emit(AppealSuccess()));
  }
}

class Appeal {
  static const String reel = "reel";
  static const String product = "product";
  static const String profile = "profile";
  static const String market = "market";
  static const String adds = "adds";

  static List<String> topics = ["insufficient_content", "same_product", "additional_request"];
}
