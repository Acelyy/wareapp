import 'package:wareapp/entry/permission.dart';
import 'package:wareapp/entry/query_goods.dart';

class ApplyEntry {
  List<ApplyEntryList> list;
  int recordCount;

  ApplyEntry({this.list, this.recordCount});

  ApplyEntry.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = new List<ApplyEntryList>();
      json['list'].forEach((v) {
        list.add(new ApplyEntryList.fromJson(v));
      });
    }
    recordCount = json['recordCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    data['recordCount'] = this.recordCount;
    return data;
  }
}

class ApplyEntryList {
  String bmmc;
  String bmmcbmPk;
  String bz;
  String cjr;
  String cjrcode;
  String cjsj;
  String cjsjq;
  String cjsjz;
  String ckbmPk;
  String ckmc;
  String isSubmitOA;
  String lysqbmPk;
  String lysqdbh;
  String sprcodeone;
  String sprcodetwo;
  String sprnameone;
  String sprnametwo;
  String sprspjgone;
  String sprspjgtwo;
  String sprspsjone;
  String sprspsjtwo;
  String sprspyjone;
  String sprspyjtwo;
  String sqckzt;
  String sqr;
  String sqyy;
  String sqzt;
  String txbmPk;
  String xgr;
  String xgsj;
  String yxbz;
  Spr sprone;
  Spr sprtwo;

  ApplyEntryList(
      {this.bmmc,
        this.bmmcbmPk,
        this.bz,
        this.cjr,
        this.cjrcode,
        this.cjsj,
        this.cjsjq,
        this.cjsjz,
        this.ckbmPk,
        this.ckmc,
        this.isSubmitOA,
        this.lysqbmPk,
        this.lysqdbh,
        this.sprcodeone,
        this.sprcodetwo,
        this.sprnameone,
        this.sprnametwo,
        this.sprspjgone,
        this.sprspjgtwo,
        this.sprspsjone,
        this.sprspsjtwo,
        this.sprspyjone,
        this.sprspyjtwo,
        this.sqckzt,
        this.sqr,
        this.sqyy,
        this.sqzt,
        this.txbmPk,
        this.xgr,
        this.xgsj,
        this.yxbz});

  ApplyEntryList.fromJson(Map<String, dynamic> json) {
    bmmc = json['bmmc'];
    bmmcbmPk = json['bmmcbm_pk'];
    bz = json['bz'];
    cjr = json['cjr'];
    cjrcode = json['cjrcode'];
    cjsj = json['cjsj'];
    cjsjq = json['cjsjq'];
    cjsjz = json['cjsjz'];
    ckbmPk = json['ckbm_pk'];
    ckmc = json['ckmc'];
    isSubmitOA = json['isSubmitOA'];
    lysqbmPk = json['lysqbm_pk'];
    lysqdbh = json['lysqdbh'];
    sprcodeone = json['sprcodeone'];
    sprcodetwo = json['sprcodetwo'];
    sprnameone = json['sprnameone'];
    sprnametwo = json['sprnametwo'];
    sprspjgone = json['sprspjgone'];
    sprspjgtwo = json['sprspjgtwo'];
    sprspsjone = json['sprspsjone'];
    sprspsjtwo = json['sprspsjtwo'];
    sprspyjone = json['sprspyjone'];
    sprspyjtwo = json['sprspyjtwo'];
    sqckzt = json['sqckzt'];
    sqr = json['sqr'];
    sqyy = json['sqyy'];
    sqzt = json['sqzt'];
    txbmPk = json['txbm_pk'];
    xgr = json['xgr'];
    xgsj = json['xgsj'];
    yxbz = json['yxbz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bmmc'] = this.bmmc;
    data['bmmcbm_pk'] = this.bmmcbmPk;
    data['bz'] = this.bz;
    data['cjr'] = this.cjr;
    data['cjrcode'] = this.cjrcode;
    data['cjsj'] = this.cjsj;
    data['cjsjq'] = this.cjsjq;
    data['cjsjz'] = this.cjsjz;
    data['ckbm_pk'] = this.ckbmPk;
    data['ckmc'] = this.ckmc;
    data['isSubmitOA'] = this.isSubmitOA;
    data['lysqbm_pk'] = this.lysqbmPk;
    data['lysqdbh'] = this.lysqdbh;
    data['sprcodeone'] = this.sprcodeone;
    data['sprcodetwo'] = this.sprcodetwo;
    data['sprnameone'] = this.sprnameone;
    data['sprnametwo'] = this.sprnametwo;
    data['sprspjgone'] = this.sprspjgone;
    data['sprspjgtwo'] = this.sprspjgtwo;
    data['sprspsjone'] = this.sprspsjone;
    data['sprspsjtwo'] = this.sprspsjtwo;
    data['sprspyjone'] = this.sprspyjone;
    data['sprspyjtwo'] = this.sprspyjtwo;
    data['sqckzt'] = this.sqckzt;
    data['sqr'] = this.sqr;
    data['sqyy'] = this.sqyy;
    data['sqzt'] = this.sqzt;
    data['txbm_pk'] = this.txbmPk;
    data['xgr'] = this.xgr;
    data['xgsj'] = this.xgsj;
    data['yxbz'] = this.yxbz;
    return data;
  }
}

class SubmitApply {
  ApplyEntryList ejklysq;
  List<GoodsBean> ejklymxList;

  SubmitApply({this.ejklysq, this.ejklymxList});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["ejklysq"] = this.ejklysq.toJson();
    data["ejklymxList"] = this.ejklymxList;
    return data;
  }
}

class ApplyDetail{
  List<GoodsBean> ejklymxList;
  ApplyEntryList ejklysq;

  ApplyDetail({this.ejklysq,this.ejklymxList});

  ApplyDetail.fromJson(Map<String, dynamic> json){
    this.ejklysq = ApplyEntryList.fromJson(json['ejklysq']);
    if (json['ejklymxList'] != null) {
      ejklymxList = new List<GoodsBean>();
      json['ejklymxList'].forEach((v) {
        ejklymxList.add(new GoodsBean.fromJson(v));
      });
    }
  }
}

class ApplyOut{
  List<GoodsBean> ejklymxList;
  ApplyEntryList ejklysq;

  ApplyOut({this.ejklysq,this.ejklymxList});

  ApplyOut.fromJson(Map<String, dynamic> json){
    this.ejklysq = ApplyEntryList.fromJson(json['ejklysq']);
    if (json['ejklymxList'] != null) {
      ejklymxList = new List<GoodsBean>();
      json['ejklymxList'].forEach((v) {
        ejklymxList.add(new GoodsBean.fromJson(v));
      });
    }
  }
}
