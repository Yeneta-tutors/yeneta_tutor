import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl_browser.dart';

class EarningsPage extends StatelessWidget {
   final String currentDate = DateFormat('EEEE, dd MMMM yyyy - h:mm a').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Earnings'),
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Column(
        children: [
          // Total Earnings Box
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(17, 25, 66, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Earning',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '9146 Birr',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentDate,
                        style: TextStyle(
                          color: const Color.fromARGB(179, 255, 255, 255),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: earningsData.length,
              itemBuilder: (context, index) {
                return EarningsCard(earning: earningsData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EarningsCard extends StatelessWidget {
  final Earning earning;

  EarningsCard({required this.earning});

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextRow(label: 'Grade', value: earning.grade.toString()),
            Divider(thickness: 0.5, color: Colors.black),
            TextRow(label: 'Subject', value: earning.subject),
            Divider(thickness: 0.5, color: Colors.black),
            TextRow(label: 'Chapter', value: earning.chapter.toString()),
            Divider(thickness: 0.5, color: Colors.black),
            TextRow(label: 'Price', value: '${earning.price} Birr'),
            Divider(thickness: 0.5, color: Colors.black),
            SizedBox(height: 8),
            Text(
              'Total Sales : ${earning.totalSales} Birr',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
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

class Earning {
  final int grade;
  final String subject;
  final int chapter;
  final int price;
  final int totalSales;

  Earning({
    required this.grade,
    required this.subject,
    required this.chapter,
    required this.price,
    required this.totalSales,
  });
}

final List<Earning> earningsData = [
  Earning(grade: 11, subject: 'Chemistry', chapter: 1, price: 69, totalSales: 565),
  Earning(grade: 12, subject: 'Chemistry', chapter: 2, price: 79, totalSales: 965),
  Earning(grade: 9, subject: 'Chemistry', chapter: 7, price: 76, totalSales: 335),
];
