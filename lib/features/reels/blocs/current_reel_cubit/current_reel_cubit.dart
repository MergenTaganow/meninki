import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

part 'current_reel_state.dart';

class CurrentReelCubit extends Cubit<CurrentReelState> {
  CurrentReelCubit() : super(CurrentReelSuccess(null));

  Reel? currentReel;

  set(Reel reel) {
    currentReel = reel;
    emit.call(CurrentReelSuccess(currentReel));
  }
}
