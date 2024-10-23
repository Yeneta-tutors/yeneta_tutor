import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous page
          },
        ),
        title: Text('Privacy policy'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy policy',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 16),
                Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Donec fringilla tincidunt lorem, ut gravida neque pellentesque in. '
                  'Orci varius natoque penatibus et magnis dis parturient montes, '
                  'nascetur ridiculus mus. Pellentesque luctus lorem at varius gravida. '
                  'Praesent laoreet in felis nec gravida. Nulla tristique nisi at neque '
                  'aliquet, quis pharetra metus elementum. Etiam euismod venenatis metus. '
                  'Sed sit amet auctor lorem, id convallis tortor. Lorem ipsum dolor sit '
                  'amet, consectetur adipiscing elit. Donec fringilla tincidunt lorem, '
                  'ut gravida neque pellentesque in. Orci varius natoque penatibus et magnis '
                  'dis parturient montes, nascetur ridiculus mus. Pellentesque luctus lorem '
                  'at varius gravida. Praesent laoreet in felis nec gravida. Nulla tristique '
                  'nisi at neque aliquet, quis pharetra metus elementum. Etiam euismod '
                  'venenatis metus. Sed sit amet auctor lorem, id convallis tortor.',
                  
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Text(
                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Donec fringilla tincidunt lorem, ut gravida neque pellentesque in. '
                  'Orci varius natoque penatibus et magnis dis parturient montes, '
                  'nascetur ridiculus mus. Pellentesque luctus lorem at varius gravida. '
                  'Praesent laoreet in felis nec gravida. Nulla tristique nisi at neque '
                  'aliquet, quis pharetra metus elementum. Etiam euismod venenatis metus. '
                  'Sed sit amet auctor lorem, id convallis tortor. Lorem ipsum dolor sit '
                  'amet, consectetur adipiscing elit. Donec fringilla tincidunt lorem, '
                  'ut gravida neque pellentesque in. Orci varius natoque penatibus et magnis '
                  'dis parturient montes, nascetur ridiculus mus. Pellentesque luctus lorem '
                  'at varius gravida. Praesent laoreet in felis nec gravida. Nulla tristique '
                  'nisi at neque aliquet, quis pharetra metus elementum. Etiam euismod '
                  'venenatis metus. Sed sit amet auctor lorem, id convallis tortor.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PrivacyPolicyPage(),
  ));
}
