import 'dart:convert';
import 'package:http/http.dart' as http;

class dealerfetcher
{
static  Future<List<String>> fetchLocation() async {
    final response = await http.get(
      Uri.parse('https://crmvercelfun.vercel.app/api/location'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> locationList = json.decode(response.body);
      return locationList.map((loc) => loc.toString()).toList();
    }
    else
    {
      throw Exception('Failed to load dealers');
    }
  }

static  Future<List<String>> fetchDealer(String loc) async {
    final response = await http.get(
      Uri.parse("https://crmvercelfun.vercel.app/api/dealer?locality=$loc"),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> dealers = json.decode(response.body);
      return dealers.map((dealer) => dealer['dealerName'].toString()).toList();
    }
    else
      {
        throw Exception('Failed to load dealers');
      }
  }

}
// setState(() {
// locations = locationList.map((location) => location.toString()).toList();
// });