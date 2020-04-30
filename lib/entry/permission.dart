class Permission {
  String rolecode;
  String funcname;
  String ejkckbmPk;
  String ejkckmc;
  List<Spr> sprtwoList;
  String bmmc;
  String sprnameone;
  String sprcodetwo;
  String sprcodeone;
  String ownercode;
  String name;
  String linkurl;
  String sprnametwo;
  String bmbmPk;
  String bmbh;
  List<Spr> sproneList;

  Permission(
      {this.rolecode,
        this.funcname,
        this.ejkckbmPk,
        this.ejkckmc,
        this.sprtwoList,
        this.bmmc,
        this.sprnameone,
        this.sprcodetwo,
        this.sprcodeone,
        this.ownercode,
        this.name,
        this.linkurl,
        this.sprnametwo,
        this.bmbmPk,
        this.bmbh,
        this.sproneList});

  Permission.fromJson(Map<String, dynamic> json) {
    rolecode = json['rolecode'];
    funcname = json['funcname'];
    ejkckbmPk = json['ejkckbm_pk'];
    ejkckmc = json['ejkckmc'];
    if (json['sprtwoList'] != null) {
      sprtwoList = new List<Spr>();
      json['sprtwoList'].forEach((v) {
        sprtwoList.add(new Spr.fromJson(v));
      });
    }
    bmmc = json['bmmc'];
    sprnameone = json['sprnameone'];
    sprcodetwo = json['sprcodetwo'];
    sprcodeone = json['sprcodeone'];
    ownercode = json['ownercode'];
    name = json['name'];
    linkurl = json['linkurl'];
    sprnametwo = json['sprnametwo'];
    bmbmPk = json['bmbm_pk'];
    bmbh = json['bmbh'];
    if (json['sproneList'] != null) {
      sproneList = new List<Spr>();
      json['sproneList'].forEach((v) {
        sproneList.add(new Spr.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rolecode'] = this.rolecode;
    data['funcname'] = this.funcname;
    data['ejkckbm_pk'] = this.ejkckbmPk;
    data['ejkckmc'] = this.ejkckmc;
    if (this.sprtwoList != null) {
      data['sprtwoList'] = this.sprtwoList.map((v) => v.toJson()).toList();
    }
    data['bmmc'] = this.bmmc;
    data['sprnameone'] = this.sprnameone;
    data['sprcodetwo'] = this.sprcodetwo;
    data['sprcodeone'] = this.sprcodeone;
    data['ownercode'] = this.ownercode;
    data['name'] = this.name;
    data['linkurl'] = this.linkurl;
    data['sprnametwo'] = this.sprnametwo;
    data['bmbm_pk'] = this.bmbmPk;
    data['bmbh'] = this.bmbh;
    if (this.sproneList != null) {
      data['sproneList'] = this.sproneList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Spr {
  String ckbmPk;
  String sprcode;
  String sprname;

  Spr({this.ckbmPk, this.sprcode, this.sprname});

  Spr.fromJson(Map<String, dynamic> json) {
    ckbmPk = json['ckbm_pk'];
    sprcode = json['sprcode'];
    sprname = json['sprname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ckbm_pk'] = this.ckbmPk;
    data['sprcode'] = this.sprcode;
    data['sprname'] = this.sprname;
    return data;
  }
}