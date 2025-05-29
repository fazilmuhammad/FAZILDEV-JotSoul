import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flip_card/flip_card.dart';
import '../models/journal_entry.dart';

class JournalReadScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalReadScreen({Key? key, required this.entry}) : super(key: key);

  @override
  _JournalReadScreenState createState() => _JournalReadScreenState();
}

class _JournalReadScreenState extends State<JournalReadScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  bool _isFullscreen = false;

  List<Widget> get _pages => [
        _buildContentPage(widget.entry.content, true),
        _buildContentPage(widget.entry.content, false),
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullscreen
          ? null
          : AppBar(
              title: Text(
                'Journal Entry',
                style: GoogleFonts.notoSerif(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            ),
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isFullscreen
                ? _buildVerticalNotebookView()
                : _buildBookPageView(),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              tooltip: _isFullscreen ? 'Read like a book' : 'Read vertically',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: () => setState(() => _isFullscreen = !_isFullscreen),
              child: Icon(_isFullscreen ? Icons.book : Icons.view_agenda),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isFullscreen
          ? null
          : BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (_currentPage > 0) {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBookPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) {
        return Center(child: _pages[index]);
      },
    );
  }

  Widget _buildVerticalNotebookView() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: _pages
            .map((page) => Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: page,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildContentPage(String content, bool isFront) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("🌞 Today I :", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            widget.entry.content,
            style: GoogleFonts.notoSerif(fontSize: 18, height: 1.6),
          ),
          const SizedBox(height: 24),
          Text("💛 One thing I liked today:", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          Text(
            "Placeholder content for this section.",
            style: GoogleFonts.notoSerif(fontSize: 18, height: 1.6),
          ),
        ],
      ),
    );
  }
}
