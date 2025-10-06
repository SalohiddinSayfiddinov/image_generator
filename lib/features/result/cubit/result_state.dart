part of 'result_cubit.dart';

abstract class ResultState {}

class ResultInit extends ResultState {}

class ResultLoading extends ResultState {}

class ResultSuccess extends ResultState {
  final String imageUrl;
  ResultSuccess(this.imageUrl);
}

class ResultError extends ResultState {}
