import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../bloc/notification/notification_cubit.dart';
import '../../bloc/notification/notification_state.dart';
import '../../model/notification/notification_model.dart';
import '../../utils/app_color.dart';
import '../../utils/assets_helper.dart';
import '../../utils/core/global_method_helper.dart';
import '../../widget/error_handler.dart';
import '../../widget/no_data.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late NotificationCubit _notificationCubit;

  @override
  void initState() {
    super.initState();
    _notificationCubit = BlocProvider.of(context);

    _notificationCubit.getNotification();
    FirebaseMessaging.onMessage.listen((event) {
      _notificationCubit.getNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder(
            bloc: _notificationCubit,
            builder: (context, state) {
              if (state is GetNotificationFailure) {
                return Center(
                  child: ErrorHandler(refresh: () {
                    _notificationCubit.getNotification();
                  }),
                );
              }
              return SafeArea(
                  child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 32.w, vertical: 24.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Notifikasi",
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async{
                          return await _notificationCubit.getNotification();
                        },
                        child: _notificationCubit.dataNotif?.waktu?.isEmpty??true
                          ?const Center(child: NoData(text: "Belum ada notifikasi"))
                          :ListView.builder(
                            itemCount: _notificationCubit.dataNotif?.waktu?.length??0,
                            itemBuilder: (context, index) {
                              return listNotif(_notificationCubit.dataNotif?.waktu?.reversed.toList()[index]);
                      }),
                      ),
                    )
                  ],
                ),
              ));
            }));
  }

  Container listNotif(Waktu? data) {
    String time = "";
    String now =GlobalMethodHelper.dateFormat(DateTime.now());
    String yesterday =GlobalMethodHelper.dateFormat(DateTime.now().subtract(const Duration(days:1)));
    if (GlobalMethodHelper.dateFormat(DateTime.parse(data?.time??"")) == now) {
      time = "Hari Ini";
    } else if(GlobalMethodHelper.dateFormat(DateTime.parse(data?.time??"")) == yesterday) {
      time = "Kemarin";
    }else{
      time = GlobalMethodHelper.dateFormat(DateTime.parse(data?.time??""));
    }
    return Container(
      margin: EdgeInsets.only(top: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Text(time,
                style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 8.h),
          Divider(
            color: AppColor.grey,
            height: 1.h,
            thickness: 2,
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            itemCount: data?.pesan?.length??0,
            itemBuilder: (context,indexMessage) {
              return detailListNotif(data?.pesan?[indexMessage]);
            }
          )
        ],
      ),
    );
  }

  Padding detailListNotif(Pesan? data) {
    return Padding(
          padding: EdgeInsets.fromLTRB(11.w, 16.h, 32.w, 16.h),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Container(
              //   width: 10.w,
              //   height: 10.h,
              //   decoration: BoxDecoration(
              //       color: AppColor.primary, shape: BoxShape.circle),
              // ),
              SizedBox(width: 21.w),
              data?.condition != "DOWN"?SvgPicture.asset(Assets.icIncrease):SvgPicture.asset(Assets.icDecrease),
              SizedBox(width: 16.w),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data?.title??"",
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 4.h),
                  Text(
                      data?.description??"",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColor.textGrey,
                      )),
                ],
              )),
              SizedBox(width: 4.w),
              Text(
               data?.timenya??"",
                style: TextStyle(fontSize: 12.sp, color: AppColor.primary),
              )
            ],
          ),
        );
  }
}
