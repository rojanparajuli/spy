import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spy/model/user_model.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final FirebaseFirestore firestore;

  late AppUser _currentUser;

  UserBloc(this.firestore) : super(UserInitial()) {
    on<LoadUserProfile>(_onLoadUser);
    on<UpdateUserProfile>(_onUpdateUser);
  }

  Future<void> _onLoadUser(LoadUserProfile event, Emitter<UserState> emit) async {
  emit(UserLoading());
  try {
    final doc = await firestore.collection('users').doc(event.uid).get();

    if (!doc.exists || doc.data() == null) {
      emit(const UserError('User data not found in Firestore.'));
      return;
    }

    final user = AppUser.fromMap(doc.data()!);
    _currentUser = user;
    emit(UserLoaded(user));
  } catch (e) {
    emit(UserError('Failed to load user: $e'));
  }
}

  Future<void> _onUpdateUser(UpdateUserProfile event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      await firestore.collection('users').doc(_currentUser.uid).update({
        'name': event.name,
        'gender': event.gender,
      });

      _currentUser = AppUser(
        uid: _currentUser.uid,
        email: _currentUser.email,
        phone: _currentUser.phone,
        name: event.name,
        gender: event.gender,
      );

      emit(UserLoaded(_currentUser));
    } catch (e) {
      emit(UserError('Failed to update user: $e'));
    }
  }
}
