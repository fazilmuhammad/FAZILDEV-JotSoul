import 'package:flutter/material.dart';
import 'package:jotsoul/models/journal_entry.dart';
import 'package:jotsoul/screens/journal_edit_screen.dart';

class JournalReadScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalReadScreen({super.key, required this.entry});

  @override
  State<JournalReadScreen> createState() => _JournalReadScreenState();
}

class _JournalReadScreenState extends State<JournalReadScreen> {
  late JournalEntry entry;
  late List<String> _pages;

  @override
  void initState() {
    super.initState();
    entry = widget.entry; // mutable copy
    _pages = _splitContent(entry.content, 1000);
  }

  List<String> _splitContent(String content, int maxLength) {
    List<String> chunks = [];
    for (int i = 0; i < content.length; i += maxLength) {
      chunks.add(content.substring(i, i + maxLength > content.length ? content.length : i + maxLength));
    }
    return chunks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f7f1),
      appBar: AppBar(
        backgroundColor: const Color(0xfff6f7f1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          entry.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.edit, color: Colors.black),
          //   onPressed: () async {
          //     final updated = await Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) => JournalEditScreen(entry: entry),
          //       ),
          //     );

          //     if (updated != null && mounted) {
          //       setState(() {
          //         entry = updated;
          //         _pages = _splitContent(updated.content, 1000);
          //       });
          //     }
          //   },
          // ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _pages.length,
        itemBuilder: (context, index) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 12,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Text(
              _pages[index],
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
          );
        },
      ),
    );
  }
}
