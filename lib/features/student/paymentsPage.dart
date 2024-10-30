import 'package:flutter/material.dart';

class PaymentHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payments'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: paymentData.length,
        itemBuilder: (context, index) {
          return PaymentCard(payment: paymentData[index]);
        },
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  final Payment payment;

  PaymentCard({required this.payment});

  @override

  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      shadowColor: Colors.black,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextRow(label: 'Grade', value: payment.grade.toString()),
            Divider(thickness: 1),
            TextRow(label: 'Subject', value: payment.subject),
            Divider(thickness: 1),
            TextRow(label: 'Chapter', value: payment.chapter.toString()),
            Divider(thickness: 1),
            TextRow(label: 'Date', value: payment.date),
            Divider(thickness: 1),
            TextRow(label: 'Price', value: '${payment.price} Birr'),
          ],
        ),
      ),
    );
  }
}

class TextRow extends StatelessWidget {
  final String label;
  final String value;

  TextRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}

class Payment {
  final int grade;
  final String subject;
  final int chapter;
  final String date;
  final int price;

  Payment({
    required this.grade,
    required this.subject,
    required this.chapter,
    required this.date,
    required this.price,
  });
}

// Sample data for demonstration
final List<Payment> paymentData = [
  Payment(grade: 11, subject: 'Chemistry', chapter: 1, date: '12/8/2024 - 8:21 pm', price: 99),
  Payment(grade: 11, subject: 'Physics', chapter: 1, date: '12/8/2024 - 8:21 pm', price: 71),
  Payment(grade: 11, subject: 'Biology', chapter: 1, date: '12/8/2024 - 8:21 pm', price: 69),
  Payment(grade: 11, subject: 'Physics', chapter: 1, date: '12/8/2024 - 8:21 pm', price: 79),
];
