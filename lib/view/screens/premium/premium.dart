import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Run Tracker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> pages = [
      {'title': 'Premium', 'page': const PremiumPage()},
      {'title': 'Theme', 'page': const ThemePage()},
      {'title': '30 Days Challenge', 'page': const DaysPage()},
      {'title': 'History', 'page': const HistoryPage()},
      {'title': 'Share', 'page': const SharePage()},
      {'title': 'Rate Us', 'page': const RatePage()},
      {'title': 'About Us', 'page': const AboutPage()},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Tracker App'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: pages.length,
        itemBuilder: (context, index) => Card(
          child: ListTile(
            title: Text(pages[index]['title']),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pages[index]['page']),
              );
            },
          ),
        ),
      ),
    );
  }
}

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Choose Your Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildPlanCard(
              title: 'Monthly',
              price: '\$9.99',
              features: ['All premium features', 'Monthly billing'],
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildPlanCard(
              title: 'Yearly',
              price: '\$99.99',
              features: ['All premium features', 'Save 17%', 'Yearly billing'],
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required List<String> features,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 20)),
              Text(price, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...features.map((feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(feature),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});
  @override
  Widget build(BuildContext context) {
    final themes = [
      {'name': 'Dark', 'color': Colors.black87},
      {'name': 'Green', 'color': Colors.green},
      {'name': 'Blue', 'color': Colors.blue},
      {'name': 'Purple', 'color': Colors.purple},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: themes.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              color: themes[index]['color'] as Color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                themes[index]['name'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DaysPage extends StatelessWidget {
  const DaysPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('30 Days Challenge')),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: 30,
        itemBuilder: (context, index) {
          final day = index + 1;
          final isCompleted = day < 15; // Example completion status
          return Container(
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  color: isCompleted ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});
  @override
  Widget build(BuildContext context) {
    final activities = [
      {'date': '2024-03-06', 'activity': 'Completed Day 14', 'duration': '25 min'},
      {'date': '2024-03-05', 'activity': 'Completed Day 13', 'duration': '30 min'},
      {'date': '2024-03-04', 'activity': 'Completed Day 12', 'duration': '20 min'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(activities[index]['activity']!),
          subtitle: Text(activities[index]['date']!),
          trailing: Text(activities[index]['duration']!),
          leading: const CircleAvatar(
            child: Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}

class SharePage extends StatelessWidget {
  const SharePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Share with Friends')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Share Your Progress',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareButton(Icons.facebook, 'Facebook', Colors.blue),
                _buildShareButton(Icons.link, 'Copy Link', Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: color,
          iconSize: 40,
          onPressed: () {},
        ),
        Text(label),
      ],
    );
  }
}

class RatePage extends StatelessWidget {
  const RatePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Us')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'How would you rate your experience?',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (index) => IconButton(
                  icon: const Icon(Icons.star_border),
                  iconSize: 40,
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Submit Rating'),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us')),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Our App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Our app helps you build healthy habits through 30-day challenges. '
                  'Track your progress, stay motivated, and achieve your goals.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('Contact Us'),
              subtitle: Text('support@example.com'),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
            ),
            ListTile(
              leading: Icon(Icons.description),
              title: Text('Terms of Service'),
            ),
          ],
        ),
      ),
    );
  }
}
