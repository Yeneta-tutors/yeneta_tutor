import 'package:flutter/material.dart';
import 'package:yeneta_tutor/features/auth/screens/PaymentFailedScreen.dart';


class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
                    SizedBox(height: 60),

            SizedBox(height: 20),
            
            // Success Icon
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 150,
            ),
            SizedBox(height: 20),
            
            // Success Message
            Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            
            // Subtitle
            Text(
              'Thank you for your purchase.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),
            
            // Done Button
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {
                  
                    //           Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => LoginScreen(),// route sisera enchemrewalen
                    //   ),
                    // );

             Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentFailedScreen(
                        errorMessage: 'Payment Declined: Check your balance', errorMsg: '',
                      ),
                    ),
                  );

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), 
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Done',
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
