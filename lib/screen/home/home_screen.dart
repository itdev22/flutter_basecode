import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

import '../../bloc/home/home_cubit.dart';
import '../../bloc/home/home_state.dart';
import '../../model/home/inflasi_pertumbuhan_model.dart';
import '../../utils/app_color.dart';
import '../../utils/app_route.dart';
import '../../utils/assets_helper.dart';
import '../../utils/core/global_method_helper.dart';
import '../../widget/button.dart';
import '../../widget/dropdown.dart';
import '../../widget/error_handler.dart';
import 'home_tabs/home_tabs_histogram_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin  {
  late TabController _tabController;

  
  final HomeCubit _homeCubit = HomeCubit();
  // final HomeCubit _homeCubitFiltered = HomeCubit();
  final HomeCubit _homeCubitFilteredHistogram = HomeCubit();
  final key = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 1);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      _homeCubit.getInflasiPertumbuhan();
      await _homeCubit.getHomeDropdownData();
      // await _homeCubitFiltered.getHomeDropdownData();
      await _homeCubitFilteredHistogram.getHomeDropdownData();
      // _homeCubitFiltered.getHomeFilteredData();
      _homeCubitFilteredHistogram.getHomeHistogramData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _homeCubit,
        builder: (context, state) {
          if (state is GetHomeInit || state is GetInflasiPertumbuhanInit) {
            return SpinKitDoubleBounce(
              color: AppColor.primary,
              size: 75,
            );
          } else if (state is GetHomeFailure ||
              state is GetInflasiPertumbuhanFailure) {
            return Center(child: ErrorHandler(refresh: () async {
              _homeCubit.getInflasiPertumbuhan();
              await _homeCubit.getHomeDropdownData();
              // _homeCubit.valueKota == "0"
              //     ? _tabController.index = 1
              //     : _tabController.index = 0;
              // await _homeCubitFiltered.getHomeDropdownData();
              await _homeCubitFilteredHistogram.getHomeDropdownData();
              // _homeCubitFiltered.getHomeFilteredData();
              _homeCubitFilteredHistogram.getHomeHistogramData();
            }));
          } else {
            return Scaffold(
                body: SafeArea(
                    child: NestedScrollView(
                        scrollDirection: Axis.vertical,
                        headerSliverBuilder: (context,
                                innerBoxIsScrolled) =>
                            [
                              SliverToBoxAdapter(
                                child: Form(
                                  key: key,
                                  child: Column(children: [
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 32.w,
                                            vertical: 24.h),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Image.asset(Assets.imgLogoHome),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    Routes.suggestion);
                                              },
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      right: 8.w),
                                                  child: const Icon(Icons
                                                      .mail_outline_rounded)),
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
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              cardHome(
                                                  "INFLASI SULTRA ${GlobalMethodHelper.dateFormat(DateTime.now(), formatDate: "MMMM yyyy").toUpperCase()}",
                                                  _homeCubit.inflasiPertumbuhanData?.inflasi?.prosentase.toString() ??"-",
                                                  _homeCubit.inflasiPertumbuhanData?.inflasi?.inflasiPerubahan,_JenisCard.inflasi),
                                              SizedBox(width: 16.w),
                                              cardHome(
                                                  "PERTUMBUHAN EKONOMI SULTRA ${_homeCubit.valueTriwulan()}",
                                                  _homeCubit.inflasiPertumbuhanData?.pertumbuhanEkonomi?.prosentase.toString() ??"-",
                                                  _homeCubit.inflasiPertumbuhanData?.pertumbuhanEkonomi?.pertumbuhanEkonomiPerubahan,_JenisCard.pertumbuhan),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          dropdownMenu(context),
                                        ],
                                      ),
                                    ),
                                    _tabBar1Index()
                                  ]),
                                ),
                              ),
                            ],
                        // body: _homeCubit.valueKota == "0"?
                        // TabBarView(
                        //   controller: _tabController,
                        //   children: [
                        //     HomeTabsHistogramScreen(
                        //       bloc: _homeCubitFilteredHistogram,
                        //     )
                        //   ],
                        // )
                        // :TabBarView(
                        //   controller:_homeCubit.valueKota == "0"?null:_tabController,
                        //   children: [
                        //     if ( _homeCubit.valueKota != "0") 
                        //     HomeTabsMapScreen(
                        //       bloc: _homeCubitFiltered,
                        //     ),
                        //     HomeTabsHistogramScreen(
                        //       bloc: _homeCubitFilteredHistogram,
                        //     )
                        //   ],
                        // )

                        body:TabBarView(
                              controller: _tabController,
                              children: [
                                HomeTabsHistogramScreen(
                                  bloc: _homeCubitFilteredHistogram,
                                )
                              ],
                            )
                        )));
          }
        });
  }

  dropdownMenu(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("CEK INFORMASI HARGA PANGAN",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Komoditas",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    DropDown(
                        hint: "Pilih Komoditas",
                        items: _homeCubit.itemsKomoditas,
                        value: _homeCubit.valueKomoditas,
                        onChanged: (str) async {
                          await _homeCubit.getDropdownSubKomoditas(str);
                        }),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Sub Komoditas",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    DropDown(
                        hint: "Pilih Sub Komoditas",
                        items: _homeCubit.itemsSubKomoditas,
                        value: _homeCubit.itemsSubKomoditas.isNotEmpty
                            ? _homeCubit.valueSubKomoditas
                            : null,
                        onChanged: _homeCubit.itemsSubKomoditas.isEmpty
                            ? null
                            : (str) {
                                _homeCubit.valueSubKomoditas = str;
                                // _homeCubitFiltered.valueSubKomoditas = str;
                                _homeCubitFilteredHistogram.valueSubKomoditas =
                                    str;
                              }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded(
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text("Pilih Kota",
              //           style: TextStyle(
              //               fontSize: 12.sp,
              //               color: Colors.black,
              //               fontWeight: FontWeight.w500)),
              //       SizedBox(height: 8.h),
              //       DropDown(
              //           hint: "Pilih Kota",
              //           validate: _tabController.index == 1 ? false : true,
              //           value: _homeCubit.valueKota,
              //           items: _homeCubit.itemsKota,
              //           onChanged: (str) {
              //             _homeCubit.valueKota = str;
              //             _homeCubitFiltered.valueKota = str;
              //             _homeCubitFilteredHistogram.valueKota = str;
              //           }),
              //     ],
              //   ),
              // ),
              // SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggal",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: _homeCubit.dateValue??DateTime.now(),
                                firstDate: DateTime(DateTime.now().year - 1000),
                                lastDate: DateTime.now())
                            .then((value) {
                          setState(() {
                            _homeCubit.dateValue = value;
                            // _homeCubitFiltered.dateValue = value;
                            _homeCubitFilteredHistogram.dateValue = value;
                          });
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1,
                                color: _homeCubit.isDateEmpty
                                    ? AppColor.red
                                    : AppColor.primary),
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                                GlobalMethodHelper.dateFormat(
                                    _homeCubit.dateValue),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.w400)),
                            SvgPicture.asset(Assets.icCalendar),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jenis Informasi Harga",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    DropDown(
                        value: _homeCubit.valueInformasiHarga,
                        hint: "Pilih Informasi Harga",
                        items: _homeCubit.itemsInformasiHarga,
                        onChanged: (str) {
                          _homeCubit.valueInformasiHarga = str;
                          _homeCubitFilteredHistogram.valueInformasiHarga = str;
                        }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Jenis Pasar",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.h),
                    DropDown(
                        hint: "Pilih Jenis Pasar",
                        value: _homeCubit.valuePasar,
                        items: _homeCubit.itemsJenisPasar.reversed.toList(),
                        onChanged: (str) {
                          // _homeCubitFiltered.valuePasar = str;
                          _homeCubitFilteredHistogram.valuePasar = str;
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
                onPressed: () async {
                   
                  if (key.currentState!.validate() && !_homeCubit.isDateEmpty) {
                      // if (_homeCubit.valueKota != "0") {
                      //     if (_tabController.index == 0) {
                      //         setState(() {     
                      //           _tabController =TabController(length: 2, vsync: this);
                      //         });
                      //       } 
                      //     _tabController.addListener(() {
                      //       setState(() {});
                      //     });
                                    
                      //   } else{
                      //     setState(() {
                      //     _tabController =TabController(length: 1, vsync: this);  
                      //     });                    
                      //   }
                    // _homeCubitFiltered.getHomeFilteredData();
                    _homeCubitFilteredHistogram.getHomeHistogramData();


                    if (_homeCubit.valueInformasiHarga != "2") {
                      // non selected index
                      // _homeCubitFiltered.currentIndex = -1;
                      _homeCubitFilteredHistogram.currentIndex = -1;
                    } else {
                      // _homeCubitFiltered.currentIndex = 0;
                      _homeCubitFilteredHistogram.currentIndex = 0;
                    }
                  }
                },
                text: "Submit",
                hPadding: 40.w,
                vPadding: 13.h,
              )
            ],
          )
        ],
      ),
    );
  }

  // TabBar _tabBar2Index() {
  //   return TabBar(
  //     indicator: BoxDecoration(color: AppColor.primary),
  //     unselectedLabelColor: AppColor.primary,
  //     controller: _homeCubit.valueKota == "0"?null:_tabController,
  //     tabs: [
  //       if ( _homeCubit.valueKota != "0") 
  //       Tab(
  //           child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SvgPicture.asset(Assets.icMaps,
  //               color: _tabController.index == 1
  //                   ? AppColor.primary
  //                   : Colors.white),
  //           SizedBox(width: 8.w),
  //           Text(
  //             "Tampilan Peta",
  //             style: TextStyle(
  //                 fontSize: 12.sp,
  //                 color: _tabController.index == 1
  //                     ? AppColor.primary
  //                     : Colors.white,
  //                 fontWeight: FontWeight.w500),
  //           )
  //         ],
  //       )),
  //       Tab(
  //           child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           SvgPicture.asset(Assets.icChart,
  //               color: _tabController.index == 0
  //                   ? AppColor.primary
  //                   : Colors.white),
  //           SizedBox(width: 8.w),
  //           Text(
  //             "Tampilan Histogram",
  //             style: TextStyle(
  //                 fontSize: 12.sp,
  //                 color: _tabController.index == 0
  //                     ? AppColor.primary
  //                     : Colors.white,
  //                 fontWeight: FontWeight.w500),
  //           )
  //         ],
  //       )),
  //     ],
  //   );
  // }


  TabBar _tabBar1Index() {
    return TabBar(
      indicator: BoxDecoration(color: AppColor.primary),
      unselectedLabelColor: AppColor.primary,
      controller: _tabController,
      tabs: [
        Tab(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.icChart,
                color:  Colors.white),
            SizedBox(width: 8.w),
            Text(
              "Tampilan Histogram",
              style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            )
          ],
        )),
      ],
    );
  }

  Widget buttonTime(String time, Color bgColor, Color fontColor) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(8.r)),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        child: Text(time,
            style: TextStyle(
                fontSize: 12.sp,
                color: fontColor,
                fontWeight: FontWeight.w500)),
      ),
    );
  }

  Expanded cardHome(
      String label, String changes, Perubahan? data, _JenisCard jenis) {
    String? urlIcon = "";
    Color? colorStatus;
    switch (data?.status) {
      case "up":
        urlIcon = Assets.icArrowUp1;
        colorStatus =
            jenis == _JenisCard.inflasi ? AppColor.bgRed : AppColor.green;
        break;
      case "flat":
        urlIcon = Assets.icPause;
        colorStatus = const Color(0xFF297FBA);

        break;
      case "down":
        urlIcon = Assets.icArrowDown1;
        colorStatus =
            jenis == _JenisCard.inflasi ? AppColor.green : AppColor.bgRed;

        break;
      default:
        urlIcon = Assets.icPause;
        colorStatus = const Color(0xFF297FBA);
    }
    return Expanded(
        child: Column(
      children: [
        Container(
          width: 1.sw,
          height: 50.h,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          color: AppColor.primary,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        Container(
          width: 1.sw,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          color: Colors.white,
          child: Column(
            children: [
              Text("$changes%",
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                color: colorStatus,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      urlIcon,
                      width: 18.w,
                      height: 18.h,
                      fit: BoxFit.scaleDown,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      "${((data?.nilai ?? 0) < 0 ? (data?.nilai ?? 0) * -1 : data?.nilai ?? 0).toString()}%",
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
}

enum _JenisCard { inflasi, pertumbuhan }
