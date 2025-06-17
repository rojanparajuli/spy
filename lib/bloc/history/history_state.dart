// cubit/history_state.dart

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<Map<String, dynamic>> history;

  HistoryLoaded(this.history);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
