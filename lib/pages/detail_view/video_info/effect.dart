import 'package:fish_redux/fish_redux.dart';
import 'action.dart';
import 'state.dart';

Effect<VideoInfoState> buildEffect() {
  return combineEffects(<Object, Effect<VideoInfoState>>{
    VideoInfoAction.action: _onAction,
  });
}

void _onAction(Action action, Context<VideoInfoState> ctx) {
}
