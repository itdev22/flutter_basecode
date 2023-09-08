import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/api_return/api_return.dart';
import '../../model/home/home_dropdown/home_model.dart';
import '../../model/home/home_filtered/histogram_model.dart';
import '../../model/home/home_filtered/home_filtered_model.dart';
import '../../model/home/inflasi_pertumbuhan_model.dart';
import '../../model/home/sub_komoditas_model.dart';
import '../../services/home_service.dart';
import '../../utils/app_constant.dart';
import '../../utils/core/global_method_helper.dart';
import '../../widget/histogram.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());

  final HomeService _homeService = HomeService();
  List<SubKomoditasModel> _listSubKomoditas = [];

  //Model Home
  HomeModel? homeData;
  InflasiPertumbuhanModel? inflasiPertumbuhanData;
  List<HomeFilteredModel> listDataHome = [];
  List<HistogramModel> listDataHistogram = [];

  // List item dropdown
  List<DropdownMenuItem<String>> itemsKomoditas = [];
  List<DropdownMenuItem<String>> itemsInformasiHarga = const [
    DropdownMenuItem(
        value: "1",
        child: Text(
          "Perbandingan Harga",
          maxLines: 3,
          style: TextStyle(fontFamily: "Poppins"),
        )),
    DropdownMenuItem(
        value: "2",
        child: Text(
          "Perubahan Harga",
          maxLines: 3,
          style: TextStyle(fontFamily: "Poppins"),
        ))
  ];
  List<DropdownMenuItem<String>> itemsSubKomoditas = [];
  List<DropdownMenuItem<String>> itemsKota = [
    const DropdownMenuItem(
        value: "0",
        child: Text("Semua Kota",
            maxLines: 3, style: TextStyle(fontFamily: "Poppins")))
  ];
  List<DropdownMenuItem<String>> itemsJenisPasar = [];

  // List data histogram
  List<HistogramData> dataKebutuhan = [];
  List<HistogramData> dataHarga = [];
  List<HistogramData> dataKetersediaan = [];

  // Dropdown value
  String? valueInformasiHarga = "1";
  String? valueKomoditas = "1";
  String? valueSubKomoditas;
  String? valuePasar;
  // String? valueKota = "0";
  DateTime? dateValue = DateTime.now();

  // validate dropdown date
  bool isDateEmpty = false;
  int currentIndex = 4;

  // value
  int average = 0;
  int stdDev = 0;

  String valueTriwulan() {
    String value = "";
    DateTime now = DateTime.now();
    switch (now.month) {
      case DateTime.january:
      case DateTime.february:
      case DateTime.march:
        value = "TW.I ${now.year}";
        break;
      case DateTime.april:
      case DateTime.may:
      case DateTime.june:
        value = "TW.II ${now.year}";
        break;
      case DateTime.july:
      case DateTime.august:
      case DateTime.september:
        value = "TW.III ${now.year}";
        break;
      case DateTime.october:
      case DateTime.november:
      case DateTime.december:
        value = "TW.IV ${now.year}";
        break;
      default:
        value = "";
    }
    return value;
  }

  getHomeDropdownData() async {
    emit(GetHomeInit());
    ApiReturn<HomeModel> result = await _homeService.getDropdown();
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      homeData = result.data;
      int komoditasLength = homeData?.komoditas?.length ?? 0;
      int kotaLength = homeData?.kota?.length ?? 0;
      int jenisPasarLength = homeData?.jenisPasar?.length ?? 0;

      for (var i = 0; i < komoditasLength; i++) {
        itemsKomoditas.add(DropdownMenuItem(
            value: homeData?.komoditas?[i].id.toString(),
            child: Text(homeData?.komoditas?[i].nama ?? "",
                maxLines: 3, style: const TextStyle(fontFamily: "Poppins"))));
      }

      for (var i = 0; i < kotaLength; i++) {
        itemsKota.add(DropdownMenuItem(
            value: homeData?.kota?[i].id.toString(),
            child: Text(homeData?.kota?[i].nama ?? "",
                maxLines: 3, style: const TextStyle(fontFamily: "Poppins"))));
      }
      for (var i = 0; i < jenisPasarLength; i++) {
        itemsJenisPasar.add(DropdownMenuItem(
            value: homeData?.jenisPasar?[i].id.toString(),
            child: Text(
              homeData?.jenisPasar?[i].nama ?? "",
              maxLines: 3,
              style: const TextStyle(fontFamily: "Poppins"),
            )));
      }

      await getDropdownSubKomoditas(homeData?.komoditas?[0].id.toString());
      valueSubKomoditas = _listSubKomoditas[0].id.toString();
      valuePasar = homeData?.jenisPasar?[1].id.toString();

      emit(GetHomeSuccess());
    } else {
      emit(GetHomeFailure(message: result.message));
    }
  }

  getDropdownSubKomoditas(String? id) async {
    emit(GetSubKomoditasInit());
    ApiReturn<List<SubKomoditasModel>> result = await _homeService
        .getDropdownSubKomoditas(id ?? _listSubKomoditas[0].id.toString());
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      valueSubKomoditas = null;
      _listSubKomoditas = result.data ?? [];
      itemsSubKomoditas.clear();
      for (var i = 0; i < _listSubKomoditas.length; i++) {
        itemsSubKomoditas.add(DropdownMenuItem(
            value: _listSubKomoditas[i].id.toString(),
            child: Text(
              _listSubKomoditas[i].nama ?? "",
              maxLines: 3,
              style: const TextStyle(fontFamily: "Poppins"),
            )));
      }
      emit(GetSubKomoditasSuccess());
    } else {
      emit(GetSubKomoditasFailure(message: result.message));
    }
  }

  // getHomeFilteredData({String opsi = "day"}) async {
  //   emit(GetHomeFilteredInit());
  //   ApiReturn<List<HomeFilteredModel>> result =
  //       await _homeService.getHomeFiltered(
  //           subKomoditasId: valueSubKomoditas ?? "",
  //           kota: valueKota ?? "",
  //           pasar: valuePasar ?? "",
  //           opsi: opsi,
  //           tanggal: GlobalMethodHelper.dateFormat(dateValue,
  //               formatDate: "yyyy-MM-dd"));
  //   if (result.status == AppConstant.API_STATUS_SUCCESS) {
  //     listDataHome = result.data ?? [];
  //     await _getAverage();
  //     await _getStdDev();
  //     emit(GetHomeFilteredSuccess());
  //   } else {
  //     emit(GetHomeFilteredFailure(message: result.message));
  //   }
  // }

  getHomeHistogramData({String opsi = "day"}) async {
    emit(GetHomeHistogramInit());
    ApiReturn<List<HistogramModel>> result =
        await _homeService.getHomeHistogram(
            subKomoditasId: valueSubKomoditas ?? "",
            pasar: valuePasar ?? "",
            opsi: opsi,
            tanggal: GlobalMethodHelper.dateFormat(dateValue,
                formatDate: "yyyy-MM-dd"));

    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      listDataHistogram = result.data ?? [];

      dataHarga.clear();
      dataKebutuhan.clear();
      dataKetersediaan.clear();
      for (var item in listDataHistogram) {
        dataKebutuhan.add(
            HistogramData(item.kota?.nama ?? "", item.rekapharga?.dk ?? 0));
        dataKetersediaan.add(
            HistogramData(item.kota?.nama ?? "", item.rekapharga?.dp ?? 0));

        if (valueInformasiHarga == "1") {
          dataHarga.add(HistogramData(
              item.kota?.nama ?? "", item.rekapharga?.harga ?? 0));
        } else {
          dataHarga.add(HistogramData(item.kota?.nama ?? "",
              item.persentase?.persentaseDetail?.value ?? 0));
        }
      }

      emit(GetHomeHistogramSuccess());
    } else {
      emit(GetHomeHistogramFailure(message: result.message));
    }
  }

  getInflasiPertumbuhan() async {
    emit(GetInflasiPertumbuhanInit());
    ApiReturn<InflasiPertumbuhanModel> result = await _homeService.getInflasiPertumbuhan();

    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      inflasiPertumbuhanData = result.data;
      emit(GetInflasiPertumbuhamSuccess());
    } else {
      emit(GetInflasiPertumbuhanFailure(message: result.message));
    }
  }

  // _getAverage() async {
  //   ApiReturn result = await _homeService.getAverage(
  //       subKomoditasId: valueSubKomoditas ?? "",
  //       pasar: valuePasar ?? "",
  //       tanggal:
  //           GlobalMethodHelper.dateFormat(dateValue, formatDate: "yyyy-MM-dd"));
  //   if (result.status == AppConstant.API_STATUS_SUCCESS) {
  //     average = result.data ?? 0;
  //   } else {
  //     emit(GetHomeFilteredFailure(message: result.message));
  //   }
  // }

  // _getStdDev() async {
  //   ApiReturn result = await _homeService.getStdDev(
  //       subKomoditasId: valueSubKomoditas ?? "",
  //       pasar: valuePasar ?? "",
  //       tanggal:
  //           GlobalMethodHelper.dateFormat(dateValue, formatDate: "yyyy-MM-dd"));
  //   if (result.status == AppConstant.API_STATUS_SUCCESS) {
  //     stdDev = result.data ?? 0;
  //   } else {
  //     emit(GetHomeFilteredFailure(message: result.message));
  //   }
  // }
}
