import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/data/data_bloc.dart';
import '../../bloc/data/data_state.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          return ListView.builder(
            itemCount: state.contacts.length,
            itemBuilder: (_, index) {
              final contact = state.contacts[index];
              return ListTile(
                title: Text(contact['name'] ?? 'Unknown'),
                subtitle: Text(contact['phone'] ?? ''),
              );
            },
          );
        } else if (state is DataError) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const Center(child: Text("Search for a user to view contacts."));
        }
      },
    );
  }
}
