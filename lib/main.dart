import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'Admindashboard.dart';
void main() {
  runApp(MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:CRMDashboard()
    );
  }
}