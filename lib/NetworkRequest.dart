import 'dart:convert';

import 'package:demo_app/Coin.dart';
import 'package:http/http.dart' as http;

class NestworkRequest {
  static const String url = "https://api.coindesk.com/v1/bpi/currentprice.json";

  static Future<Coin?> getCoinApi() async {
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      var coin = Coin.fromJson(data);
      return coin;
    }
    return null;
  }
}