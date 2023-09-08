import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends HomeState {}

class GetHomeInit extends HomeState {}

class GetHomeSuccess extends HomeState {}

class GetHomeFailure extends HomeState {
  final String message;

  GetHomeFailure({required this.message});
}

class GetInflasiPertumbuhanInit extends HomeState {}

class GetInflasiPertumbuhamSuccess extends HomeState {}

class GetInflasiPertumbuhanFailure extends HomeState {
  final String message;

  GetInflasiPertumbuhanFailure({required this.message});
}

class GetHomeFilteredInit extends HomeState {}

class GetHomeFilteredSuccess extends HomeState {}

class GetHomeFilteredEmpty extends HomeState {}

class GetHomeFilteredFailure extends HomeState {
  final String message;

  GetHomeFilteredFailure({required this.message});
}

class GetHomeHistogramInit extends HomeState {}

class GetHomeHistogramSuccess extends HomeState {}

class GetHomeHistogramEmpty extends HomeState {}

class GetHomeHistogramFailure extends HomeState {
  final String message;

  GetHomeHistogramFailure({required this.message});
}

class GetSubKomoditasInit extends HomeState {}

class GetSubKomoditasSuccess extends HomeState {}

class GetSubKomoditasFailure extends HomeState {
  final String message;

  GetSubKomoditasFailure({required this.message});
}

class ChangeValueInit extends HomeState {}

class ChangeValueEnd extends HomeState {}
