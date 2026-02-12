import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'tab_navigation_state.dart';

enum TabPages { main, home, search }

class TabNavigationCubit extends Cubit<TabNavigationState> {
  TabNavigationCubit() : super(TabNavigationInitial());

  homeToSearchProduct() async {
    emit(NavigateTab(page: TabPages.main, index: 1));
    await Future.delayed(Duration(milliseconds: 400));
    emit(NavigateTab(page: TabPages.search, index: 1));
    emit(TabNavigationInitial());
  }
}
