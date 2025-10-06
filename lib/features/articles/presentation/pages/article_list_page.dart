import 'package:flutter/material.dart';

class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.article,
              size: 100,
              color: Color(0xFF2E7D32),
            ),
            SizedBox(height: 16),
            Text(
              'Halaman Artikel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Fitur ini akan segera hadir',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF757575),
              ),
            ),
          ],
        ),
      ),
    );
  }
}