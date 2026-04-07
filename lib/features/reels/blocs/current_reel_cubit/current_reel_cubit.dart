import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

part 'current_reel_state.dart';

class CurrentReelCubit extends Cubit<CurrentReelState> {
  CurrentReelCubit() : super(CurrentReelSuccess(null, null));
  String? currentReelType;

  void setCurrentReel({required String type, required List<Reel> reels}) {
    currentReelType = type;
    emit(CurrentReelSuccess(currentReelType, reels));
  }

  needPagination(String type) {
    print("pagination came");
    if (type != currentReelType) return;
    emit(PaginateReels(currentReelType));
  }

  paginationCame({required String type, required List<Reel> reels}) {
    if (type != currentReelType) return;
    emit(CurrentReelSuccess(currentReelType, reels));
  }

  clear(String type) {
    if (type != currentReelType) return;
    currentReelType = null;
    emit(CurrentReelSuccess(null, null));
  }
}

class ReelTypes {
  static const String homeLenta = "home_lenta";
  static const String myReels = "my_reels";
  static const String productReels = "product_reels";
  static const String userReels = "user_reels";
  static const String searchedReels = "searched_reels";
  static const String storeReels = "store_reels";
}
