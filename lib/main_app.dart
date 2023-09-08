import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app.dart';
import 'bloc/home/home_cubit.dart';
import 'bloc/main_app/main_app_cubit.dart';
import 'bloc/notification/notification_cubit.dart';
import 'bloc/suggestion/suggestion_cubit.dart';
import 'bloc/trade/trade_cubit.dart';
import 'utils/app_color.dart';
import 'utils/app_constant.dart';
import 'utils/app_route.dart';

class MainApp extends StatelessWidget {
  MainApp({Key? key}) : super(key: key);
  final MainAppCubit _mainAppCubit = MainAppCubit();
  final HomeCubit _homeCubit = HomeCubit();
  final TradeCubit _tradeCubit = TradeCubit();
  final SuggestionCubit _suggestionCubit = SuggestionCubit();
  final NotificationCubit _notificationCubit = NotificationCubit();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeCubit>(create: (context) => _homeCubit),
        BlocProvider<MainAppCubit>(create: (context) => _mainAppCubit),
        BlocProvider<TradeCubit>(create: (context) => _tradeCubit),
        BlocProvider<SuggestionCubit>(create: (context) => _suggestionCubit),
        BlocProvider<NotificationCubit>(
            create: (context) => _notificationCubit),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, widget) {
          return MaterialApp(
            title: App().appTitle!,
            debugShowCheckedModeBanner: false,
            color: AppColor.primary,
            theme: ThemeData(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: AppConstant.MAIN_FONT_NAME,
              colorScheme: ColorScheme.light(
                  primary: AppColor.primary, secondary: Colors.black),
            ),
            builder: (context, widget) {
              return MediaQuery(
                //Setting font does not change with system font size
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: widget!,
              );
            },
            onGenerateRoute: AppRoute.generateRoute,
            initialRoute: Routes.root,
          );
        },
      ),
    );
  }
}
