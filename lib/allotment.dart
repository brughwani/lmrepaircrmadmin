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
 late List<String> employees;



  @override
  void initState()
  {
    super.initState();
  //  complaints=fetchallrequests();
    fetchallemployees();
  }

 Future<void> fetchallemployees() async
 {
    var url="https://crmvercelfun.vercel.app/api/getallkarigar?Role=Karigar";
    var resp=await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      final List<dynamic> empList = json.decode(resp.body);
      setState(() {
        employees.addAll(empList.map((emp) => emp['First name'].toString()));
        //selectedEmployee=employees[0];
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

 Future<List<Map<String,dynamic>>> fetchallrequests() async
 {
   var url="https://crmvercelfun.vercel.app/api/fetchallcomplaints";

   var resp= await http.get(Uri.parse(url));


   try{
     if (resp.statusCode == 200) {
       List<dynamic> jsonData = json.decode(resp.body);
       return jsonData.map((data) => data['fields'] as Map<String, dynamic>).toList();
     } else {
       throw Exception('Failed to load data');
     }
   } catch (e) {
     throw Exception('Error fetching data: $e');
   }



 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchallrequests(), // Use the future initialized in initState
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Loading
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Error
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(child: Text('No data available')); // Empty data
      } else {
        // Success: Build the DataTable
        List<Map<String, dynamic>> data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Customer Name')),
              DataColumn(label: Text('Product Name')),
              DataColumn(label: Text('Phone Number')),
              DataColumn(label: Text('City')),
              DataColumn(label: Text('Warranty Expiry')),
              DataColumn(label: Text('Purchase Date')),
            ],
            rows: data.map((complaint) {
              return DataRow(
                cells: [
                  DataCell(Text(complaint['Customer name'])),
                  DataCell(Text(complaint['product name'])),
                  DataCell(Text(complaint['Phone Number'])),
                  DataCell(Text(complaint['City'])),
                  DataCell(Text(complaint['warranty expiry date'])),
                  DataCell(Text(complaint['Purchase Date'])),
                ],
              );
            }).toList(),
          ),
        );
      }
    },
    )
    );
  }
}
