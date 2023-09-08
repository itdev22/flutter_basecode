import 'package:equatable/equatable.dart';

class TradeState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends TradeState {}

class GetTradeInit extends TradeState {}

class GetTradeSuccess extends TradeState {}

class GetTradeFailure extends TradeState {
  final String message;

  GetTradeFailure({required this.message});
}

class GetDetailTradeInit extends TradeState {}

class GetDetailTradeSuccess extends TradeState {}

class GetDetailTradeFailure extends TradeState {
  final String message;

  GetDetailTradeFailure({required this.message});
}
