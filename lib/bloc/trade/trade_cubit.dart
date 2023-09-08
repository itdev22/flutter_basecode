import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../app.dart';
import '../../model/api_return/api_return.dart';
import '../../model/home/home_dropdown/home_model.dart';
import '../../model/home/trade_model/detail_trade_model.dart';
import '../../model/home/trade_model/trade_model.dart';
import '../../services/home_service.dart';
import '../../services/trade_service.dart';
import '../../utils/app_constant.dart';
import '../../utils/core/global_method_helper.dart';
import '../../widget/point_line_chart.dart';
import 'trade_state.dart';

class TradeCubit extends Cubit<TradeState> {
  TradeCubit() : super(TradeState());

  final HomeService _homeService = HomeService();
  final TradeService _tradeService = TradeService();

  //Model Home
  HomeModel? homeData;
  List<TradeModel> listTrade = [];
  DetailTradeModel? detailTradeData;
  //

  // List item dropdown
  List<DropdownMenuItem<String>> itemsKota = [];
  List<DropdownMenuItem<String>> itemsJenisPasar = [];
  //

  // Dropdown value
  String? valuePasar;
  String? valueKota;
  //

  String kota = "";
  String statusIndicator = "";
  String indicatorPrice = "";
  int average = 0;

  getTradeDropdownData() async {
    emit(GetTradeInit());
    ApiReturn<HomeModel> result = await _homeService.getDropdown();
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      homeData = result.data;
      int kotaLength = homeData?.kota?.length ?? 0;
      int jenisPasarLength = homeData?.jenisPasar?.length ?? 0;
      itemsKota.clear();
      itemsJenisPasar.clear();
      // itemsKota.add(const DropdownMenuItem(
      //     value: "0",
      //     child: Text("Semua Kota",
      //         maxLines: 3, style: TextStyle(fontFamily: "Poppins"))));
      for (var i = 0; i < kotaLength; i++) {
        itemsKota.add(DropdownMenuItem(
            value: homeData?.kota?[i].id.toString(),
            child: Text(homeData?.kota?[i].nama ?? "",
                maxLines: 3, style: const TextStyle(fontFamily: "Poppins"))));
      }
      for (var i = 0; i < jenisPasarLength; i++) {
        itemsJenisPasar.add(DropdownMenuItem(
            value: homeData?.jenisPasar?[i].id.toString(),
            child: Text(homeData?.jenisPasar?[i].nama ?? "",
                maxLines: 3, style: const TextStyle(fontFamily: "Poppins"))));
      }

      valueKota = homeData?.kota?[0].id.toString();
      valuePasar = homeData?.jenisPasar?[1].id.toString();

      emit(GetTradeSuccess());
    } else {
      emit(GetTradeFailure(message: result.message));
    }
  }

  List<DataPerWeek> getHistogramData(int index) {
    List<DataPerWeek> histogramData = [];

    for (var i = 0; i < (listTrade[index].rekapharga?.length ?? 0); i++) {
      histogramData.add(DataPerWeek(
          GlobalMethodHelper.dateFormat(
              DateTime.parse(listTrade[index].rekapharga?[i].tanggal ?? ""),
              formatDate: "dd"),
          listTrade[index].rekapharga?[i].harga ?? 0));
    }

    return histogramData;
  }

  getListTrade() async {
    emit(GetTradeInit());
    ApiReturn<List<TradeModel>> result = await _tradeService.getTrade(
        pasar: valuePasar ?? "0", kotaId: valueKota ?? "0");
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      listTrade = result.data ?? [];

      emit(GetTradeSuccess());
    } else {
      emit(GetTradeFailure(message: result.message));
    }
  }

  getDetailTrade(String id) async {
    emit(GetDetailTradeInit());
    ApiReturn<DetailTradeModel> result = await _tradeService.getDetailTrade(
        id: id, kotaId: valueKota ?? "0", pasarId: valuePasar ?? "0");
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      detailTradeData = result.data;
      _countData();

      emit(GetDetailTradeSuccess());
    } else {
      emit(GetDetailTradeFailure(message: result.message));
    }
  }

  _countData() {
    if (valueKota == "0") {
      // int _totalHarga = 0;

      // for (var i = 0;
      //     i < (detailTradeData?.semuakota?.rekapharga?.length ?? 0);
      //     i++) {
      //   _totalHarga += detailTradeData?.semuakota?.rekapharga?[i].harga ?? 0;
      // }
      // average = (_totalHarga / (detailTradeData?.semuakota?.rekapharga?.length ?? 1));
      average = detailTradeData?.semuakota?.rekapharga?.reversed.toList().last.harga ?? 0;

      //
      int _valueHarga = (detailTradeData?.semuakota?.indicator?.harga ?? 0);
      double _valuePersen = (detailTradeData?.semuakota?.indicator?.persentase ?? 0);
      String _valueStatus = detailTradeData?.semuakota?.indicator?.status ?? "";

      statusIndicator = _valueStatus;
      indicatorPrice = "${_valuePersen < 0 ? _valuePersen * -1 : _valuePersen}% - ${GlobalMethodHelper.formatNumberCurrency(_valueHarga < 0 ? _valueHarga * -1 : _valueHarga)}";
      kota = "Semua Kota";
    } else {
      // int _totalHarga = 0;

      for (var i = 0; i < (detailTradeData?.pemilik?.length ?? 0); i++) {
        // for (var x = 0;
        //     x < (detailTradeData?.pemilik?[i].rekapharga?.length ?? 0);
        //     x++) {
        //   _totalHarga += detailTradeData?.pemilik?[i].rekapharga?[x].harga ?? 0;
        // }

        //
        int _valueHarga = (detailTradeData?.pemilik?[i].indicator?.harga ?? 0);
        double _valuePersen = (detailTradeData?.pemilik?[i].indicator?.persentase ?? 0);
        String _valueStatus = detailTradeData?.pemilik?[i].indicator?.status ?? "";

        statusIndicator = _valueStatus;
        indicatorPrice = "${_valuePersen < 0 ? _valuePersen * -1 : _valuePersen}% - ${GlobalMethodHelper.formatNumberCurrency(_valueHarga < 0 ? _valueHarga * -1 : _valueHarga)}";
        kota = detailTradeData?.pemilik?[i].kota?.nama ?? "";
        // average = (_totalHarga / (detailTradeData?.pemilik?[i].rekapharga?.length ?? 1));
        average = detailTradeData?.pemilik?[i].rekapharga?.reversed.toList().last.harga ?? 0;

      }
    }
  }

  List<DataPerWeek> getDetailHistogramData() {
    List<DataPerWeek> histogramData = [];
    if (valueKota == "0") {
      for (var i = 0;
          i < (detailTradeData?.semuakota?.rekapharga?.length ?? 0);
          i++) {
        histogramData.add(DataPerWeek(
            GlobalMethodHelper.dateFormat(DateTime.parse(
                detailTradeData?.semuakota?.rekapharga?[i].hari.toString() ??
                    "")),
            detailTradeData?.semuakota?.rekapharga?[i].harga ?? 0));
      }
    } else {
      for (var i = 0; i < (detailTradeData?.pemilik?.length ?? 0); i++) {
        for (var x = 0;
            x < (detailTradeData?.pemilik?[i].rekapharga?.length ?? 0);
            x++) {
          histogramData.add(DataPerWeek(
              GlobalMethodHelper.dateFormat(DateTime.parse(detailTradeData
                      ?.pemilik?[i].rekapharga?[x].tanggal
                      .toString() ??
                  "")),
              detailTradeData?.pemilik?[i].rekapharga?[x].harga ?? 0));
        }
      }
    }

    return histogramData;
  }

  downloadFile(String id, String kotaName) async {
    const permission = Permission.storage;
    final status = await permission.status;
    if (status.isGranted) {
      _pickPathAndDownload(id, kotaName);
    } else if (status.isDenied) {
      await permission.request();
      _pickPathAndDownload(id, kotaName);
    } else if (status.isPermanentlyDenied) {
      await permission.request();
      _pickPathAndDownload(id, kotaName);
    }
  }

  _pickPathAndDownload(String id, String kotaName) async {

    String? result = await FilePicker.platform.getDirectoryPath();
    String kota = "";
    List splitKotaName = kotaName.split(" ");

    for (var i = 1; i < splitKotaName.length; i++) {
      kota += splitKotaName[i];
    }

    await FlutterDownloader.enqueue(
      url:"${App().apiBaseURL}perdagangan/detailexport/$id/$valueKota/$valuePasar",
      savedDir: result!,
      fileName: "Report-Kota$kota.xlsx",
      showNotification: true,
      openFileFromNotification: true,
    );
  }
}
