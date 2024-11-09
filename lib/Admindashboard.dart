import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lmrepaircrmadmin/addemployee.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
class CRMDashboard extends StatefulWidget {
  
  @override
  State<CRMDashboard> createState() => _CRMDashboardState();

}
 
class _CRMDashboardState extends State<CRMDashboard> with SingleTickerProviderStateMixin {
  
  String? selectedstatus;

  final tableName1 = 'Employees';
  final tableName2= 'Products';
 
 DateTime? selectedDate;


  List<String> availableProducts = []; // Products available based on selected categories

  //List<dynamic> countryCityPairs = []; // Will hold the loaded JSON data
  String? selecteddealer; // Selected dealer
  String? selectedCity; // Selected city
  //List<String> cities = []; // Cities based on the selected country

  List<String> products =[];
  List<String> locations=[];
  List<String> dealerNames = [];
  TabController? _tabController;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromdateController = TextEditingController();
final TextEditingController todateController = TextEditingController();
final TextEditingController Name = TextEditingController();
final TextEditingController mobile = TextEditingController();
final double narrowScreenWidth = 600;
  final double mediumScreenWidth = 1000;
  String? selectedCategory;
  String? selectedProduct;
  List<String> selectedCategories = [];
  List<String> selectedProducts = [];
   
  List<String> categories = [];
 // Map<String, List<String>> productsByCategory = {};

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/category'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> categoryList = json.decode(response.body);
      setState(() {
        categories = categoryList.map((category) => category.toString()).toList();
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchProductsForCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/product?category=$categoryId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
//   print(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      setState(() {
        products = productList.map((e) => e['productName'].toString()).toList();
        selectedProduct = null; // Reset product selection when category changes
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> fetchlocation() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/location'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
if(response.statusCode == 200)
  {
    final List<dynamic> locationlist=jsonDecode(response.body);
    setState(() {
      locations=locationlist.map((location) => location.toString()).toList();
    });
  }
else
  {
    throw Exception("Failed to load locations");
  }
  }

  Future<void> fetchdealer(String loc) async
  {
    final response= await http.get( Uri.parse("https://crmvercelfun.vercel.app/api/dealer?locality=$loc"),headers: {
      'Content-Type': 'application/json',
    },
    );

    if(response.statusCode==200)
      {
        final List<dynamic> dealers=jsonDecode(response.body);
        setState(() {
          dealerNames=dealers.map((dealer)=>dealer['dealerName'].toString()).toList();
        });
      }
    else
      {
        throw Exception("Failed to get dealers");
      }


  }

// Future<void> fetchproductcategories() async {
//   final headers = {
//     'Authorization': 'Bearer $apiKey',
//     'Content-Type': 'application/json',
//     'view': 'Grid \'view',
//   };
//   var dio = Dio();
//     final url = 'https://api.airtable.com/v0/$baseId/$tableName2?fields[]=Category';

// var response = await dio.request(url,
//  options: Options(
//     method: 'GET',
//     headers: headers,
//   ),
// );

// if (response.statusCode == 200) {
//   print(json.encode(response.data));
// }
// else {
//   print(response.statusMessage);
// }
// }
//  Future<void> fetchCategories() async {
//     final url = 'https://api.airtable.com/v0/$baseId/$tableName2?fields[]=Category';

//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $apiKey',
//         'Content-Type': 'application/json',
//         'view': 'Grid view',
//       },
//     );

//     if (response.statusCode == 200) {
//     final data = jsonDecode(response.body);
    
//     // Prepare the list of categories
//   //  List<String> categoryList = List<String>.from(data['records'].map((record) => record['fields']['Category']));
    
//     // Update state after fetching categories
//     // setState(() {
//     //   categories = categoryList;
//     // });
//   } else {
//     print('Failed to load categories');
//   }
//   }
//  Future<void> fetchProducts(String category) async {
//     final url = 'https://api.airtable.com/v0/$baseId/$tableName2?filterByFormula={Category}="$category"&fields[]=Product Name';

//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $apiKey',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//        List<String> productNames = List<String>.from(data['records'].map((record) => record['fields']['Product Name']));
//       setState(() {
//         productsByCategory[category] = productNames;
//         selectedProduct = null;// Reset selected product when category changes
//       });
//     } else {
//       print('Failed to load products');
//     }
//   }
//   Future<void> fetchCategoriesAndProducts() async {
//     final url = 'https://api.airtable.com/v0/$baseId/$tableName2';

//     final response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Authorization': 'Bearer $apiKey',
//         'Content-Type': 'application/json',
//         'typecast':'true'
//       },
//     );

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
      
      
//       // Populate category and product map
//       for (var record in data['records']) {
//         String category = record['fields']['Category'];
//         List<String> products = List<String>.from(record['fields']['Product Name']);
//         //print(products);
//         if (!productMap.containsKey(category)) {
//           productMap[category] = [];
//         }
//         productMap[category]!.addAll(products);
//       }
//     } else {
//       print('Failed to load categories and products');
//     }
//   }
// void updateAvailableProducts() {
//     availableProducts.clear();
//     for (String category in selectedCategories) {
//       availableProducts.addAll(productMap[category] ?? []);
//     }
//     setState(() {
//       selectedProducts.clear(); // Reset selected products when categories change
//     });
//   }
// Future<void> loadJsonData() async {
//     try {
//       String jsonString = await rootBundle.loadString('assets/customerlist.json');
//       final Map<String, dynamic> jsonData = json.decode(jsonString);
      
//       // Access the "List of Ledgers" key specifically
//       final List<dynamic> ledgersList = jsonData['List of Ledgers '] ?? [];
      
//       setState(() {
//         // Convert the list to the correct type
//         dealerCityPairs = List<Map<String, dynamic>>.from(ledgersList);
        
//         // Extract unique locations
//         locations = dealerCityPairs
//             .map((pair) => pair['location'] as String)
//             .toSet();
            
//         // Sort locations alphabetically
//         var sortedLocations = locations.toList()..sort();
//         locations = sortedLocations.toSet();
//       });
//     } catch (e) {
//       print('Error loading JSON: $e');
//     }
//   }
 
  
   @override
  void initState() {
    super.initState();
  //  loadJsonData();
    _tabController = TabController(length: 2, vsync: this);
    // Initialize TabController
     fetchlocation();
     fetchCategories();
  //fetchCategories();
  // fetchCategoriesAndProducts();
  // fetchproductcategories();
    
  }

 

 Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      fieldLabelText: 'Purchase date',
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),

      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
dateController.text = "${picked.toLocal()}".split(' ')[0]; // Update the text field with the selected date
     
      });
    }
  }


  @override
  void dispose() {
   
    _tabController?.dispose(); // Dispose the controller to avoid memory leaks
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        title: Text('Admin Dashboard'),
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
          AddEmployee(),
           SingleChildScrollView(
            child: Column(
              children: [
                Row(children: [
                           Expanded(
                             child: TextFormField(
                                             controller: fromdateController,
                                             decoration: InputDecoration(labelText: 'From Date',border: OutlineInputBorder()),
                                             readOnly: true,
                                             
                                             onTap: () => _selectDate(context),
                                            ),
                           ),
                  Expanded(
                    child: TextFormField(
                    controller: todateController,
                    decoration: InputDecoration(labelText: 'To Date'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                                   ),
                  ),
                  Expanded(
                    child: TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(labelText: 'By Date',hintText: 'Complains By Date',border: OutlineInputBorder()),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                                   ),
                  ),
                   Expanded(
                     child: DropdownButton(
                                   hint: Text('compalint status'),
                                   value: selectedstatus,
                                   items: [
                                   DropdownMenuItem(
                                     child: Text('Pending'),
                                     value: 'Pending',
                                     ),
                                   DropdownMenuItem(
                                     child: Text('In progress'),
                                     value: 'In progess',
                                     ),
                     DropdownMenuItem(
                                     child: Text('Closed'),
                                     value: 'Closed',
                                     ),
                               ], onChanged: (value) {
                                 setState(() {
                                   selectedstatus = value;
                                 });
                               }
                               ,),
                   ),  
            Expanded(
              child: TextFormField(controller:Name ,
              decoration: InputDecoration(labelText: 'Name',border: OutlineInputBorder()),),
            ),
                    Expanded(
              child: TextFormField(
                controller: mobile,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Mobile Number',border: OutlineInputBorder()),
              ),
            ),


            // DropdownButton<String>(
            //   hint: Text('Select location'),
            //   value: selectedCity,
            //   onChanged: (value) {
            //     if(value!=null && value != selectedCity)
            //     {
            //     setState(() {
            //       selectedCity = value;
            //       // Filter cities based on the selected country
            //       customerNames = dealerCityPairs.where((pair) => pair['location'] == selectedCity)
            //           .map((pair) => pair['Customer name'].toString())
            //           .toList();
            //       // Reset the selected dealer when city changes
            //       selecteddealer = null;
            //     });
            //     }
            //   },
            //   items: locations.map<DropdownMenuItem<String>>((String city) {
            //     return DropdownMenuItem<String>(
            //       value: city,
            //       child: Text(city),
            //     );
            //   }).toList(),
            // ),
            // SizedBox(height: 20),
            //
            // // Second Dropdown (Cities)
            // DropdownButton<String>(
            //   hint: Text('Select dealer'),
            //   value: selecteddealer,
            //   onChanged: (value) {
            //     if(value!=null)
            //     {
            //     setState(() {
            //
            //       selecteddealer = value;
            //
            //       // Reset customer selection
            //     });
            //     }
            //   },
            //   items: customerNames.map<DropdownMenuItem<String>>((String dealer) {
            //     return DropdownMenuItem<String>(
            //       value: dealer,
            //       child: Text(dealer),
            //     );
            //   }).toList(),
            // ),
                ],
                ),
                IntrinsicWidth(
                  child: Row(
                    children: [
                      Expanded(
                  flex: 1,
                        child: DropdownButton(
                          value: selectedCity,
                          onChanged: (newValue) {

                            setState(() {
                              selectedCity = newValue as String?;
                            });
                            if(newValue!=null)
                              {
                                fetchdealer(selectedCity.toString());
                              }

                          },
                          items: locations.map<DropdownMenuItem<String>>((String loc) {
                            return DropdownMenuItem<String>(
                              value: loc,
                              child: Text(loc),
                            );
                          }).toList(),

                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child:  DropdownButton(
            value: selecteddealer,
            items: dealerNames.map<DropdownMenuItem<String>>((String d) {
              return DropdownMenuItem<String>(
                  value: d,
                  child: Text(d, overflow: TextOverflow.ellipsis));
            }).toList()
            , onChanged: (dealerselected) {
          setState(() {
            selecteddealer = dealerselected;
          });
        }
        )

                        ),



                      Expanded(
                          flex: 1,
                        child: DropdownButton(
                          value: selectedProduct,

                          items:products.map<DropdownMenuItem<String>>((String product){
                            return DropdownMenuItem<String>(value:product,child:Text(product,overflow: TextOverflow.ellipsis));}).toList()
                          , onChanged:(productselected)
                                            {
                        setState(() {
                          selectedProduct=productselected;
                        });
                                            }
                                            ),
                      ),
                    Expanded(
                      flex: 1,
                      child: DropdownButton(
                        value: selectedCategory,
                        onChanged: (newValue) {

                          setState(() {
                            selectedCategory = newValue as String?;
                          });
                          if (newValue != null) {
                            fetchProductsForCategory(newValue); // Fetch products for the selected category
                          }
                        },
                        items: categories.map<DropdownMenuItem<String>>((String category) {
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),

                      ),
                    ),

                                ]
                              ),
                ),
               ]
          ),
           )
         ]
           )
      
    );
  }
}