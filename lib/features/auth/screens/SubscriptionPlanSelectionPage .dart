import 'package:flutter/material.dart';

class SubscriptionPlanSelectionPage extends StatefulWidget {
  @override
  _SubscriptionPlanSelectionPageState createState() =>
      _SubscriptionPlanSelectionPageState();
}

class _SubscriptionPlanSelectionPageState
    extends State<SubscriptionPlanSelectionPage> {
  int selectedPlanIndex = 0;
  double pricePerMonth = 200.0;
  double totalPrice = 200.0;

  void updatePrice(int index) {
    setState(() {
      selectedPlanIndex = index;
      if (index == 0) {
        totalPrice = pricePerMonth;
      } else if (index == 1) {
        totalPrice = pricePerMonth * 6;
      } else if (index == 2) {
        totalPrice = pricePerMonth * 12;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Subscribe'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 120.0),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 14.0),
                  // Plan Selection Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPlanButton('1 month', 0),
                      _buildPlanButton('6 months', 1),
                      _buildPlanButton('1 year', 2),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Price Summary
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Summery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Per 1 month:'),
                              Text(
                                '${pricePerMonth.toStringAsFixed(2)} Birr',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total:'),
                              Text(
                                '${totalPrice.toStringAsFixed(2)} Birr',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Payment Method
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Pay with',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Implement the navigation to another page here
                      print("Payment method selected: Chapa");
                    },
                    child: Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'images/chapa_logo.png', // Replace with your actual image
                        height: 50,
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

  Widget _buildPlanButton(String text, int index) {
    return GestureDetector(
      onTap: () {
        updatePrice(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          color: selectedPlanIndex == index ? Colors.blue[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selectedPlanIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
