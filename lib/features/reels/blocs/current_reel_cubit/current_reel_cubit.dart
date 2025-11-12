import 'package:bloc/bloc.dart';
import 'package:meninki/features/reels/model/reels.dart';
import 'package:meta/meta.dart';

part 'current_reel_state.dart';

class CurrentReelCubit extends Cubit<CurrentReelState> {
  CurrentReelCubit() : super(CurrentReelSuccess(null));

  Reel? currentReel;

  set(Reel reel) {
    currentReel = reel;
    print("current Reels Id----${reel.id}");
    print("current Reels Id----${reel.id}");
    print("current Reels Id----${reel.id}");
    print("current Reels Id----${reel.id}");
    emit.call(CurrentReelSuccess(currentReel));
  }
}
