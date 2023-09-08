import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_app_state.dart';

class MainAppCubit extends Cubit<MainAppState> {
  MainAppCubit() : super(MainAppState());

  int selectedIndex = 0;

  changePage(int index) {
    emit(GetMainAppInit());
    selectedIndex = index;
    emit(GeteMainAppSuccess());
  }
}
