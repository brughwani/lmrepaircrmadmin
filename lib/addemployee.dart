import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lmrepaircrmadmin/employeeprovider.dart';
import 'package:provider/provider.dart';
//import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'dealerfetcher.dart';

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
 // final Map<String, bool> selectedItems = {};
  //List<Map<String, dynamic>> employees = [];


  @override
  TabController? tabController;
  String? selecteddealer;
  String? selectedcity;
  List<String>? locations;
  List<String>? dealers;
  List<Map<String, dynamic>> options = [
    {"label": "First name", "value": false},
    {"label": "Last name", "value": false},
    {"label": "address", "value": false},
    {"label":"Phone","value":false},
    {"label":"Salary","value":false},
    {"label":"Role","value":false}
  ];



  @override
  void initState()
  {
    super.initState();
    loadlocations();
    // options.forEach((item){
    //   selectedItems[item["label"]] = false;});
  }

  Future<void> loadlocations () async
  {
    try {
      var getlocations = await dealerfetcher.fetchLocation();
      setState(() {
        locations=getlocations;
      });
    }
    catch(e)
    {
      AlertDialog(title: Text("location"),content: Text("Error in getting locations $e"),);
    }
  }

  Future<void> loaddealer (String loc) async
  {
    try
        {
          var getdealer=await dealerfetcher.fetchDealer(loc);
          setState(() {
            dealers=getdealer;
          });
        }
        catch(e)
    {
      AlertDialog(title: Text("dealer"),content: Text("error in getting dealer data $e"));
    }
  }

  // Future<void> fetchallemployees  (List<String> fields) async
  // {
  //   final String url="https://crmvercelfun.vercel.app/api/getallemployee?fields[]=$fields";
  //   final resp= await http.get(Uri.parse(url),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //   final List<dynamic> jsonData = jsonDecode(resp.body);
  //
  //   setState(() {
  //     employees = jsonData.map((e) => Map<String, dynamic>.from(e)).toList();
  //   });
  //
  //
  // }

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
    return DefaultTabController(
      length: 2,
      child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:TabBarView(
      controller: tabController,
      children:[
                  Column(
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
                      }, child: Text('Add Employee')),
                    ],
                  ),
        SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     children: [
              //       Expanded(child: Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: DropdownButtonFormField2(
              //           value: selecteddealer,
              //           isExpanded: true,
              //           decoration: InputDecoration(border: OutlineInputBorder()),
              //           onChanged: (value) => setState(() => selecteddealer = value),
              //           items:
              //               dealers?.map((dealer) => DropdownMenuItem(
              //             value: dealer,
              //             child: AutoSizeText(dealer, overflow: TextOverflow.visible),
              //           ))
              //               .toList(),
              //         ),
              //       ),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Expanded(
              //         child: DropdownButtonFormField2(
              //           value: selectedcity,
              //           isExpanded: true,
              //           decoration: InputDecoration(border: OutlineInputBorder()),
              //           onChanged: (newValue) {
              //             setState(() {
              //               selectedcity = newValue;
              //               //dealerfetcher.fetchDealer(selectedcity!);
              //               //loaddealer(loc)
              //               loaddealer(selectedcity!);
              //             });
              //           },
              //           items: locations
              //               ?.map((location) => DropdownMenuItem(
              //             value: location,
              //             child: Text(location,overflow: TextOverflow.visible),
              //           ))
              //               .toList(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
             Text("Fields to be used in filtering"),

    Consumer<EmployeeProvider>(
      builder:(context,employeeProvider,_)
      {
      return  Column(
        children: [
          SizedBox(
              width: 300,
              height: 400,
              child: ListView(
                children: options.map((item) {
                  return CheckboxListTile(
                    title: Text(item["label"]),
                    value: employeeProvider.selectedFields.contains([item["label"]]),
                    onChanged: (bool? value) {
                      setState(() {
                        employeeProvider.toggleFieldSelection(item["label"],value!);

                        // print(item['label']);
                      }

                      );
                    },

                  );
                }).toList(),

              ),
            ),
          ElevatedButton(onPressed: (){

            // List<String> selectedAttributes = selectedItems.entries
            //     .where((entry) => entry.value == true)
            //     .map((entry) => entry.key)
            //     .toList();
            //
            // fetchallemployees(selectedAttributes);
            employeeProvider.fetchEmployees(employeeProvider.selectedFields);
           // print(selectedAttributes.runtimeType);

            //print(selectedItems.keys.groupListsBy(selectedItems.values.toList()[i]).);
          }, child:Text("Search Employee")),
        ],
      );

      } ,

    ),

            ],
          ),
        ),
      )
                  ],
                ),
              ),


    Material(
    color: Theme.of(context).primaryColor,
    child: TabBar(
    controller: tabController,
    labelColor: Colors.white,
    unselectedLabelColor: Colors.grey[300],
    tabs: const [
    Tab(icon: Icon(Icons.add), text: 'Add employee'),
    Tab(icon: Icon(Icons.search), text: 'Search employee'),
    ],
    )
    )
    ]
      )
    );
  }
}