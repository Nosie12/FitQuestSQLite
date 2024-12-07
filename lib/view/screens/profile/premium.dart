import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  Widget _buildMenuCard(BuildContext context, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.amber.withOpacity(0.3),
              Colors.orange.withOpacity(0.2),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
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
          'Premium Subscriptions',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Unlock the best features with our premium plans!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.4,
                children: [
                  _buildMenuCard(
                    context,
                    'Monthly Plan',
                    'Access all premium features for 30 days.',
                        () {
                      Navigator.pushNamed(context, '/monthlyPlan');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Annual Plan',
                    'Save more with a full year subscription.',
                        () {
                      Navigator.pushNamed(context, '/annualPlan');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Exclusive Content',
                    'Access exclusive workouts and insights.',
                        () {
                      // Navigate to Exclusive Content Details
                      Navigator.pushNamed(context, '/exclusiveContent');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Priority Support',
                    'Get assistance faster with priority support.',
                        () {
                      Navigator.pushNamed(context, '/prioritySupport');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Ad-Free Experience',
                    'Enjoy the app without interruptions.',
                        () {
                      Navigator.pushNamed(context, '/adFree');
                    },
                  ),
                  _buildMenuCard(
                    context,
                    'Custom Plans',
                    'Tailor plans to fit your specific needs.',
                        () {
                      // Navigate to Custom Plans Details
                      Navigator.pushNamed(context, '/customPlans');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}