import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:jotsoul/helper/database_helper.dart';
import 'package:jotsoul/models/journal_entry.dart';
import 'package:jotsoul/screens/journal_edit_screen.dart';
import 'package:jotsoul/screens/journal_read_screen.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  late Future<List<JournalEntry>> _entriesFuture;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _refreshEntries();
  }

  Future<void> _refreshEntries() async {
    setState(() {
      _entriesFuture = _dbHelper.readAll();
    });
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Today';
    }
    return DateFormat('d MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7E7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [Image.asset('assets/images/logo.png', height: 28)],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () async {
              final allEntries = await _dbHelper.readAll();
              showSearch(
                context: context,
                delegate: JournalSearchDelegate(allEntries),
              );
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data!;

          if (entries.isEmpty) {
            return const Center(
              child: Text(
                'No journal entries yet.\nTap the + button to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Recently Edited",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: entries.length >= 4 ? 4 : entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JournalReadScreen(entry: entry),
                          ),
                        );
                      },
                      child: Container(
                        width: 170,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              child: Image.asset(
                                'assets/book_cover/book_cover_${index % 3}.png',
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              entry.title.length > 12
                                  ? '${entry.title.substring(0, 12)}...'
                                  : entry.title,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  color: const Color(0xFFFFFEFC),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        final formattedDate = _formatDate(entry.date);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JournalReadScreen(entry: entry),
                                  ),
                                );
                              },
                              leading: Image.asset(
                                'assets/book_cover/book_cover_${index % 3}.png',
                                height: 70,
                              ),
                              title: Text(
                                entry.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    '${entry.wordCount} Words',
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1F4C5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _navigateToEditScreen(context, entry);
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _deleteEntry(entry);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditScreen(context, null),
        backgroundColor: const Color(0xFFFFC107),
        child: const Icon(Icons.add, color: Colors.white),
        elevation: 0.0,
      ),
    );
  }

  void _navigateToEditScreen(BuildContext context, JournalEntry? entry) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JournalEditScreen(entry: entry)),
    );
    _refreshEntries();
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    await _dbHelper.delete(entry.id);
    _refreshEntries();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Entry deleted')));
  }
}

// --- SearchDelegate Implementation ---

class JournalSearchDelegate extends SearchDelegate {
  final List<JournalEntry> entries;

  JournalSearchDelegate(this.entries);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final suggestions = entries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          entry.content.toLowerCase().contains(query.toLowerCase()) ||
          DateFormat(
            'd MMM yyyy',
          ).format(entry.date).toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSuggestionList(context, suggestions);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = entries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          entry.content.toLowerCase().contains(query.toLowerCase()) ||
          DateFormat(
            'd MMM yyyy',
          ).format(entry.date).toLowerCase().contains(query.toLowerCase());
    }).toList();

    return _buildSuggestionList(context, suggestions);
  }

  Widget _buildSuggestionList(BuildContext context, List<JournalEntry> list) {
    return Container(
      color: const Color(0xFFFFFEFC),
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final entry = list[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: ListTile(
                  leading: Image.asset(
                    'assets/book_cover/book_cover_${index % 3}.png',
                    height: 70,
                  ),
                  title: Text(entry.title),
                  subtitle: Text(
                    '${entry.wordCount} Words • ${DateFormat('d MMM yyyy').format(entry.date)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  onTap: () {
                    close(context, null);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalReadScreen(entry: entry),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
