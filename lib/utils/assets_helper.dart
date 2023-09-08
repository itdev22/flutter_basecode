class Assets {
  static String imgLogo = img("logo.png");
  static String imgOnboarding = img("img_onboarding.png");
  static String imgLogoHome = img("img_logo_home.png");
  static String imgBg = img("img_bg.png");
  static String imgTest = img("test.png");
  static String imgTestMap = img("img_testmap.png");

  static String icArrowLeft = icon("ic_arrow_left.svg");
  static String icNotif = icon("ic_notif.svg");
  static String icArrowDown = icon("ic_arrow_down.svg");
  static String icIncrease = icon("ic_increase.svg");
  static String icDecrease = icon("ic_decrease.svg");
  static String icMaps = icon("ic_maps.svg");
  static String icChart = icon("ic_chart.svg");
  static String icArrowDown1 = icon("ic_arrow_down_1.svg");
  static String icArrowUp1 = icon("ic_arrow_up_1.svg");
  static String ictest = icon("test.svg");
  static String ictest1 = icon("test1.svg");
  static String icLocation = icon("ic_location.svg");
  static String icDownload = icon("ic_download.svg");
  static String icCalendar = icon("ic_calendar.svg");
  static String icErrorHandler = icon("ic_error_handler.svg");
  static String icSplash = icon("ic_splash.svg");
  static String icPause = icon("ic_pause.svg");

  static String icon(String name) {
    return "assets/icons/$name";
  }

  static String img(String name) {
    return "assets/img/$name";
  }
}
