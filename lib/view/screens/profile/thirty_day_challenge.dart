import 'package:flutter/material.dart';

class ImproveRunningPage extends StatefulWidget {
  @override
  _ImproveRunningPageState createState() => _ImproveRunningPageState();
}

class _ImproveRunningPageState extends State<ImproveRunningPage> {
  final int trialDays = 7; // Days with real content in the trial
  final int totalDays = 30; // Total days in the trial period
  double? weight; // User's weight
  double? height; // User's height
  String initialPace = '';
  String initialDistance = '';

  void calculateSuggestions() {
    setState(() {
      if (weight != null && height != null) {
        double bmi = weight! / ((height! / 100) * (height! / 100));
        // Logic to calculate suggestions based on BMI
        if (bmi < 16.0) {
          // Very low BMI - children or underweight individuals
          initialPace = "8:00"; // min/km
          initialDistance = "1.5"; // km
        } else if (bmi < 18.5) {
          // Low BMI
          initialPace = "7:30"; // min/km
          initialDistance = "2"; // km
        } else if (bmi < 25.0) {
          // Normal BMI
          initialPace = "6:30"; // min/km
          initialDistance = "5"; // km
        } else if (bmi < 30.0) {
          // Overweight
          initialPace = "7:00"; // min/km
          initialDistance = "3"; // km
        } else {
          // Obese
          initialPace = "8:30"; // min/km
          initialDistance = "2"; // km
        }
      } else {
        initialPace = '';
        initialDistance = '';
      }
    });
  }

  String adjustPace(String pace, int day) {
    List<String> timeParts = pace.split(':');
    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]) + (day * 2); // Increment seconds by 2 each day
    if (seconds >= 60) {
      minutes += seconds ~/ 60;
      seconds = seconds % 60;
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String adjustDistance(String distance, int day) {
    double dist = double.parse(distance) + (day * 0.1); // Increment distance by 0.1 km each day
    return dist.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Improve Your Running'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your details to get personalized suggestions:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[850],
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                weight = double.tryParse(value);
              },
            ),
            SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[850],
                labelStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                height = double.tryParse(value);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateSuggestions,
              child: Text('Enter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF81A55D),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            if (initialPace.isNotEmpty && initialDistance.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Suggested Pace: $initialPace min/km',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  Text(
                    'Suggested Distance: $initialDistance km',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            SizedBox(height: 32),
            Expanded(
              child: ListView.builder(
                itemCount: totalDays,
                itemBuilder: (context, index) {
                  bool isLocked = index >= trialDays;
                  String pace = initialPace.isNotEmpty ? adjustPace(initialPace, index) : '';
                  String distance = initialDistance.isNotEmpty ? adjustDistance(initialDistance, index) : '';
                  return GestureDetector(
                    onTap: isLocked
                        ? null
                        : () {
                      Navigator.pushNamed(context, '/run');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isLocked ? Colors.grey : Colors.green,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Day ${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isLocked)
                              Icon(
                                Icons.lock,
                                color: Colors.grey,
                                size: 24,
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Pace: $pace min/km',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                  Text(
                                    'Distance: $distance km',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => ImproveRunningPage(),
      '/run': (context) => Scaffold(
        appBar: AppBar(
          title: Text('Run'),
        ),
        body: Center(
          child: Text(
            'Start your run!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    },
    theme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
  ));
}
