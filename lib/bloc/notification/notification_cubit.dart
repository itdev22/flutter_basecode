import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/api_return/api_return.dart';
import '../../model/notification/notification_model.dart';
import '../../services/notification_service.dart';
import '../../utils/app_constant.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationState());

  final _notificationService = NotificationService();

  NotificationModel? dataNotif;

  getNotification() async {
    emit(GetNotificationInit());
    ApiReturn<NotificationModel> result = await _notificationService.getNotification();
    if (result.status == AppConstant.API_STATUS_SUCCESS) {
      dataNotif = result.data;
      emit(GetNotificationSuccess());
    } else {
      emit(GetNotificationFailure(message: result.message));
    }
  }
}
