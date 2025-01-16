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



  @override
  void initState()
  {
    super.initState();
  //  complaints=fetchallrequests();
  }

 Future<void> fetchallemployees() async
 {
    var resp=await http.get(Uri.parse(url));

    if (resp.statusCode == 200) {
      final List<dynamic> empList = json.decode(resp.body);
      setState(() {
        employees.addAll(empList.map((emp) => emp['First name'].toString()));
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

 {
   var url="https://crmvercelfun.vercel.app/api/fetchallcomplaints";

   var resp= await http.get(Uri.parse(url));


   try{
     if (resp.statusCode == 200) {
       List<dynamic> jsonData = json.decode(resp.body);
     } else {
       throw Exception('Failed to load data');
     }
   } catch (e) {
     throw Exception('Error fetching data: $e');
   }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator()); // Loading
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}')); // Error
        // Success: Build the DataTable
            padding: const EdgeInsets.all(16.0),
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Customer Name')),
                DataColumn(label: Text('Phone Number')),
              ],
                return DataRow(
                  cells: [
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
