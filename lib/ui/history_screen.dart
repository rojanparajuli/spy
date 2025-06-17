import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spy/bloc/history/history_cubit.dart';
import 'package:spy/bloc/history/history_state.dart';
import 'package:flutter/services.dart'; // For clipboard functionality

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<void> _refreshHistory(BuildContext context) async {
    context.read<HistoryCubit>().fetchHistory();
  }

  Future<void> _copyToClipboard(String text, BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied "$text" to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Search History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            );
          } else if (state is HistoryLoaded) {
            if (state.history.isEmpty) {
              return RefreshIndicator(
                onRefresh: () => _refreshHistory(context),
                color: Colors.white,
                backgroundColor: Colors.black,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.history_rounded,
                            color: Colors.grey[600],
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No search history yet',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your searches will appear here',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => _refreshHistory(context),
              color: Colors.white,
              backgroundColor: Colors.grey[900],
              child: ListView.separated(
                padding: const EdgeInsets.only(top: 16),
                itemCount: state.history.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[800],
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final entry = state.history[index];
                  final userId = entry['userId'] ?? 'Unknown';
                  final timestamp =
                      entry['timestamp']?.toDate() ?? DateTime.now();

                  return InkWell(
                    onTap: () => _copyToClipboard(userId, context),
                    splashColor: Colors.white.withValues(alpha: 50),
                    highlightColor: Colors.white.withValues(alpha: 0.05),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline,
                                      color: Colors.white70,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        userId,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      color: Colors.white54,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${timestamp.day}/${timestamp.month}/${timestamp.year} '
                                      '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.content_copy,
                              color: Colors.white70,
                              size: 20,
                            ),
                            onPressed: () => _copyToClipboard(userId, context),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is HistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshHistory(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
