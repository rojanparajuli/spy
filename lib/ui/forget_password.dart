import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/forget_password/forget_password_bloc.dart';
import 'package:spy/bloc/forget_password/forget_password_event.dart';
import 'package:spy/bloc/forget_password/forget_password_state.dart';


class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password", 
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new , color: Colors.white),
        onPressed: () => Navigator.pop(context)
      ),
      backgroundColor: Colors.black,
      ),
      body: BlocConsumer<ForgetPasswordBloc, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Reset link sent. Check your email."),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ForgetPasswordFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/Rojan.png", height: 150, width: 150),
                Text(
                  "Enter your email to receive a password reset link.",
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: isDark
                    ? Colors.grey[800]!.withValues(alpha: 0.5)
                    : Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.1,
                    ),
                  ),
                  onPressed: state is ForgetPasswordLoading
                    ? null
                    : () {
                      final email = emailController.text.trim();
                      if (email.isNotEmpty) {
                        context
                          .read<ForgetPasswordBloc>()
                          .add(ForgetPasswordSubmitted(email: email));
                      }
                      },
                  child: state is ForgetPasswordLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send Reset Link"),
                  ),
                ),
                ]
              
            ),
          );
        },
      ),
    );
  }
}
