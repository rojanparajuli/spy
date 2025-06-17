import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/history/history_state.dart';
import 'package:spy/repository/history_repository.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRepository repository;

  HistoryCubit(this.repository) : super(HistoryInitial());

  void fetchHistory() {
    emit(HistoryLoading());
    try {
      repository.getUserHistory().listen((historyList) {
        emit(HistoryLoaded(historyList));
      });
    } catch (e) {
      emit(HistoryError('Failed to load history'));
    }
  }
}
