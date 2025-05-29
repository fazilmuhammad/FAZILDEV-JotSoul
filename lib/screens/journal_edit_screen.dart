import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jotsoul/helper/database_helper.dart';
import 'package:jotsoul/models/journal_entry.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry? entry;

  const JournalEditScreen({super.key, this.entry});

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _title = widget.entry?.title ?? 'My Tiny Joys Journal';
    _content = widget.entry?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: TextFormField(
          initialValue: _title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: (value) => _title = value,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: _content,
                  decoration: const InputDecoration(
                    hintText: 'Write something joyful...',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please write something.';
                    }
                    return null;
                  },
                  onSaved: (value) => _content = value!,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Journal',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final entry = JournalEntry(
        id: widget.entry?.id,
        title: _title.trim().isEmpty
            ? DateFormat('d MMM yyyy').format(DateTime.now())
            : _title.trim(),
        content: _content,
      );

      if (widget.entry == null) {
        await _dbHelper.create(entry);
      } else {
        await _dbHelper.update(entry);
      }

      if (!mounted) return;
      Navigator.pop(context, entry); // Pass the updated entry back
    }
  }
}
