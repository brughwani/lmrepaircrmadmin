import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CRMDashboard extends StatefulWidget {
  
  


  @override
  State<CRMDashboard> createState() => _CRMDashboardState();
}

class _CRMDashboardState extends State<CRMDashboard> with SingleTickerProviderStateMixin {
  String? selectedValue;
  
   @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Initialize TabController
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }

  TextEditingController phoneNumber=TextEditingController();
  TextEditingController password=TextEditingController();
  TextEditingController firstName=TextEditingController();
  TextEditingController lastName=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController personalMobileNumber=TextEditingController();
  TextEditingController salary=TextEditingController();
  TabController? _tabController;
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
            TextFormField(controller:firstName,decoration: InputDecoration(labelText: 'First Name')
            ),
            TextFormField(controller:lastName,decoration: InputDecoration(labelText: 'Last Name')),
            TextFormField(controller:phoneNumber,decoration: InputDecoration(labelText: 'Mobile Number'),
            keyboardType: TextInputType.phone),
            TextFormField(decoration: InputDecoration(labelText: 'Address'),
            keyboardType: TextInputType.streetAddress),
            TextFormField(decoration: InputDecoration(labelText: 'password'),
            keyboardType: TextInputType.visiblePassword),
            TextFormField(decoration: InputDecoration(labelText: 'Personal Mobile Number'),
            keyboardType: TextInputType.phone),
            TextFormField(decoration: InputDecoration(labelText: 'Salary'),
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
            
            ElevatedButton(onPressed: (){}, child: Text('Add Employee'))
          ],),
          Center(child: Text('Content for Tab 2')),
        ],
      ),
    );
  }
}