import 'package:equatable/equatable.dart';

class MainAppState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends MainAppState {}

class GetMainAppInit extends MainAppState {}

class GeteMainAppSuccess extends MainAppState {}

class GetMainAppEmpty extends MainAppState {}

class GetMainAppFailure extends MainAppState {
  final String message;

  GetMainAppFailure({required this.message});
}
