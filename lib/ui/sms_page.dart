import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/data/data_bloc.dart';
import '../../bloc/data/data_state.dart';

class SmsPage extends StatelessWidget {
  const SmsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        if (state is DataLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DataLoaded) {
          return ListView.builder(
            itemCount: state.sms.length,
            itemBuilder: (_, index) {
              final sms = state.sms[index];
              return ListTile(
                title: Text(sms['sender'] ?? 'Unknown'),
                subtitle: Text("${sms['message'] ?? ''}\n${sms['timestamp'] ?? ''}"),
              );
            },
          );
        } else if (state is DataError) {
          return Center(child: Text("Error: ${state.message}"));
        } else {
          return const Center(child: Text("Search for a user to view SMS."));
        }
      },
    );
  }
}
