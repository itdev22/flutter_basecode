import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/api_return/api_return.dart';
import '../../model/home/home_dropdown/home_model.dart';
import '../../services/home_service.dart';
import '../../services/suggestion_service.dart';
import '../../utils/app_constant.dart';
import 'suggestion_state.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  SuggestionCubit() : super(SuggestionState());

  final HomeService _homeService = HomeService();
  final SuggestionService _suggestionService = SuggestionService();

  //Model Home
  HomeModel? homeData;
  //

  // List item dropdown
  List<DropdownMenuItem<String>> itemsKota = [];
  //

  // Dropdown value
  String? valueKota;
  //

  getTradeDropdownData() async {
    emit(GetSuggestionInit());
    ApiReturn<HomeModel> result = await _homeService.getDropdown();
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      homeData = result.data;
      int kotaLength = homeData?.kota?.length ?? 0;
      itemsKota.clear();
      for (var i = 0; i < kotaLength; i++) {
        itemsKota.add(DropdownMenuItem(
            value: homeData?.kota?[i].id.toString(),
            child: Text(homeData?.kota?[i].nama ?? "")));
      }

      valueKota = homeData?.kota?[0].id.toString();

      emit(GetSuggestionSuccess());
    } else {
      emit(GetSuggestionFailure(message: result.message));
    }
  }

  sendSuggestion(
      {required String kritik,
      required String nama,
      required String saran}) async {
    emit(GetSuggestionInit());
    ApiReturn result = await _suggestionService.sendSuggestion(
        kotaId: valueKota ?? "0", kritik: kritik, nama: nama, saran: saran);
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      emit(GetSuggestionSuccess());
    } else {
      emit(GetSuggestionFailure(message: result.message));
    }
  }
}
