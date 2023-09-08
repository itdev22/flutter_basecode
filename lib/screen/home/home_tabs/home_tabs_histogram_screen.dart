import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../bloc/home/home_cubit.dart';
import '../../../bloc/home/home_state.dart';
import '../../../utils/app_color.dart';
import '../../../utils/core/global_method_helper.dart';
import '../../../widget/error_handler.dart';
import '../../../widget/histogram.dart';
import '../../../widget/no_data.dart';

class HomeTabsHistogramScreen extends StatefulWidget {
  final HomeCubit bloc;

  const HomeTabsHistogramScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  State<HomeTabsHistogramScreen> createState() =>
      _HomeTabsHistogramScreenState();
}

class _HomeTabsHistogramScreenState extends State<HomeTabsHistogramScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is GetHomeHistogramInit) {
            return SpinKitFadingCircle(
              color: AppColor.primary,
            );
          } else if (state is GetHomeHistogramFailure) {
            return SingleChildScrollView(
              child: ErrorHandler(
                refresh: () {
                  widget.bloc.getHomeHistogramData();
                },
              ),
            );
          } else {
            if (widget.bloc.listDataHistogram.isEmpty) {
              return const SingleChildScrollView(
                child: SizedBox(
                          child: NoData(
                            text: "Data Kosong",
                          ),
                        ),
              );
            } else {
              return ListView(
              children:  [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: EdgeInsets.symmetric(horizontal: 32.w),
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       SizedBox(height: 8.h),
                            //       // Text("Harga Rata-Rata dan Perubahan",
                            //       //     style: TextStyle(
                            //       //         fontSize: 14.sp,
                            //       //         color: Colors.black,
                            //       //         fontWeight: FontWeight.w600)),    
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 4.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
                              child: Column(
                                children: [
                                  Divider(
                                    height: 1.h,
                                    thickness: 2,
                                    color: AppColor.grey,
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Row(
                                            children: [
                                              buttonTime(
                                                  time: "1D",
                                                  index: 0,
                                                  value: "day"),
                                              buttonTime(
                                                  time: "1W",
                                                  index: 1,
                                                  value: "week"),
                                              buttonTime(
                                                  time: "1M",
                                                  index: 2,
                                                  value: "month"),
                                            ],
                                          ),
                                          Text(
                                            "Tanggal : ${GlobalMethodHelper.dateFormat(widget.bloc.dateValue)}",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                color: Colors.black),
                                          )
                                        ],
                                      )),
                                  Divider(
                                    height: 1.h,
                                    thickness: 2,
                                    color: AppColor.grey,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),
                            SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 8.h),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColor.primary)),
                                width: widget.bloc.listDataHistogram.isEmpty
                                    ? 1.sw
                                    : widget.bloc.listDataHistogram.length *
                                        100,
                                height: 0.6.sh,
                                child: HistogramHome(
                                  _histogramData(),
                                  animate: true,
                                  labelSecondary:
                                      widget.bloc.valueInformasiHarga != "2"
                                          ? "Data Harga"
                                          : "Perubahan Harga",
                                ),
                              ),
                            )
                          ]),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  height: 10.h,
                                  color: const Color(0xFF124DB6),
                                ),
                                Text("Data Kebutuhan",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  height: 10.h,
                                  color: const Color(0xFFADCEB2),
                                ),
                                Text("Data Ketersediaan",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))
                              ],
                            )),
                            Expanded(
                                child: Column(
                              children: [
                                Container(
                                  height: 10.h,
                                  color: const Color(0xFFE86262),
                                ),
                                Text(
                                    widget.bloc.valueInformasiHarga != "2"
                                        ? "Data Harga"
                                        : "Perubahan Harga",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600))
                              ],
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            tableHeader(),
                            for (var i = 0;
                                i < widget.bloc.listDataHistogram.length;
                                i++)
                              tableContent(
                                i + 1,
                                widget.bloc.listDataHistogram[i].kota?.nama ??"-",
                                widget.bloc.listDataHistogram[i].rekapharga?.dk.toString() ?? "0",
                                widget.bloc.listDataHistogram[i].rekapharga?.dp.toString() ??"0",
                                widget.bloc.valueInformasiHarga != "2"
                                    ?  GlobalMethodHelper.formatNumberCurrency(widget.bloc.listDataHistogram[i].rekapharga
                                    ?.harga ?? 0)
                                    : (widget.bloc.listDataHistogram[i].persentase?.persentaseDetail?.value ?? 0).toString() + "%",
                               
                              )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 32.h,
                      )
                    ],
            );
            }
          }
        });
  }

  List<charts.Series<HistogramData, String>> _histogramData() {
    const secondaryMeasureAxisId = 'secondaryMeasureAxisId';

    return [
      charts.Series<HistogramData, String>(
          id: 'Harga',
          colorFn: (_, __) => charts.Color.fromHex(code: "#E86262"),
          domainFn: (HistogramData data, _) => data.kota,
          measureFn: (HistogramData data, _) => data.value,
          data: widget.bloc.dataHarga)
        ..setAttribute(charts.measureAxisIdKey, secondaryMeasureAxisId),
      charts.Series<HistogramData, String>(
        id: 'DK',
        colorFn: (_, __) => charts.Color.fromHex(code: "#124DB6"),
        domainFn: (HistogramData data, _) => data.kota,
        measureFn: (HistogramData data, _) => data.value,
        data: widget.bloc.dataKebutuhan,
      )..setAttribute(charts.rendererIdKey, 'customBar'),
      charts.Series<HistogramData, String>(
        id: 'DP',
        colorFn: (_, __) => charts.Color.fromHex(code: "#ADCEB2"),
        domainFn: (HistogramData data, _) => data.kota,
        measureFn: (HistogramData data, _) => data.value,
        data: widget.bloc.dataKetersediaan,
      )..setAttribute(charts.rendererIdKey, 'customBar')
    ];
  }

  Row tableContent(int index, String kota, String dk, String dp, String harga) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? const Color(0xFFE5E5E5) : Colors.white,
              border: Border(right: BorderSide(color: AppColor.primary))),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          width: 175.w,
          child: Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(kota,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? const Color(0xFFE5E5E5) : Colors.white,
              border: Border(right: BorderSide(color: AppColor.primary))),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          width: 100.w,
          child: Center(
              child: Text(dk,
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400))),
        ),
        Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? const Color(0xFFE5E5E5) : Colors.white,
              border: Border(right: BorderSide(color: AppColor.primary))),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          width: 100.w,
          child: Center(
              child: Text(dp,
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400))),
        ),
        Container(
          decoration: BoxDecoration(
              color: index % 2 == 0 ? const Color(0xFFE5E5E5) : Colors.white,
              border: Border(right: BorderSide(color: AppColor.primary))),
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
          ),
          width: 100.w,
          child: Center(
              child: Text(harga,
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
                  child: Text("Kota",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            Container(
              decoration: BoxDecoration(color: AppColor.primary),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              width: 100.w,
              child: Center(
                  child: Text("DK",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            Container(
              decoration: BoxDecoration(color: AppColor.primary),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              width: 100.w,
              child: Center(
                  child: Text("DP",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
            Container(
              decoration: BoxDecoration(color: AppColor.primary),
              padding: EdgeInsets.symmetric(
                vertical: 4.h,
              ),
              width: 100.w,
              child: Center(
                  child: Text(widget.bloc.valueInformasiHarga != "2"? " Harga": "Perubahan ",
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600))),
            ),
          ],
        ),
      ],
    );
  }

  Widget buttonTime(
      {required String time, required int index, required String value}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: InkWell(
        splashColor: AppColor.bgGrey,
        borderRadius: BorderRadius.circular(8.r),
        onTap: widget.bloc.valueInformasiHarga != "2"?null:() {
                if (widget.bloc.currentIndex != index) {
                  widget.bloc.currentIndex = index;
                  widget.bloc.getHomeHistogramData(opsi: value);
                }
              },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: widget.bloc.valueInformasiHarga == "1"
                ? const Color(0xFFE5E5E5)
                :index == widget.bloc.currentIndex
                    ? AppColor.primary
                    : Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          child: Text(time,
              style: TextStyle(
                  fontSize: 12.sp,
                  color: index == widget.bloc.currentIndex
                      ? Colors.white
                      : AppColor.textGrey,
                  fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }
}
