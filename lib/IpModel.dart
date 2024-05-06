class IpModel{
  String ip;
  String country_name;
  String as;

  IpModel(this.ip, this.country_name, this.as);

  factory IpModel.fromJson(Map<String, dynamic> json) {
    return IpModel(
      json['ip'],
      json['country_name'],
      json['as'],
    );
  }
}