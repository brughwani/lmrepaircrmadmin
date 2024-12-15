import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'loginpage.dart';
import 'Admindashboard.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'employeeprovider.dart';
Future<void> main() async {
  runApp(
      ChangeNotifierProvider(
        create: (_) => EmployeeProvider(),

      child: MyWidget()));
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