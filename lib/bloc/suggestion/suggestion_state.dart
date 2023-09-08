import 'package:equatable/equatable.dart';

class SuggestionState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class InitialState extends SuggestionState {}

class GetSuggestionInit extends SuggestionState {}

class GetSuggestionSuccess extends SuggestionState {}

class GetSuggestionFailure extends SuggestionState {
  final String message;

  GetSuggestionFailure({required this.message});
}
