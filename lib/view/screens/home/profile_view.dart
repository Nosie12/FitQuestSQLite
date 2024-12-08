import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = 'Nosipho';
  String userLevel = 'Beginner';
  String? profileImagePath;

  final ImagePicker _picker = ImagePicker();

  // Function to edit name and level
  void _showEditDialog() {
    final TextEditingController nameController = TextEditingController(text: userName);
    final TextEditingController levelController = TextEditingController(text: userLevel);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: levelController,
                decoration: const InputDecoration(labelText: 'Level'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  userName = nameController.text;
                  userLevel = levelController.text;
                });
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Function to change profile picture
  Future<void> _changeProfilePicture() async {
    final ImageSource? source = await _showImageSourceDialog();

    if (source != null) {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          profileImagePath = pickedFile.path;
        });
      }
    } else {
      // Handle case when no source is selected
      print('No image source selected');
    }
  }

  // Show dialog to choose image source
  Future<ImageSource?> _showImageSourceDialog() async {
    return await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _showEditDialog, // Open edit dialog
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _changeProfilePicture,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage: profileImagePath != null
                    ? FileImage(File(profileImagePath!))
                    : const AssetImage('assets/images/background.png') as ImageProvider,
                child: profileImagePath == null
                    ? const Icon(Icons.camera_alt, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userLevel,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
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
