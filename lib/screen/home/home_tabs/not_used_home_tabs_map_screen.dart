import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../bloc/home/home_cubit.dart';
import '../../../bloc/home/home_state.dart';
import '../../../utils/app_color.dart';
import '../../../utils/core/global_method_helper.dart';
import '../../../utils/map_assets.dart';
import '../../../widget/error_handler.dart';
import '../../../widget/no_data.dart';

class HomeTabsMapScreen extends StatefulWidget {
  final HomeCubit bloc;
  const HomeTabsMapScreen({
    Key? key,
    required this.bloc,
  }) : super(key: key);

  @override
  State<HomeTabsMapScreen> createState() => _HomeTabsMapScreenState();
}

class _HomeTabsMapScreenState extends State<HomeTabsMapScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: widget.bloc,
        builder: (context, state) {
          if (state is GetHomeFilteredInit) {
            return SpinKitFadingCircle(
              color: AppColor.primary,
            );
          } else if (state is GetHomeFilteredFailure) {
            return SingleChildScrollView(
              child: ErrorHandler(
                refresh: () {
                  // widget.bloc.getHomeFilteredData();
                },
              ),
            );
          } else {
            if (widget.bloc.listDataHome.isEmpty) {
              return  const SingleChildScrollView(
                child: NoData(
                          text: "Data Kosong",
                        ),
              );
            } else {
              return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              children:  [
                      Text(
                          (widget.bloc.listDataHome[0].pemilik?.subkomoditas?.nama).toString(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w600)),
                      SizedBox(height: 8.h),
                      Divider(
                        height: 1.h,
                        thickness: 2,
                        color: AppColor.grey,
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Row(
                                children: [
                                  buttonTime(
                                      time: "1D", index: 0, value: "day"),
                                  buttonTime(
                                      time: "1W", index: 1, value: "week"),
                                  buttonTime(
                                      time: "1M", index: 2, value: "month"),
                                ],
                              ),
                              Text(
                                "Tanggal : ${GlobalMethodHelper.dateFormat(DateTime.parse(widget.bloc.listDataHome[0].tanggal ?? DateTime.now().toString()))}",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.black),
                              )
                            ],
                          )),
                      Divider(
                        height: 1.h,
                        thickness: 2,
                        color: AppColor.grey,
                      ),

                      // Map view, if not select all city
                      // if (widget.bloc.valueKota != "0") maps(id: widget.bloc.valueKota ?? "",status:widget.bloc.valueInformasiHarga == "1"? widget.bloc.listDataHome[0].klasifikasi ??"empty": widget.bloc.listDataHome[0].persentase?.klasifikasi??"empty"),
                      // 

                      SizedBox(height: 32.h,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("RATA-RATA\t: ${GlobalMethodHelper.formatNumberCurrency(widget.bloc.average)}"),
                          Text("STDEV\t\t\t\t\t\t\t\t\t: ${GlobalMethodHelper.formatNumberCurrency(widget.bloc.stdDev)}"),
                        ],
                      ),
                      SizedBox(height: 32.h),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(13),
                          1: FlexColumnWidth(7),
                        },
                        border: TableBorder(
                          top: BorderSide(color: AppColor.primary),
                          bottom: BorderSide(color: AppColor.primary),
                          horizontalInside: BorderSide(color: AppColor.primary),
                          left: BorderSide(color: AppColor.primary),
                          right: BorderSide(color: AppColor.primary),
                          verticalInside: BorderSide(color: AppColor.primary),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        children: [
                          TableRow(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5.r),
                                      topRight: Radius.circular(5.r)),
                                  color: AppColor.primary),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Text("Kota/Kabupaten",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Text(
                                      widget.bloc.valueInformasiHarga == "1" ||
                                              widget.bloc.valueInformasiHarga ==
                                                  null
                                          ? "Harga"
                                          : "Perubahan",
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ]),
                          for (var i = 0;i < (widget.bloc.listDataHome.length);i++)
                            TableRow(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Text((widget.bloc.listDataHome[i].pemilik?.kota?.nama ??"").toString(),
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400)),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 8.h),
                                  child: Text(
                                      widget.bloc.valueInformasiHarga == "1" ||widget.bloc.valueInformasiHarga ==null
                                          ? GlobalMethodHelper.formatNumberCurrency(widget.bloc.listDataHome[i].harga ??0)
                                          : ("${widget.bloc.listDataHome[i].persentase?.persentaseDetail?.value ?? "0"}%"),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
            );
            }
          }
        });
  }

  Column maps({required String id, required String status}) {
    String asset = "";
    Color? color;
    switch (id) {
      case "1":
        asset = MapAssets.mapKotaKendari;
        break;
      case "2":
        asset = MapAssets.mapKotaBaubau;
        break;
      case "3":
        asset = MapAssets.mapKabupatenKolaka;
        break;
      case "4":
        asset = MapAssets.mapKabupatenKolakaTimur;
        break;
      case "5":
        asset = MapAssets.mapKabupatenKolakaUtara;
        break;
      case "6":
        asset = MapAssets.mapKabupatenMuna;
        break;
      case "7":
        asset = MapAssets.mapKabupatenMunaBarat;
        break;
      case "8":
        asset = MapAssets.mapKabupatenKonawe;
        break;
      case "9":
        asset = MapAssets.mapKabupatenKonaweSelatan;
        break;
      case "10":
        asset = MapAssets.mapKabupatenKonaweUtara;
        break;
      case "11":
        asset = MapAssets.mapKabupatenKonaweKepulauan;
        break;
      case "12":
        asset = MapAssets.mapKabupatenButon;
        break;
      case "13":
        asset = MapAssets.mapKabupatenButonSelatan;
        break;
      case "14":
        asset = MapAssets.mapKabupatenButonTengah;
        break;
      case "15":
        asset = MapAssets.mapKabupatenButonUtara;
        break;
      case "16":
        asset = MapAssets.mapKabupatenBombana;
        break;
      case "17":
        asset = MapAssets.mapKabupatenWakatobi;
        break;
      default:
    }
    switch (status) {
      case "kurangpol":
        color = AppColor.mapGreen;
        break;
      case "kurang":
        color = AppColor.mapGreen1;
        break;
      case "podoae":
        color = AppColor.mapGreen2;
        break;
      case "naik":
        color = AppColor.mapRed;
        break;
      case "naikpol":
        color = AppColor.mapRed1;
        break;
      case "noupdate":
        color = AppColor.mapGrey;
        break;
      case "empty":
        color = AppColor.mapWhite;
        break;
      default:
    }
    return Column(
      children: [
        SizedBox(
          height: 32.h,
        ),
        SizedBox(
          width: 1.sw,
          height: 250.h,
          child: SvgPicture.asset(
            asset,
            fit: BoxFit.fitHeight,
            color: color,
          ),
        ),
        SizedBox(
          height: 32.h,
        ),
        Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 6.h,
                color: AppColor.mapGreen,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: 6.h,
                color: AppColor.mapGreen1,
              ),
            ),
            Flexible(
                flex: 2,
                child: Container(
                  height: 6.h,
                  color: AppColor.mapGreen2,
                )),
            Flexible(
              flex: 1,
              child: Container(
                height: 6.h,
                color: AppColor.mapRed,
              ),
            ),
            Flexible(
              flex: 1,
              child: Container(
                height: 6.h,
                color: AppColor.mapRed1,
              ),
            ),
            Flexible(
                flex: 2,
                child: Container(height: 6.h, color: AppColor.mapGrey)),
            Flexible(
                flex: 2,
                child: Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: AppColor.mapWhite,
                      border: Border.all(width: 1.h, color: Colors.black)),
                )),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 2,
                child: Text("Harga Turun",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))),
            Flexible(
                flex: 2,
                child: Text("Harga Tetap",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))),
            Flexible(
                flex: 2,
                child: Text("Harga Naik",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))),
            Flexible(
                flex: 2,
                child: Text("Tidak Update",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))),
            Flexible(
                flex: 2,
                child: Text("Tidak Ada Data",
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500))),
          ],
        ),
       
      ],
    );
  }

  Expanded cardHome(String label, String changes, String icon, String test) {
    return Expanded(
        child: Column(
      children: [
        Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: AppColor.primary,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          color: Colors.white,
          child: Column(
            children: [
              Text(changes,
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                color: AppColor.green, // AppColor.bgRed

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(icon),
                    SizedBox(width: 6.w),
                    Text(
                      test,
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    ));
  }

  Widget buttonTime(
      {required String time, required int index, required String value}) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      child: InkWell(
        splashColor: AppColor.bgGrey,
        borderRadius: BorderRadius.circular(8.r),
        onTap: widget.bloc.valueInformasiHarga != "2"
            ? null
            : () {
               if ( widget.bloc.currentIndex != index) {
                  widget.bloc.currentIndex = index;
                  // widget.bloc.getHomeFilteredData(opsi: value);
               }
              },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: widget.bloc.valueInformasiHarga == "1"
                ? const Color(0xFFE5E5E5)
                : index == widget.bloc.currentIndex
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
