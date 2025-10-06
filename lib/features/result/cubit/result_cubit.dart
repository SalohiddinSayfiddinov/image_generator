import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_generator/data/mockapi.dart';

part 'result_state.dart';

class ResultCubit extends Cubit<ResultState> {
  final Mockapi api;

  ResultCubit(this.api) : super(ResultInit());

  Future<void> generate(String prompt) async {
    emit(ResultLoading());
    try {
      final imageUrl = await api.generateImage(prompt);
      emit(ResultSuccess(imageUrl));
    } catch (_) {
      emit(ResultError());
    }
  }
}
