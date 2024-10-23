import 'package:flutter/material.dart';

class PaymentFailedScreen extends StatelessWidget {
  final String errorMessage;

  PaymentFailedScreen({required this.errorMessage});  // Accept error message as a parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             SizedBox(height: 100),
            // Lottie Animation for Failure
            // Lottie.network(
            //   'assets/error_animation.json',  // Lottie animation for error
            //   width: 200,
            //   height: 200,
            //   repeat: false,
            // ),
            SizedBox(height: 20),
            
            // Error Icon
            Icon(
              Icons.error,
              color: Colors.red,
              size: 80,
            ),
            SizedBox(height: 20),
            
            // Error Message
            Text(
              'Payment Failed',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            
            // Display the passed error message
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                errorMessage,  // Dynamic error message
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,  // Center the error message text
              ),
            ),
            SizedBox(height: 40),
            
            // Try Again Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Try Again action (e.g., re-initiate payment)
                  Navigator.pop(context);  // Example: Navigate back for retry
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,  // Red to indicate failure
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Try Again',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
