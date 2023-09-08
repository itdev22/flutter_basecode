import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../../bloc/trade/trade_cubit.dart';
import '../../../bloc/trade/trade_state.dart';
import '../../../model/home/trade_model/detail_trade_model.dart';
import '../../../utils/app_color.dart';
import '../../../utils/assets_helper.dart';
import '../../../utils/core/global_method_helper.dart';
import '../../../widget/error_handler.dart';
import '../../../widget/point_line_chart.dart';

class DetailTradingScreen extends StatefulWidget {
  final String id;
  const DetailTradingScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailTradingScreen> createState() => _DetailTradingScreenState();
}

class _DetailTradingScreenState extends State<DetailTradingScreen> {
  late TradeCubit _tradeCubit;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    _tradeCubit = BlocProvider.of(context);
    _tradeCubit.getDetailTrade(widget.id);

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _tradeCubit,
        builder: (context, state) {
          if (state is GetDetailTradeInit) {
            return Scaffold(
              body: SpinKitDoubleBounce(
                color: AppColor.primary,
                size: 75,
              ),
            );
          } else if (state is GetDetailTradeFailure) {
            return Scaffold(
              body: Center(child: ErrorHandler(
                refresh: () {
                  _tradeCubit.getDetailTrade(widget.id);
                },
              )),
            );
          } else {
            Color? colorIndicator;
            String? iconIndicator;
            switch (_tradeCubit.statusIndicator) {
              case "up":
                colorIndicator = AppColor.bgRed;
                iconIndicator = Assets.icArrowUp1;
                break;
              case "flat":
                colorIndicator = const Color(0xFF297FBA);
                iconIndicator = Assets.icPause;
                break;
              case "down":
                colorIndicator = AppColor.green;
                iconIndicator = Assets.icArrowDown1;
                break;
              default:
            }
            return Scaffold(
              body: ListView(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 24.h),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(Assets.icArrowLeft)),
                            Text(
                              "Detail Informasi",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 24.w,
                            )
                          ])),
                  Container(
                    width: 1.sw,
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(Assets.imgBg), fit: BoxFit.cover),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(Assets.icLocation),
                            SizedBox(width: 4.w),
                            Text(
                              _tradeCubit.kota,
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.black),
                            )
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                  color: AppColor.primary,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      topRight: Radius.circular(10.r))),
                              child: Center(
                                child: Text(
                                  _tradeCubit.detailTradeData?.nama ?? "",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Container(
                              width: 1.sw,
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 16.h),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 1.sw,
                                    height: 300.h,
                                    child: PointsLineChart(
                                        PointsLineChart.dataHistogram(_tradeCubit.getDetailHistogramData().reversed.toList()),
                                        animate: true),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 4.h),
                                        color: colorIndicator,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SvgPicture.asset(iconIndicator??Assets.icPause),
                                            SizedBox(width: 8.w),
                                            Text(_tradeCubit.indicatorPrice,
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              GlobalMethodHelper.formatNumberCurrency(_tradeCubit.average),
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600)),
                                          Text("per Kg",
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: Colors.black))
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Beras Kualitas Bawah",
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600)),
                                      Text(
                                          "Data harga diambil dari 5 hari terakhir",
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: AppColor.textGrey,
                                          ))
                                    ],
                                  ),
                                ),
                                // GestureDetector(
                                //   onTap: () {},
                                //   child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         SizedBox(
                                //             width: 18.w,
                                //             height: 20.h,
                                //             child: SvgPicture.asset(
                                //               Assets.icDownload,
                                //               fit: BoxFit.fitHeight,
                                //             )),
                                //         SizedBox(width: 4.w),
                                //         GestureDetector(
                                //           onTap: () {
                                //             _tradeCubit.downloadFile(
                                //                 widget.id, _tradeCubit.kota);
                                //           },
                                //           child: Text(
                                //             "Download Data",
                                //             style: TextStyle(
                                //                 fontSize: 12.sp,
                                //                 color: AppColor.primary),
                                //           ),
                                //         )
                                //       ]),
                                // )
                              ]),
                        ),
                        SizedBox(height: 16.h),
                        SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.primary,
                                border: Border.all(color: AppColor.primary)),
                            child: Column(
                              children: [
                                tableHeader(),
                                for (var i = 0;i <(_tradeCubit.detailTradeData?.pemilik?.length ??0);i++)
                                  tableContent(
                                      kota: _tradeCubit.detailTradeData?.pemilik?[i].kota?.nama ??"-",
                                      data: _tradeCubit.detailTradeData?.pemilik?[i].tabelharga ??[],
                                      index: i + 1)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }

  Row tableContent(
      {required String kota,
      required List<TabelHarga> data,
      required int index}) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: index % 2 == 1 ? const Color(0xFFE5E5E5) : Colors.white,
              border: Border(right: BorderSide(color: AppColor.primary))),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          width: 175.w,
          child: Center(
              child: Text(kota,
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w600))),
        ),
        for (var i = 0; i < data.length; i++)
          Container(
            decoration: BoxDecoration(
                color: index % 2 == 1 ? const Color(0xFFE5E5E5) : Colors.white,
                border: Border(right: BorderSide(color: AppColor.primary))),
            padding: EdgeInsets.symmetric(
              vertical: 4.h,
            ),
            width: 100.w,
            child: Center(
                child: Text(
                    data.reversed.toList()[i].harga != null? GlobalMethodHelper.formatNumberCurrency(data.reversed.toList()[i].harga ?? 0): "-",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400))),
          ),
      ],
    );
  }

  Widget tableHeader() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(color: AppColor.primary),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              width: 175.w,
              child: Center(
                  child: Text("Pasar",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            for (var i = 0; i < 5; i++)
              Container(
                decoration: BoxDecoration(color: AppColor.primary),
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                ),
                width: 100.w,
                child: Center(
                    child: Text(
                        GlobalMethodHelper.dateFormat(DateTime.parse(_tradeCubit.detailTradeData?.semuakota?.rekapharga?.reversed.toList()[i].hari 
                        ??GlobalMethodHelper.dateFormat(DateTime.now(),formatDate: "yyyy-MM-dd")),formatDate: "dd MMMM"),
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600))),
              ),
          ],
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(right: BorderSide(color: AppColor.primary))),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              width: 175.w,
              child: Center(
                  child: Text("Semua Kota",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w600))),
            ),
            for (var i = 0; i < 5; i++)
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(right: BorderSide(color: AppColor.primary))),
                padding: EdgeInsets.symmetric(
                  vertical: 4.h,
                ),
                width: 100.w,
                child: Center(
                    child: Text(
                        _tradeCubit.detailTradeData?.semuakota?.rekapharga?.reversed.toList()[i].harga !=null
                        ? GlobalMethodHelper.formatNumberCurrency(_tradeCubit.detailTradeData?.semuakota?.rekapharga?.reversed.toList()[i].harga ??0)
                        : "-",
                        style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w400))),
              ),
          ],
        )
      ],
    );
  }
}
