class WareHouse {
  String ckbmPk;
  String ckmc;
  String fgsbmPk;

  WareHouse({this.ckbmPk, this.ckmc, this.fgsbmPk});

  WareHouse.fromJson(Map<String, dynamic> json) {
    ckbmPk = json['ckbm_pk'];
    ckmc = json['ckmc'];
    fgsbmPk = json['fgsbm_pk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ckbm_pk'] = this.ckbmPk;
    data['ckmc'] = this.ckmc;
    data['fgsbm_pk'] = this.fgsbmPk;
    return data;
  }
}