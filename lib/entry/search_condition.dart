
class SearchCondition {
  int page;
  int rows;
  SearchConditionMapBean map;

  SearchCondition({this.page, this.rows, this.map});

  SearchCondition.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    rows = json['rows'];
    map = json['map'] != null ? new SearchConditionMapBean.fromJson(json['map']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['rows'] = this.rows;
    if (this.map != null) {
      data['map'] = this.map.toJson();
    }
    return data;
  }
}

class SearchConditionMapBean {
  String wztm;
  String wzmc;
  String ggxh;
  String hjh;
  String ckbmPk;
  String zklb;

  SearchConditionMapBean({this.wztm, this.wzmc, this.ggxh, this.hjh, this.ckbmPk, this.zklb="1"});

  SearchConditionMapBean.fromJson(Map<String, dynamic> json) {
    wztm = json['wztm'];
    wzmc = json['wzmc'];
    ggxh = json['ggxh'];
    hjh = json['hjh'];
    ckbmPk = json['ckbm_pk'];
    zklb = json['zklb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wztm'] = this.wztm;
    data['wzmc'] = this.wzmc;
    data['ggxh'] = this.ggxh;
    data['hjh'] = this.hjh;
    data['ckbm_pk'] = this.ckbmPk;
    data['zklb'] = this.zklb;
    return data;
  }
}