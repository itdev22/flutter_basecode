import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/link.dart';

import '../../bloc/suggestion/suggestion_cubit.dart';
import '../../bloc/suggestion/suggestion_state.dart';
import '../../utils/app_color.dart';
import '../../utils/app_constant.dart';
import '../../utils/assets_helper.dart';
import '../../widget/button.dart';
import '../../widget/dropdown.dart';
import '../../widget/error_handler.dart';
import '../../widget/input.dart';

class SuggestionScreen extends StatefulWidget {
  const SuggestionScreen({Key? key}) : super(key: key);

  @override
  State<SuggestionScreen> createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  final _key = GlobalKey<FormState>();
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerCritism = TextEditingController();
  TextEditingController controllerSuggestion = TextEditingController();

  late SuggestionCubit _suggestionCubit;
  
  @override
  void initState() {
    super.initState();
    _suggestionCubit = BlocProvider.of(context);
    _suggestionCubit.getTradeDropdownData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _suggestionCubit,
        builder: (context, state) {
          if (state is GetSuggestionInit) {
            return Scaffold(
              body: SpinKitDoubleBounce(
                color: AppColor.primary,
                size: 75,
              ),
            );
          } else if (state is GetSuggestionFailure) {
            return Scaffold(body: SingleChildScrollView(
              child: Center(child: ErrorHandler(
                refresh: () async {
                  await _suggestionCubit.getTradeDropdownData();
                },
              )),
            ));
          } else {
            return Scaffold(
                backgroundColor: Colors.white,
                body: SafeArea(
                  child: Form(
                  key: _key,
                  child: Container(
                    height: 1.sh,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 24.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: SvgPicture.asset(Assets.icArrowLeft)),
                                Text(
                                  "Kritik & Saran",
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  width: 48,
                                )
                              ],
                            )),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Column(
                                children: [
                                  Input(
                                    maxLines: 1,
                                    controller: controllerName,
                                    hint: "Nama",
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  DropDown(
                                      fontSize: 15.sp,
                                      hintColor: AppColor.textGrey,
                                      fontColor: Colors.black,
                                      hint: "Kota",
                                      items: _suggestionCubit.itemsKota,
                                      onChanged: (str) {
                                        _suggestionCubit.valueKota = str;
                                      }),
                                  SizedBox(height: 16.h),
                                  Input(
                                    maxLines: 4,
                                    controller: controllerCritism,
                                    hint: "Kritik",
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 16.h),
                                  Input(
                                    maxLines: 4,
                                    controller: controllerSuggestion,
                                    hint: "Saran",
                                    validator: (value) {
                                      if (value?.isEmpty ?? true) {
                                        return "";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 24.h),
                                  Button(
                                    onPressed: () {
                                      if (_key.currentState!.validate()) {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r)),
                                                alignment: Alignment.center,
                                                child: SingleChildScrollView(
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 24.w,
                                                        vertical: 32.h),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            "Apakah data yang anda masukkan sudah benar?",
                                                            textAlign:
                                                                TextAlign.center,
                                                            style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color: Colors.black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                        SizedBox(height: 16.h),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Button(
                                                                vPadding: 8.h,
                                                                onPressed:() async {
                                                                  Navigator.pop(context);
                                                                  await _suggestionCubit.sendSuggestion(kritik:controllerCritism.text,nama:controllerName.text,saran:controllerSuggestion.text);
                          
                                                                  controllerName.clear();
                                                                  controllerCritism.clear();
                                                                  controllerSuggestion.clear();
                                                                },
                                                                text: "Kirim"),
                                                            Button(
                                                              vPadding: 8.h,
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                              text: "Batalkan",
                                                              style: AppButtonStyle
                                                                  .red,
                                                            )
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    text: "Kirim Kritik & Saran",
                                  ),
                                  SizedBox(height: 48.h,),
                                  Column(
                                    children: [
                                      const Text("Version ${AppConstant.APP_VERSION}"),
                                      const Text("© Lapalapa Apps. All rights reserved."),
                                      Link(
                                        uri: Uri.parse('https://markashosting.com'),
                                        builder: (context,followLink) {
                                          return RichText(text: TextSpan(text: "Developed by ",style: const TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: "Markas Hosting.",
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                              recognizer: TapGestureRecognizer()..onTap = followLink) 
                                          ]));
                                        }
                                      )
                          
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
