import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
    
    return snapshot.docs.map((doc) {
      final data = doc.data();
      if (data['timestamp'] is String) {
        data['timestamp'] = int.tryParse(data['timestamp']) ?? 0;
      }
      return data;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text("User Data: $userId", style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[850],
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[400],
            tabs: const [
              Tab(icon: Icon(Icons.contacts), text: "Contacts"),
              Tab(icon: Icon(Icons.sms), text: "Messages"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchContacts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No contacts found.", style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.grey, height: 1),
                  itemBuilder: (context, index) {
                    final contact = snapshot.data![index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.blueGrey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(
                        contact['name']?.toString() ?? 'No Name',
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      subtitle: Text(
                        contact['phone']?.toString() ?? 'No Number',
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: Icon(Icons.chevron_right, color: Colors.grey[600]),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      onTap: () {},
                    );
                  },
                );
              },
            ),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchSms(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text("No messages found.", style: TextStyle(color: Colors.white70)),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final sms = snapshot.data![index];
                    final timestamp = sms['timestamp'] is int 
                        ? sms['timestamp'] as int 
                        : int.tryParse(sms['timestamp']?.toString() ?? '0') ?? 0;
                    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
                    final formattedDate = DateFormat('MMM dd, yyyy').format(dateTime);
                    final formattedTime = DateFormat('hh:mm a').format(dateTime);
                    final isIncoming = sms['type']?.toString().toLowerCase() == 'received';

                    return Container(
                      decoration: BoxDecoration(
                        color: isIncoming ? Colors.grey[800] : Colors.blueGrey[900],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: isIncoming 
                            ? CrossAxisAlignment.start 
                            : CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: isIncoming 
                                ? MainAxisAlignment.start 
                                : MainAxisAlignment.end,
                            children: [
                              if (isIncoming)
                                const Icon(Icons.arrow_downward, size: 16, color: Colors.green),
                              if (!isIncoming)
                                const Icon(Icons.arrow_upward, size: 16, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text(
                                sms['address']?.toString() ?? 'Unknown',
                                style: TextStyle(
                                  color: isIncoming ? Colors.white : Colors.blue[200],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            sms['body']?.toString() ?? 'No Message',
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$formattedDate at $formattedTime',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                            ),
                          ),
                        ],
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