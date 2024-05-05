import 'dart:ffi';

class Coin {
  String? disclaimer;
  String? chartName;
  BPI? bpi;

  Coin({this.disclaimer, this.chartName, this.bpi});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      disclaimer: json['disclaimer'],
      chartName: json['chartName'],
      bpi: json['bpi'] != null ? BPI.fromJson(json['bpi']) : null,
    );
  }
}

class BPI {
  USD? usd;

  BPI({this.usd});

  factory BPI.fromJson(Map<String, dynamic> json) {
    return BPI(
      usd: json['USD'] != null ? USD.fromJson(json['USD']) : null,
    );
  }
}

class USD {
  String? code, rate, description;
  double? rateFloat;

  USD({this.code, this.rate, this.description, this.rateFloat});

  factory USD.fromJson(Map<String, dynamic> json) {
    return USD(
      code: json['code'],
      rate: json['rate'],
      description: json['description'],
      rateFloat: json['rate_float']?.toDouble(),
    );
  }
}

// extension
extension MyUSD on USD {
  void printCode() {
    print(code);
  }
}