import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/trade/trade_cubit.dart';
import '../../bloc/trade/trade_state.dart';
import '../../utils/app_color.dart';
import '../../utils/app_route.dart';
import '../../utils/assets_helper.dart';
import '../../utils/core/global_method_helper.dart';
import '../../widget/button.dart';
import '../../widget/dropdown.dart';
import '../../widget/error_handler.dart';
import '../../widget/point_line_chart.dart';

class TradingScreen extends StatefulWidget {
  const TradingScreen({Key? key}) : super(key: key);

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  late TradeCubit _tradeCubit;

  @override
  void initState() {
    super.initState();
    _tradeCubit = BlocProvider.of(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await _tradeCubit.getTradeDropdownData();
      await _tradeCubit.getListTrade();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _tradeCubit,
        builder: (context, state) {
          if (state is GetTradeInit) {
            return SpinKitDoubleBounce(
              color: AppColor.primary,
              size: 75,
            );
          } else if (state is GetTradeFailure) {
            return SingleChildScrollView(
              child: Center(child: ErrorHandler(
                refresh: () async {
                  await _tradeCubit.getTradeDropdownData();
                  await _tradeCubit.getListTrade();
                },
              )),
            );
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                    child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 24.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(Assets.imgLogoHome),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, Routes.suggestion);
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(right: 8.w),
                                      child: const Icon(
                                          Icons.mail_outline_rounded)),
                                )
                              ],
                            )),
                        Container(
                          width: 1.sw,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24.w, vertical: 32.h),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(Assets.imgBg),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 16.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("CEK PERUBAHAN HARGA ",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: 24.h),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Kota",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 8.h),
                                          DropDown(
                                              items: _tradeCubit.itemsKota,
                                              value: _tradeCubit.valueKota,
                                              onChanged: (str) {
                                                _tradeCubit.valueKota = str;
                                              }),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 16.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Jenis Pasar",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500)),
                                          SizedBox(height: 8.h),
                                          DropDown(
                                              items: _tradeCubit.itemsJenisPasar.reversed.toList(),
                                              value: _tradeCubit.valuePasar,
                                              onChanged: (str) {
                                                _tradeCubit.valuePasar = str;
                                              }),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 24.h),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Button(
                                      onPressed: () {
                                        _tradeCubit.getListTrade();
                                      },
                                      text: "Submit",
                                      hPadding: 40.w,
                                      vPadding: 13.h,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 24.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Harga Rata-Rata dan Perubahan",
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 4.h),
                              Text(
                                  GlobalMethodHelper.dateFormat(DateTime.now()),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400)),
                              SizedBox(height: 16.h),
                              GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _tradeCubit.listTrade.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 270.h,
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 12),
                                  itemBuilder: (context, index) {
                                    // int _totalHarga = 0;
                                    // double _harga = 0;
                                    String icStatus = Assets.icArrowUp1;
                                    Color color = AppColor.green;

                                    switch (_tradeCubit.listTrade[index].indicator?["status"]) {
                                      case "up":
                                        icStatus = Assets.icArrowUp1;
                                        color = AppColor.bgRed;
                                        break;
                                      case "flat":
                                        icStatus = Assets.icPause;
                                        color = const Color(0xFF297FBA);
                                        break;
                                      case "down":
                                        icStatus = Assets.icArrowDown1;
                                        color = AppColor.green;
                                        break;
                                      default:
                                    }
                                    // for (var i = 0;i <(_tradeCubit.listTrade[index].rekapharga?.length ??0);i++) {
                                    //   _totalHarga += (_tradeCubit.listTrade[index].rekapharga?[i].harga ??0);
                                    // }
                                    // _harga = (_totalHarga /(_tradeCubit.listTrade[index].rekapharga?.length ?? 0));
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(context, Routes.detailTrading,arguments: _tradeCubit.listTrade[index].id.toString());
                                      },
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 1.sw,
                                            height: 40.h,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h),
                                            decoration: BoxDecoration(
                                                color: AppColor.primary,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10.r),
                                                    topRight:
                                                        Radius.circular(10.r))),
                                            child: Text(_tradeCubit.listTrade[index].nama ??"-",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: AppColor.primary),
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10.r),
                                                    bottomRight:
                                                        Radius.circular(10.r))),
                                            width: 1.sw,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 8.h),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    width: 1.sw,
                                                    height: 96.h,
                                                    child: PointsLineChart(
                                                        PointsLineChart.dataHistogram(_tradeCubit.getHistogramData(index).reversed.toList()),
                                                        animate: true)),
                                                SizedBox(height: 32.h),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 5.w,
                                                      vertical: 4.h),
                                                  color: color,
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        icStatus,
                                                        width: 24.w,
                                                        height: 24.h,
                                                        fit: BoxFit.scaleDown,
                                                      ),
                                                      const SizedBox(width: 3),
                                                      Text(
                                                          "${_tradeCubit.listTrade[index].indicator?["persentase"] < 0 ? (_tradeCubit.listTrade[index].indicator?["persentase"] * -1) : _tradeCubit.listTrade[index].indicator?["persentase"]}% - ${GlobalMethodHelper.formatNumberCurrency(_tradeCubit.listTrade[index].indicator?["harga"] < 0 ? (_tradeCubit.listTrade[index].indicator?["harga"] * -1) : _tradeCubit.listTrade[index].indicator?["harga"] ?? 0)}",
                                                          style: TextStyle(
                                                              fontSize: 10.sp,
                                                              color:Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                    GlobalMethodHelper.formatNumberCurrency(_tradeCubit.listTrade[index].rekapharga?.reversed.toList().last.harga??0),
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                Text("per Kg",
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: Colors.black))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )));
          }
        });
  }
}
