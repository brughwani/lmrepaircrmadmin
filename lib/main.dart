import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'Admindashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
Future<void> main() async {
 

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