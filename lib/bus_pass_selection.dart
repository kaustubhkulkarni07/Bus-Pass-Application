import 'package:flutter/material.dart';
import 'generate_pass_page.dart'; // Import the GeneratePassPage

class BusPassSelectionScreen extends StatelessWidget {
  const BusPassSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Green gradient shape at the bottom
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 200,
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.shade700,
                      Colors.green.shade300,
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(150),
                  ),
                ),
              ),
            ),
            
            // Main content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Bus icon with clouds in blue circle
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFADE1F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Bus icon
                          Container(
                            width: 55,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              size: 30,
                              color: Colors.blue,
                            ),
                          ),
                          
                          // Clouds
                          const Positioned(
                            top: 25,
                            left: 20,
                            child: Icon(
                              Icons.cloud,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                          const Positioned(
                            top: 30,
                            right: 20,
                            child: Icon(
                              Icons.cloud,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 70),
                  
                  // Current Pass button
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add your current pass functionality here
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Current Pass button pressed"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'Current Pass',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // New Pass button - Now with navigation to GeneratePassPage
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to GeneratePassPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const GeneratePassPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'New Pass',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
    );
  }
}