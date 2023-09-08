import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/main_app/main_app_cubit.dart';
import '../firebase_app.dart';
import '../utils/app_color.dart';
import 'home/home_screen.dart';
import 'notification/notification_screen.dart';
import 'trading/trading_screen.dart';

class MainScreen extends StatefulWidget {
  final int index;
  const MainScreen({Key? key, this.index = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainAppCubit _mainAppCubit = MainAppCubit();

  @override
  void initState() {
    super.initState();
    _mainAppCubit.selectedIndex = widget.index;
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      await FirebaseApp().initFirebase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _mainAppCubit,
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(
              index: _mainAppCubit.selectedIndex,
              children: const [
                HomeScreen(),
                TradingScreen(),
                NotificationScreen()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_home.svg',
                    color: _mainAppCubit.selectedIndex == 0
                        ? AppColor.primary
                        : AppColor.textGrey,
                  ),
                  label: "Beranda",
                ),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_trading.svg',
                      color: _mainAppCubit.selectedIndex == 1
                          ? AppColor.primary
                          : AppColor.textGrey,
                    ),
                    label: "Kolom Harga"),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      'assets/icons/ic_notification.svg',
                      color: _mainAppCubit.selectedIndex == 2
                          ? AppColor.primary
                          : AppColor.textGrey,
                    ),
                    label: "Notifikasi")
              ],
              currentIndex: _mainAppCubit.selectedIndex,
              onTap: (index) {
                _mainAppCubit.changePage(index);
              },
              selectedItemColor: AppColor.primary,
              unselectedLabelStyle: TextStyle(color: AppColor.textGrey),
              unselectedItemColor: AppColor.textGrey,
              showUnselectedLabels: true,
            ),
          );
        });
  }
}
