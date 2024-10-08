import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class CRMDashboard extends StatefulWidget {
  
  @override
  State<CRMDashboard> createState() => _CRMDashboardState();
}

class _CRMDashboardState extends State<CRMDashboard> with SingleTickerProviderStateMixin {
  String? selectedValue;

  final apiKey = dotenv.env['AIRTABLE_API_KEY'];
  final baseId = dotenv.env['AIRTABLE_BASE_ID'];
  final tableName = 'Employees';


  TextEditingController phoneNumber=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController personalMobileNumber=TextEditingController();
  TextEditingController salary=TextEditingController();
  TabController? _tabController;
  
  
   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController
  }

 Future<void> createRecord() async {
    final String url = 'https://api.airtable.com/v0/$baseId/$tableName';

    // Prepare the data to be sent
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "fields": {
          "First Name": firstName.text,
          "Last Name": lastName.text,
          "Address": address.text,
          "Phone Number": phoneNumber.text,
          "Password": password.text,
          "Personal Mobile Number": personalMobileNumber.text,
          "Salary": salary.text
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Record created successfully: ${response.body}');
    } else {
      print('Failed to create record: ${response.statusCode} ${response.body}');
    }
  }


  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    address.dispose();
    phoneNumber.dispose();
    password.dispose();
    personalMobileNumber.dispose();
    salary.dispose();
    _tabController?.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        title: Text('TabBar Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon:Icon(Icons.person),text: "Employee"),
            Tab(icon:Icon(Icons.note),text: "Complains and Requests"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextFormField(
              controller:firstName,
              decoration: InputDecoration(labelText: 'First Name')
            ),
            TextFormField(
              controller:lastName,
              decoration: InputDecoration(labelText: 'Last Name')),
            TextFormField(
              controller:phoneNumber,
              decoration: InputDecoration(labelText: 'Mobile Number'),
            keyboardType: TextInputType.phone),
            TextFormField(
              controller: address,
              decoration: InputDecoration(labelText: 'Address'),
            keyboardType: TextInputType.streetAddress),
            TextFormField(
              controller: password,
              decoration: InputDecoration(labelText: 'password'),
            keyboardType: TextInputType.visiblePassword),
            TextFormField(
              controller: personalMobileNumber,
              decoration: InputDecoration(labelText: 'Personal Mobile Number'),
            keyboardType: TextInputType.phone),
            TextFormField(
              controller: salary,
              decoration: InputDecoration(labelText: 'Salary'),
            keyboardType: TextInputType.number),
             DropdownButton(
              hint: Text('Select Role'),
              value: selectedValue,
              items: [
              DropdownMenuItem(
                child: Text('Karigar'),
                value: 'Karigar',
                ),
              DropdownMenuItem(
                child: Text('Support'),
                value: 'Support',
                ),
                
          ], onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },),
            
            ElevatedButton(onPressed: (){



            }, child: Text('Add Employee'))
          ],),
          Center(child: Text('Content for Tab 2')),
        ],
      ),
    );
  }
}