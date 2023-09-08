import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends NotificationState {}

class GetNotificationInit extends NotificationState {}

class GetNotificationSuccess extends NotificationState {}

class GetNotificationFailure extends NotificationState {
  final String message;

  GetNotificationFailure({required this.message});
}
