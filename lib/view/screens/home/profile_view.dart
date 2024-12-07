import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  Widget _buildMenuCard(BuildContext context, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.3),
              Colors.teal.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B3B2D),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage: AssetImage('assets/profile_placeholder.png'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nosipho',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Beginner',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/premium');
              },
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.3),
                      Colors.green.withOpacity(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B3B2D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text(
                      'GO Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildMenuCard(context, 'Theme', () {
                    Navigator.pushNamed(context, '/theme');
                  }),
                  _buildMenuCard(context, '30 Days Challenge', () {
                    Navigator.pushNamed(context, '/challenge');
                  }),
                  _buildMenuCard(context, 'History', () {
                    Navigator.pushNamed(context, '/history');
                  }),
                  _buildMenuCard(context, 'Share with Friends', () {
                    Navigator.pushNamed(context, '/share');
                  }),
                  _buildMenuCard(context, 'Rate Us', () {
                    Navigator.pushNamed(context, '/rate');
                  }),
                  _buildMenuCard(context, 'About Us', () {
                    Navigator.pushNamed(context, '/about');
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
