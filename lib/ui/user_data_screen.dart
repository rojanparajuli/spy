import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataScreen extends StatelessWidget {
  final String userId;

  const UserDataScreen({super.key, required this.userId});

  Future<List<Map<String, dynamic>>> _fetchContacts() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('contacts')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Map<String, dynamic>>> _fetchSms() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('sms')
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    // int selectedIndex = 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("User Data: $userId"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Contacts"),
              Tab(text: "SMS"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contacts Tab
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No contacts found."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final contact = snapshot.data![index];
                    return ListTile(
                      title: Text(contact['name'] ?? 'No Name'),
                      subtitle: Text(contact['number'] ?? 'No Number'),
                    );
                  },
                );
              },
            ),

            // SMS Tab
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchSms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No SMS found."));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final sms = snapshot.data![index];
                    return ListTile(
                      title: Text(sms['address'] ?? 'Unknown'),
                      subtitle: Text(sms['body'] ?? 'No Message'),
                      trailing: Text(
                        DateTime.fromMillisecondsSinceEpoch(sms['timestamp'] ?? 0)
                            .toString(),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
