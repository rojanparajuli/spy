import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spy/bloc/contact_sms/contact_sms_event/contact_sms/contact_sms_bloc.dart';
import 'package:spy/bloc/contact_sms/contact_sms_event/contact_sms/contact_sms_event.dart';
import 'package:spy/bloc/data/data_bloc.dart';
import 'package:spy/bloc/forget_password/forget_password_bloc.dart';
import 'package:spy/bloc/google/google_login_bloc.dart';
import 'package:spy/bloc/login/login_bloc.dart';
import 'package:spy/bloc/signup/signup_bloc.dart';
import 'package:spy/bloc/user/user_bloc.dart';
import 'package:spy/bloc/user/user_event.dart';
import 'package:spy/repository/auth_repository.dart';
import 'package:spy/ui/home.dart';
import 'package:spy/ui/login.dart';
import 'package:spy/ui/signup_screen.dart';

Future<void> requestAllPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    // Permission.location,
    Permission.sms,
    Permission.contacts,
    Permission.phone,
  ].request();

  statuses.forEach((permission, status) {
    if (!status.isGranted) {
      print('$permission not granted');
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await requestAllPermissions();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginBloc(AuthRepository(), GoogleLogin())),
        BlocProvider(create: (_) => SignupBloc(AuthRepository())),
        BlocProvider(
          create: (_) {
            final currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser?.uid;
            return UserBloc(FirebaseFirestore.instance)
              ..add(LoadUserProfile(uid!));
          },
        ),
        BlocProvider(create: (_) => ForgetPasswordBloc()),
        BlocProvider<ContactSmsBloc>(
          create: (_) {
            final currentUser = FirebaseAuth.instance.currentUser;
            final uid = currentUser?.uid;
            return ContactSmsBloc()..add(LoadContactAndSms(uid!));
          },
        ),
        BlocProvider(create: (_) => DataBloc(FirebaseFirestore.instance)),
        BlocProvider(create: (_) => SignupToggleCubit()),
        BlocProvider(create: (_) => LoginToggleCubit()),
        BlocProvider(create: (_) => ProfileEditToggle()),
        BlocProvider(create: (_) => GenderCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const OnBoard(),
      ),
    );
  }
}

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
            return HomeScreen();
          }
        }
        return LoginScreen();
      },
    );
  }
}
