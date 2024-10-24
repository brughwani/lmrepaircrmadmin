import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController mobile=TextEditingController();
  TextEditingController phoneNumber=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController Name=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController personalMobileNumber=TextEditingController();
  TextEditingController salary=TextEditingController();
  String? selectedValue;
  Future<void> createRecord(String firstName, String lastName, String address, String phoneNumber, String password, String personalMobileNumber, String salary, String role) async {
    final String url = 'https://crmvercelfun.vercel.app/api/addemployee';
    // Prepare the data to be sent
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        { "fields":
         {
          "First Name": firstName,
          "Last Name": lastName,
          "Address": address,
          "Phone Number": phoneNumber,
          "Password": password,
          "Personal Mobile Number": personalMobileNumber,
          "Salary": salary,
          "Role": role,
        }
        }
      ),

    );

print(jsonEncode({
  "First Name": firstName,
  "Last Name": lastName,
  "Address": address,
  "Phone Number": phoneNumber,
  "Password": password,
  "Personal Mobile Number": personalMobileNumber,
  "Salary": salary,
}));
    if (response.statusCode == 200) {
      
      print('Record created successfully: ${response.body}');
    } else {
      print('Failed to create record: ${response.statusCode} ${response.body}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
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
              createRecord(firstName.text.toString(), lastName.text.toString(), address.text.toString(), phoneNumber.text.toString(), password.text.toString(), personalMobileNumber.text.toString(), salary.text.toString(), selectedValue.toString());
            }, child: Text('Add Employee'))]);
  }
}