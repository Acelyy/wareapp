import 'package:wareapp/entry/warehouse.dart';

class RequestApplyList {
  Ejklysq ejklysq;
  int page;
  int rows;

  RequestApplyList({this.ejklysq, this.page, this.rows = 20});

  RequestApplyList.fromJson(Map<String, dynamic> json) {
    ejklysq =
    json['ejklysq'] != null ? new Ejklysq.fromJson(json['ejklysq']) : null;
    page = json['page'];
    rows = json['rows'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ejklysq != null) {
      data['ejklysq'] = this.ejklysq.toJson();
    }
    data['page'] = this.page;
    data['rows'] = this.rows;
    return data;
  }
}

class Ejklysq {
  DateTime sTime;
  DateTime eTime;
  String cjsjq;
  String cjsjz;
  String cjrcode;
  String lysqdbh;
  String ckbmPk;
  String bmmcbmPk;
  String sqr;
  String sqzt;
  String sqckzt;
  String ckmc;
  WareHouse ck;

  Ejklysq({this.cjsjq = "",
    this.cjsjz = "",
    this.cjrcode = "",
    this.lysqdbh = "",
    this.ckbmPk = "",
    this.bmmcbmPk = "",
    this.sqr = "",
    this.sqzt = "",
    this.sqckzt = ""});

  Ejklysq.fromJson(Map<String, dynamic> json) {
    cjsjq = json['cjsjq'];
    cjsjz = json['cjsjz'];
    cjrcode = json['cjrcode'];
    lysqdbh = json['lysqdbh'];
    ckbmPk = json['ckbm_pk'];
    bmmcbmPk = json['bmmcbm_pk'];
    sqr = json['sqr'];
    sqzt = json['sqzt'];
    sqckzt = json['sqckzt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cjsjq'] = this.cjsjq;
    data['cjsjz'] = this.cjsjz;
    data['cjrcode'] = this.cjrcode;
    data['lysqdbh'] = this.lysqdbh;
    data['ckbm_pk'] = this.ckbmPk;
    data["bmmcbm_pk"] = this.bmmcbmPk;
    data['sqr'] = this.sqr;
    data['sqzt'] = this.sqzt;
    data['sqckzt'] = this.sqckzt;
    return data;
  }
}
