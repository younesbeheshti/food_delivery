import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HttpRequest{
  // Uri url = "https://mvs.bslmeiyu.com/api/v1/products/popular";
  Future<void> getRequest() async {
    try{
    http.Response response = await http.get(Uri.parse('https://mvs.bslmeiyu.com/api/v1/products/popular'));
    Map data = jsonDecode(response.body);
    print(" status code${response.statusCode}");
    print(" this the body : ${data}");

    }catch(e) {
      print(e.toString());
    }
  }
}