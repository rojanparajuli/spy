import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/change_password/change_password_bloc.dart';
import 'package:spy/bloc/change_password/change_password_event.dart';
import 'package:spy/bloc/change_password/change_password_state.dart';
import 'package:spy/ui/forget_password.dart';

class ChangePasswordScreen extends StatelessWidget {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
      listener: (context, state) {
        if (state.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text(
              'Change Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            backgroundColor: Colors.black,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _currentController,
                  label: 'Current Password',
                  isVisible: state.passwordVisibility[0],
                  onToggle: () => context.read<ChangePasswordBloc>().add(
                    TogglePasswordVisibility(0),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _newController,
                  label: 'New Password',
                  isVisible: state.passwordVisibility[1],
                  onToggle: () => context.read<ChangePasswordBloc>().add(
                    TogglePasswordVisibility(1),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  controller: _confirmController,
                  label: 'Confirm Password',
                  isVisible: state.passwordVisibility[2],
                  onToggle: () => context.read<ChangePasswordBloc>().add(
                    TogglePasswordVisibility(2),
                  ),
                ),
                const SizedBox(height: 32),
                state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          context.read<ChangePasswordBloc>().add(
                            SubmitPasswordChange(
                              _currentController.text,
                              _newController.text,
                              _confirmController.text,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'CHANGE PASSWORD',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                const SizedBox(height: 15),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Forgot Password? ',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'Reset',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgetPasswordScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
      ),
      cursorColor: Colors.white,
    );
  }
}
