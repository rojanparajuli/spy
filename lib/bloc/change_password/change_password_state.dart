class ChangePasswordState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;
  final List<bool> passwordVisibility;

  ChangePasswordState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
    List<bool>? passwordVisibility,
  }) : passwordVisibility = passwordVisibility ?? [true, true, true];

  ChangePasswordState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
    List<bool>? passwordVisibility,
  }) {
    return ChangePasswordState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
      passwordVisibility: passwordVisibility ?? this.passwordVisibility,
    );
  }
}
