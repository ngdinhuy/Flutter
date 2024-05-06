import 'dart:convert';

import 'package:demo_app/Coin.dart';
import 'package:demo_app/IpModel.dart';
import 'package:http/http.dart' as http;

class NestworkRequest {
  static const String url = "https://api.ip2location.io/";

  static Future<IpModel?> getCoinApi() async {
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var coin = IpModel.fromJson(data);
      return coin;
    }
    return null;
  }
}