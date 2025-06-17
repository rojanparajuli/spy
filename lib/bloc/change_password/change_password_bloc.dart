import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/repository/change_password_repository.dart';
import 'change_password_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository authRepository;

  ChangePasswordBloc(this.authRepository) : super(ChangePasswordState()) {
    on<SubmitPasswordChange>(_onSubmit);
    on<TogglePasswordVisibility>(_onToggle);
  }

  void _onToggle(
    TogglePasswordVisibility event,
    Emitter<ChangePasswordState> emit,
  ) {
    final updated = List<bool>.from(state.passwordVisibility);
    updated[event.fieldIndex] = !updated[event.fieldIndex];
    emit(state.copyWith(passwordVisibility: updated));
  }

  Future<void> _onSubmit(
    SubmitPasswordChange event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));

    if (event.newPassword != event.confirmPassword) {
      emit(
        state.copyWith(isLoading: false, error: "New passwords do not match"),
      );
      return;
    }

    try {
      await authRepository.changePassword(
        event.currentPassword,
        event.newPassword,
      );
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
