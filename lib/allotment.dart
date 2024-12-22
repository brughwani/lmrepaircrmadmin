import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class AllotComplaints extends StatefulWidget {
  const AllotComplaints({super.key});

  @override
  State<AllotComplaints> createState() => _AllotComplaintsState();
}

class _AllotComplaintsState extends State<AllotComplaints> {

 late List<Map<String,dynamic>> complaints;
// Map<String, Map<String, dynamic>> pendingUpdates = {};
 late List<String> recordid;
  late Future<void> _fetchDataFuture;

 List<Map<String, dynamic>>? records;
 List<Map<dynamic,dynamic>> allotments=[];
  List<String>? allotment;
  Map<String,String>? a;
  List<String>? statuses;

  List<String> selectedRecords = [];
  Map<String, Map<String, String>> newValues = {};



  var selectedEmployee;

 List<String> employees=[];
 String? allottedemployee;
 String? status;

  @override
  void initState()
  {
    super.initState();

    _fetchDataFuture = fetchAllData();
  //  complaints=fetchallrequests();
 //   fetchallemployees();
    // fetchallrequests().then((_) {
    //   // Fetch current allotments and statuses for all records
    //   // for (var id in recordid) {
    //   //   getCurrentallotmentandStatus(id);
    //   // }
    // });


   // records.map((r)=>(  getCurrentallotmentandStatus(r);));
  }

  Future<void> updaterecord(String recordId, String fieldName, String newValues) async
  {

    var url="https://crmvercelfun.vercel.app/api/updaterecord";
    final body = {
      "id": recordId,
      "fields": newValues,
    };
    // print(1);
    // print(body);

    var resp=await http.patch(Uri.parse(url),headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body)
    );
    print(resp.body);
  }
Future<void> getCurrentallotmentandStatus(List<String> ids) async
{
  var query = ids.join(',');
  var url = "https://crmvercelfun.vercel.app/api/updaterecord?recordIds=$query";
  // final body = {
  //   "ids": ids,
  // };

  var resp = await http.get(Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
  );


  if (resp.statusCode == 200) {
    print(resp.body);
    Map<dynamic, dynamic> response = jsonDecode(resp.body);
    //print(response['currentDetails'].toString());

    List<dynamic> currentDetails = response['currentDetails'];

// Accessing the data
    for (var detail in currentDetails) {
      print(detail);
      allotments.add({{'id':detail['recordId']}:{'allotment':detail['currentAllotment'],'status':detail['currentStatus']}});
       print(6);
     //  String recordId = detail['recordId'];
     //  print(6.5);
     // // String a= detail['currentStatus'];
     //  statuses!.add(detail['currentStatus']);
     //  //print(7);
     //
     //  String currentAllotment = detail['currentAllotment'];
     //  allotment!.add(detail['currentAllotment']);
     //
     //  // print(recordId);
      // print(a);
      // print(currentAllotment);
    }

//     }
//
//
//
//       List<Map<String, dynamic>> currentDetails = response['currentDetails'][0];
//     print(1.55);
// //    a = {for (var detail in response['currentDetails'][0]) detail['recordId']: detail};
//     a = {for (var detail in currentDetails) detail['recordId']: detail['currentAllotment']};
//     print(1.65);
//     print(a);
//     print(2.5);
    //print(a);
//  print(allotment);
    // print(allotments);
  }
  //print(allotment);
  //print(statuses);
print(allotments);
}



 Future<void> fetchallemployees() async
 {
    var url="https://crmvercelfun.vercel.app/api/employeeService?getKarigars=true";
    var resp=await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      final List<dynamic> empList = json.decode(resp.body);
      setState(() {
        employees.addAll(empList.map((emp) => emp['First name'].toString()));
    //    allottedemployee=employees[0];
      });
    }
    // try
    //     {
    //       if(resp.statusCode==200)
    //         {
    //           return resp.body;
    //         }
    //     }
 }

 Future<void> fetchallrequests() async
 {
   var url="https://crmvercelfun.vercel.app/api/fetchallcomplaints";

   var resp= await http.get(Uri.parse(url));


   try{
     if (resp.statusCode == 200) {
       List<dynamic> jsonData = json.decode(resp.body);
       print(jsonData);
       records = jsonData.map((rec) {
         return {
           "id" : rec["id"],
           "fields":{
             "Name":rec['fields']['Customer name'],
             "product":rec['fields']['product name'],
             "category":rec['fields']['category'],
             "phone":rec['fields']['Phone Number'],
             "city":rec['fields']['City'],
             "Purchase Date":rec['fields']['Purchase Date'],
             "warranty end":rec['fields']['warranty expiry date']
           }
         };
       } ).toList();
       recordid=jsonData.map((id)=>
           id['id'].toString()
       ).toList();
      // print(recordid);

       complaints=jsonData.map((data) => data['fields'] as Map<String, dynamic>).toList();
     } else {
       throw Exception('Failed to load data');
     }
   } catch (e) {
     throw Exception('Error fetching data: $e');
   }
 }

  Future<void> fetchAllData() async {
    print(1);
    await fetchallemployees();
    await fetchallrequests();
    await getCurrentallotmentandStatus(recordid);
    print(1.5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Allot Complaints'),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Update records with new values
            for (var entry in newValues.entries) {
              if(selectedRecords.contains(entry.key))
                updaterecord(entry.key, entry.value.keys.first, entry.value.values.first);
            }
          },
          child: Text('Save'),
        ),
      ],
      ),
      body: FutureBuilder<void>(
        future: _fetchDataFuture, // Use the future initialized in initState
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        print(2);
        //print(snapshot.connectionState.s\\)
        return Center(child: CircularProgressIndicator()); // Loading
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Error
      // Empty data
      }
      // else if (!snapshot.hasData || records!.isEmpty) {
      //   return Center(child: Text('No data available'));
      // }
      else {
        // Success: Build the DataTable
      //  List<Map<String, dynamic>> data = snapshot.data!;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Select')),
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Allotted To')),
                DataColumn(label: Text("Complain Status")),
                DataColumn(label: Text('Product Name',softWrap: true,overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text('Phone Number')),
                DataColumn(label: Text('City',softWrap: true,overflow: TextOverflow.visible,)),
                DataColumn(label: Text('Warranty Expiry',softWrap: true,overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text('Purchase Date',softWrap: true,overflow: TextOverflow.ellipsis,)),
                //DataColumn(label: Text('actions'))
              ],
              rows: records!.map((complaint) {
                var allotment1 = allotments.firstWhere((a1) => a1.keys.first['id']== complaint['id'], orElse: () => {});

//                print(allotment1);
                var currentAllotment = allotment1.isNotEmpty ? allotment1.values.first['allotment'] : null;
                var currentStatus = allotment1.isNotEmpty ? allotment1.values.first['status'] : null;

                return DataRow(
    //               selected: selectedRecords.contains(complaint['id']),
    //
    // onSelectChanged: (selected) {
    //   setState(() {
    //     if (selected!) {
    //       selectedRecords.add(complaint['id']);
    //     } else {
    //       selectedRecords.remove(complaint['id']);
    //     }
    //   });
    // },



                  cells: [
                    DataCell(Checkbox(
                      value: selectedRecords.contains(complaint['id']),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value!) {
                            selectedRecords.add(complaint['id']);
                          } else {
                            selectedRecords.remove(complaint['id']);
                          }
                        });
                      },
                    )),
                   // DataCell(Text(complaint['Customer name'])),
                    DataCell(TextFormField(initialValue:complaint['fields']['Name'],onChanged: (newvalue){updaterecord(complaint['id'],'Customer name', newvalue);},)),
                    DataCell(StatefulBuilder( builder: (context, setState) {
                      return DropdownButton(
                        value: currentAllotment ?? allottedemployee,
                        //getCurrentallotmentandStatus(complaint['fields']),
                          items: employees.map((emp) =>
                          DropdownMenuItem(value: emp, child: Text(emp))).toList(),
                          onChanged: (newemp) {
                            setState(()
                            {
                              allottedemployee=newemp as String;
                             // updaterecord(complaint['id'],'alloted to',allottedemployee!);
                              newValues[complaint['id']] = {"allotted to": allottedemployee!};
                            });
                            setState(() {
                              currentAllotment=allottedemployee;
                            });

                          });
                    }
              )),
                    DataCell(StatefulBuilder(builder: (context,setState) {
                      return DropdownButton(
                          value: currentStatus.toString() ?? status,
                          items: [
                            DropdownMenuItem(
                                child: Text("Open"), value: "Open"),
                            DropdownMenuItem(child: Text("In progress"),
                                value: "In progress"),
                            DropdownMenuItem(
                                child: Text("Resolved"), value: "Resolved")
                          ],
                          onChanged: (String? newStatus) {
                            status = newStatus;
                            newValues[complaint['id']] = {"Status": status!};
                            //updaterecord(complaint['id'],'Status', newStatus!);

                      setState(() {
                        currentStatus = status;
                      });
                    });
                    }

                    )),
                    DataCell(Text(complaint['fields']['product'])),
                    DataCell(TextFormField(
                      initialValue: complaint['fields']['phone'],
                      onChanged: (newvalue) {
                        newValues[complaint['id']] = {"phone": newvalue};
                      },
                    )),
                    DataCell(Text(complaint['fields']['city'])),
                    DataCell(Text(complaint['fields']['warranty end'])),
                    DataCell(Text(complaint['fields']['Purchase Date'])),

                  ],
                );
              }).toList(),
            ),
          ),
        );
      }
    },
    )
    );
  }
}
