import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lmrepaircrmadmin/addemployee.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CRMDashboard extends StatefulWidget {
  @override
  State<CRMDashboard> createState() => _CRMDashboardState();
}

class _CRMDashboardState extends State<CRMDashboard> with SingleTickerProviderStateMixin {
  String? selectedStatus;
  String? selectedDealer;
  String? selectedCity;
  String? selectedEmployee;
  String? selectedCategory;
  String? selectedProduct;
  DateTime? selectedDate;
  String? requesttype;
  var requesttypes=['Installation','Demo','Service','Complain'];

  List<String> employees = [];
  List<String> products = [];
  List<String> locations = [];
  List<String> dealerNames = [];
  List<String> categories = [];

  final TextEditingController dateController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchLocation();
    fetchCategories();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/getallkarigar?Role=Karigar'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> empList = json.decode(response.body);
      setState(() {
        employees = empList.map((emp) => emp['First Name'].toString()).toList();
      });
    }
  }

  Future<void> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/category'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> categoryList = json.decode(response.body);
      setState(() {
        categories = categoryList.map((category) => category.toString()).toList();
      });
    }
  }

  Future<void> fetchProductsForCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/product?category=$categoryId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> productList = json.decode(response.body);
      setState(() {
        products = productList.map((e) => e['productName'].toString()).toList();
        selectedProduct = null;
      });
    }
  }

  Future<void> fetchLocation() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/location'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> locationList = json.decode(response.body);
      setState(() {
        locations = locationList.map((location) => location.toString()).toList();
      });
    }
  }

  Future<void> fetchDealer(String loc) async {
    final response = await http.get(
      Uri.parse("https://crmvercelfun.vercel.app/api/dealer?locality=$loc"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> dealers = json.decode(response.body);
      setState(() {
        dealerNames = dealers.map((dealer) => dealer['dealerName'].toString()).toList();
        selectedDealer = null;
      });
    }
  }

  Future<void> selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }
  Future<void> Searchcomplaints() async
  {

  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  bool validateInput() {
    if (nameController.text.isEmpty ||
        mobileController.text.length != 10 ||
        selectedCity == null ||
        selectedDealer == null ||
        selectedCategory == null ||
        selectedProduct == null ||
        selectedEmployee == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.person), text: "Employee"),
            Tab(icon: Icon(Icons.note), text: "Complaints & Requests"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: AddEmployee()),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: fromDateController,
                          decoration: InputDecoration(
                            labelText: 'From Date',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () => selectDate(context, fromDateController),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: toDateController,
                          decoration: InputDecoration(
                            labelText: 'To Date',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () => selectDate(context, toDateController),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            labelText: 'By Date',
                            hintText: 'Complaints Solved By Date',
                            border: OutlineInputBorder(),
                          ),
                          readOnly: true,
                          onTap: () => selectDate(context, dateController),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField<String>(
                          hint: Text('Complaint Status'),
                          value: selectedStatus,
                          onChanged: (value) => setState(() => selectedStatus = value),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          items: ['Pending', 'In progress', 'Closed']
                              .map((status) => DropdownMenuItem(
                            child: Text(status),
                            value: status,
                          ))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      errorText: nameController.text.isEmpty ? 'Name is required' : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      errorText: mobileController.text.length != 10 ? 'Enter a valid 10-digit number' : null,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Wrap(
                      direction: Axis.horizontal,
                      children:[ ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.2,maxHeight: 170),

                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField2(
                            value: selectedCity,
                            isExpanded: true,
                            decoration: InputDecoration(border: OutlineInputBorder()),
                            onChanged: (newValue) {
                              setState(() {
                                selectedCity = newValue;
                                fetchDealer(selectedCity!);
                              });
                            },
                            items: locations
                                .map((location) => DropdownMenuItem(
                              value: location,
                              child: Text(location,overflow: TextOverflow.visible),
                            ))
                                .toList(),
                          ),
                        ),
                      ),
                        ConstrainedBox
                          (
                          constraints:BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.20,maxHeight: 170),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownButtonFormField2(
                              value: selectedDealer,
                              isExpanded: true,
                              decoration: InputDecoration(border: OutlineInputBorder()),
                              onChanged: (value) => setState(() => selectedDealer = value),
                              items: dealerNames
                                  .map((dealer) => DropdownMenuItem(
                                value: dealer,
                                child: AutoSizeText(dealer, overflow: TextOverflow.visible),
                              ))
                                  .toList(),
                            ),
                          ),
                        ),
    ]
                    ),

                    ConstrainedBox
                      (constraints:BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.2,maxHeight: 170),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButtonFormField2(
                          decoration: InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
                          value: selectedCategory,
                          isExpanded: true,
                          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c,overflow: TextOverflow.visible))).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategory = newValue as String?;
                              if (newValue != null) fetchProductsForCategory(newValue);
                            });
                          },
                        ),
                      ),
                    ),
                    ConstrainedBox
                    (constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.2,maxHeight: 170),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: DropdownButtonFormField2(
                            value: selectedProduct,
                           isExpanded: true,
                        //    dropdownStyleData: DropdownStyleData(maxHeight: 150),
                            items:products.map((String product){
                              return DropdownMenuItem(value:product,child:AutoSizeText(product,overflow: TextOverflow.visible));}).toList()
                            , onChanged:(productselected)
                        {
                          setState(() {
                            selectedProduct=productselected;
                          });
                        }
                        ),
                      ),
                    ),

                  ],
                ),
                Row(
                children:[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton(
                        value: selectedEmployee,
                        isExpanded: true,
                        items:employees.map((String emp){
                          return DropdownMenuItem(value:emp,child:AutoSizeText(emp,overflow: TextOverflow.ellipsis));}).toList()
                        , onChanged:(employi)
                    {
                      setState(() {
                        selectedEmployee=employi;
                      });
                    }
                    ),
                  )
                ),
                  SizedBox(
                    width: 125,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:  DropdownButton(
    value:requesttype ,
    items:[
    DropdownMenuItem(value:'Complain',child: Text('Complain'),),
    DropdownMenuItem(value:'Service',child: Text('Service'),),
    DropdownMenuItem(value:'Installation',child: Text('Installation')),
    DropdownMenuItem(value:'demo',child:Text('demo')),
    ] , onChanged:(servicetype){
    setState(() {
    requesttype=servicetype;
    });
    } ),


                      ),
                    ),

                    ]
                ),
                ElevatedButton(onPressed: (){
                  Searchcomplaints();
                }, child:Text("Search request"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}