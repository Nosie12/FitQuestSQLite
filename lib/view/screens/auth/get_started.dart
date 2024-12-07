import 'package:flutter/material.dart';

class GetStartedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/gym-running-shoes-stockcake 3.png'),
            fit: BoxFit.cover, // Ensures the image scales properly
            alignment: Alignment.center, // Keeps the image centered
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Column(
                    children: [
                      Text(
                        'FitQuest',
                        style: TextStyle(
                          fontSize: screenWidth * 0.08,
                          fontFamily: 'Alegreya Sans',
                          color: const Color(0xFF467115),
                          shadows: const [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 1.0,
                              color: Color.fromARGB(128, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Move text and button lower
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.1),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                          child: Text(
                            'Your Personal Fitness Companion\nAchieve your Goals with ease',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontFamily: 'Alegreya',
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.05),

                        // Button
                        SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signup');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF81A55D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenHeight * 0.03),
                              ),
                              elevation: 2,
                            ),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Get Started',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.06,
                                  fontFamily: 'Alegreya',
                                  fontWeight: FontWeight.w100,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
